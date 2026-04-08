import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/usecases/usecase.dart';
import '/features/attendance/domain/usecases/check_attendance_eligibility.dart';
import '/features/attendance/domain/usecases/ensure_location_permission.dart';
import '/features/attendance/domain/usecases/ensure_location_service.dart';
import '/features/attendance/domain/usecases/get_office_location.dart';
import '/features/attendance/domain/usecases/get_today_attendance.dart';
import '/features/attendance/domain/usecases/is_location_permission_granted.dart';
import '/features/attendance/domain/usecases/is_location_service_enabled.dart';
import '/features/attendance/domain/usecases/is_precise_location_permission_granted.dart';
import '/features/attendance/domain/usecases/mark_attendance.dart';
import '/features/attendance/domain/usecases/open_app_settings.dart';
import '/features/attendance/domain/usecases/open_location_settings.dart';
import '/features/attendance/domain/usecases/save_office_location.dart';
import '/features/attendance/domain/usecases/watch_attendance_history.dart';
import '/features/attendance/domain/usecases/watch_live_distance.dart';
import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit({
    required EnsureLocationPermission ensureLocationPermission,
    required EnsureLocationService ensureLocationService,
    required IsLocationPermissionGranted isLocationPermissionGranted,
    required IsLocationServiceEnabled isLocationServiceEnabled,
    required IsPreciseLocationPermissionGranted
    isPreciseLocationPermissionGranted,
    required GetOfficeLocation getOfficeLocation,
    required SaveOfficeLocation saveOfficeLocation,
    required GetTodayAttendance getTodayAttendance,
    required MarkAttendance markAttendance,
    required WatchLiveDistance watchLiveDistance,
    required WatchAttendanceHistory watchAttendanceHistory,
    required CheckAttendanceEligibility checkAttendanceEligibility,
    required OpenAppSettings openAppSettings,
    required OpenLocationSettings openLocationSettings,
  }) : _ensureLocationPermission = ensureLocationPermission,
       _ensureLocationService = ensureLocationService,
       _isLocationPermissionGranted = isLocationPermissionGranted,
       _isLocationServiceEnabled = isLocationServiceEnabled,
       _isPreciseLocationPermissionGranted = isPreciseLocationPermissionGranted,
       _getOfficeLocation = getOfficeLocation,
       _saveOfficeLocation = saveOfficeLocation,
       _getTodayAttendance = getTodayAttendance,
       _markAttendance = markAttendance,
       _watchLiveDistance = watchLiveDistance,
       _watchAttendanceHistory = watchAttendanceHistory,
       _checkAttendanceEligibility = checkAttendanceEligibility,
       _openAppSettings = openAppSettings,
       _openLocationSettings = openLocationSettings,
       super(const AttendanceState());

  final EnsureLocationPermission _ensureLocationPermission;
  final EnsureLocationService _ensureLocationService;
  final IsLocationPermissionGranted _isLocationPermissionGranted;
  final IsLocationServiceEnabled _isLocationServiceEnabled;
  final IsPreciseLocationPermissionGranted _isPreciseLocationPermissionGranted;
  final GetOfficeLocation _getOfficeLocation;
  final SaveOfficeLocation _saveOfficeLocation;
  final GetTodayAttendance _getTodayAttendance;
  final MarkAttendance _markAttendance;
  final WatchLiveDistance _watchLiveDistance;
  final WatchAttendanceHistory _watchAttendanceHistory;
  final CheckAttendanceEligibility _checkAttendanceEligibility;
  final OpenAppSettings _openAppSettings;
  final OpenLocationSettings _openLocationSettings;

  StreamSubscription<double>? _distanceSubscription;
  StreamSubscription? _historySubscription;
  Timer? _serviceGuardTimer;
  bool _serviceRequestInProgress = false;
  bool _isAppInForeground = true;

  Future<void> initialize() async {
    emit(state.copyWith(status: AttendanceViewStatus.loading, message: null));

    final permissionGranted = await _requestPermissionWithRetry();
    if (!permissionGranted) {
      _emitPermissionBlocked();
      return;
    }

    final serviceResult = await _ensureLocationService(NoParams());
    final serviceEnabled = serviceResult.fold((_) => false, (ok) => ok);
    if (!serviceEnabled) {
      _emitServiceBlocked();
      _startServiceGuard();
      return;
    }

    final preciseResult = await _isPreciseLocationPermissionGranted(NoParams());
    final preciseGranted = preciseResult.fold((_) => false, (ok) => ok);
    if (!preciseGranted) {
      _emitPermissionBlocked(
        message: 'Precise location permission is required',
      );
      _startServiceGuard();
      return;
    }
    _startServiceGuard();

    final officeResult = await _getOfficeLocation(NoParams());
    final office = officeResult.fold((_) => null, (value) => value);

    final todayResult = await _getTodayAttendance(NoParams());
    final todayRecord = todayResult.fold((_) => null, (value) => value);

    await _listenHistory();

    if (office == null) {
      emit(
        state.copyWith(
          status: AttendanceViewStatus.noOfficeLocation,
          officeLocation: null,
          todayRecord: todayRecord,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AttendanceViewStatus.ready,
        officeLocation: office,
        todayRecord: todayRecord,
      ),
    );
    _listenDistance();
  }

  Future<void> initializeHistoryOnly() async {
    emit(state.copyWith(status: AttendanceViewStatus.loading, message: null));
    await _listenHistory(waitForFirstEmission: true);
    emit(state.copyWith(status: AttendanceViewStatus.ready));
  }

  Future<void> setOfficeLocationFromCurrent() async {
    emit(state.copyWith(isSubmitting: true, message: null));
    final result = await _saveOfficeLocation(NoParams());

    await result.fold(
      (failure) async {
        emit(state.copyWith(isSubmitting: false, message: failure.message));
      },
      (office) async {
        emit(
          state.copyWith(
            status: AttendanceViewStatus.ready,
            officeLocation: office,
            isSubmitting: false,
            message: null,
          ),
        );
        await _distanceSubscription?.cancel();
        _listenDistance();
      },
    );
  }

  Future<void> markAttendance() async {
    final eligibility = state.eligibility;
    if (eligibility == null || !eligibility.canMarkNow) {
      return;
    }

    emit(state.copyWith(isSubmitting: true, message: null));
    final result = await _markAttendance(
      MarkAttendanceParams(
        isLate: eligibility.isLate,
        distanceMeters: state.distanceMeters,
      ),
    );

    await result.fold(
      (failure) async {
        emit(state.copyWith(isSubmitting: false, message: failure.message));
      },
      (record) async {
        final nextEligibility = _checkAttendanceEligibility(
          CheckAttendanceEligibilityParams(
            distanceMeters: state.distanceMeters,
            todayRecord: record,
          ),
        );
        emit(
          state.copyWith(
            todayRecord: record,
            eligibility: nextEligibility,
            isSubmitting: false,
          ),
        );
      },
    );
  }

  Future<void> openPermissionSettings() async {
    await _openAppSettings(NoParams());
  }

  Future<void> openServiceSettings() async {
    await _openLocationSettings(NoParams());
  }

  Future<void> reload() async {
    await _distanceSubscription?.cancel();
    await initialize();
  }

  Future<void> recheckGateFromSystem() async {
    if (isClosed) {
      return;
    }

    final permissionResult = await _isLocationPermissionGranted(NoParams());
    final permissionGranted = permissionResult.fold((_) => false, (ok) => ok);
    if (!permissionGranted) {
      _emitPermissionBlocked();
      return;
    }

    final serviceResult = await _isLocationServiceEnabled(NoParams());
    final serviceEnabled = serviceResult.fold((_) => false, (ok) => ok);
    if (!serviceEnabled) {
      _emitServiceBlocked();
      _startServiceGuard();
      return;
    }

    final preciseResult = await _isPreciseLocationPermissionGranted(NoParams());
    final preciseGranted = preciseResult.fold((_) => false, (ok) => ok);
    if (!preciseGranted) {
      _emitPermissionBlocked(
        message: 'Precise location permission is required',
      );
      return;
    }

    await reload();
  }

  void _startServiceGuard() {
    if (!_isAppInForeground || isClosed) {
      return;
    }
    _serviceGuardTimer?.cancel();
    _serviceGuardTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      await _runServiceGuardTick();
    });
  }

  Future<void> _runServiceGuardTick() async {
    if (_serviceRequestInProgress || !_isAppInForeground || isClosed) {
      return;
    }

    final permissionResult = await _isLocationPermissionGranted(NoParams());
    final permissionGranted = permissionResult.fold((_) => false, (ok) => ok);
    if (!permissionGranted) {
      return;
    }

    final serviceState = await _isLocationServiceEnabled(NoParams());
    final isEnabled = serviceState.fold((_) => false, (ok) => ok);
    if (isEnabled) {
      if (state.status == AttendanceViewStatus.serviceBlocked) {
        await reload();
      }
      return;
    }

    _emitServiceBlocked();
    _serviceRequestInProgress = true;
    final requestResult = await _ensureLocationService(NoParams());
    _serviceRequestInProgress = false;
    final enabledAfterRequest = requestResult.fold((_) => false, (ok) => ok);
    if (enabledAfterRequest) {
      await reload();
    }
  }

  Future<bool> _requestPermissionWithRetry() async {
    final first = await _ensureLocationPermission(NoParams());
    final grantedFirst = first.fold((_) => false, (ok) => ok);
    if (grantedFirst) {
      return true;
    }

    final second = await _ensureLocationPermission(NoParams());
    return second.fold((_) => false, (ok) => ok);
  }

  void _emitPermissionBlocked({String? message}) {
    if (isClosed) {
      return;
    }
    emit(
      state.copyWith(
        status: AttendanceViewStatus.permissionBlocked,
        message: message,
        gateVersion: state.gateVersion + 1,
      ),
    );
  }

  void _emitServiceBlocked() {
    if (isClosed) {
      return;
    }
    emit(
      state.copyWith(
        status: AttendanceViewStatus.serviceBlocked,
        message: null,
        gateVersion: state.gateVersion + 1,
      ),
    );
  }

  void _listenDistance() {
    _distanceSubscription = _watchLiveDistance().listen((distance) {
      if (isClosed) {
        return;
      }
      final eligibility = _checkAttendanceEligibility(
        CheckAttendanceEligibilityParams(
          distanceMeters: distance,
          todayRecord: state.todayRecord,
        ),
      );
      emit(state.copyWith(distanceMeters: distance, eligibility: eligibility));
    });
  }

  Future<void> _listenHistory({bool waitForFirstEmission = false}) async {
    await _historySubscription?.cancel();
    final firstEmission = waitForFirstEmission ? Completer<void>() : null;
    _historySubscription = _watchAttendanceHistory().listen(
      (records) {
        if (isClosed) {
          return;
        }
        emit(state.copyWith(history: records));
        if (firstEmission != null && !firstEmission.isCompleted) {
          firstEmission.complete();
        }
      },
      onError: (_) {
        if (isClosed) {
          return;
        }
        emit(
          state.copyWith(
            status: AttendanceViewStatus.error,
            message: 'Failed to load attendance history',
          ),
        );
        if (firstEmission != null && !firstEmission.isCompleted) {
          firstEmission.complete();
        }
      },
    );
    if (firstEmission != null) {
      await firstEmission.future;
    }
  }

  void onAppMovedToBackground() {
    _isAppInForeground = false;
    _serviceGuardTimer?.cancel();
  }

  void onAppReturnedToForeground() {
    _isAppInForeground = true;
    _startServiceGuard();
  }

  @override
  Future<void> close() async {
    await _distanceSubscription?.cancel();
    await _historySubscription?.cancel();
    _serviceGuardTimer?.cancel();
    return super.close();
  }
}
