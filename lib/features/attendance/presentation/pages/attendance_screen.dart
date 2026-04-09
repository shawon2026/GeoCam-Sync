import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/presentation/widgets/global_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/di/service_locator.dart';
import '/core/constants/attendance_constants.dart';
import '/core/presentation/view_util.dart';
import '/core/presentation/widgets/global_appbar.dart';
import '/core/routes/app_routes.dart';
import '/core/routes/navigation.dart';
import '/core/utils/date_time_helper.dart';
import '/core/utils/extension.dart';
import '/features/attendance/presentation/cubit/attendance_cubit.dart';
import '/features/attendance/presentation/cubit/attendance_state.dart';
import '/features/attendance/presentation/widgets/attendance_action_card.dart';
import '/features/attendance/presentation/widgets/attendance_status_label.dart';
import '/features/attendance/presentation/widgets/distance_tracker_card.dart';
import '/features/attendance/presentation/widgets/office_context_card.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with WidgetsBindingObserver {
  bool _isGateDialogVisible = false;
  bool _isLoaderVisible = false;
  late final AttendanceCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<AttendanceCubit>();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _cubit.initialize();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_isLoaderVisible) {
      ViewUtil.hideLoader(context);
      _isLoaderVisible = false;
    }
    _cubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      _cubit.onAppReturnedToForeground();
      _cubit.recheckGateFromSystem();
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _cubit.onAppMovedToBackground();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<AttendanceCubit, AttendanceState>(
        listenWhen: (previous, current) =>
            previous.message != current.message ||
            previous.gateVersion != current.gateVersion ||
            previous.isOverlayLoading != current.isOverlayLoading,
        listener: (context, state) {
          _syncLoader(state);

          if (state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: GlobalText.raw(state.message!)));
          }

          if (state.status == AttendanceViewStatus.permissionBlocked) {
            _showGateDialog(
              title: context.loc.locationPermissionRequiredTitle,
              message: state.message ?? context.loc.locationPermissionRequired,
              actionText: context.loc.goToSettings,
              onAction: _cubit.openPermissionSettings,
            );
            return;
          }

          if (state.status == AttendanceViewStatus.serviceBlocked) {
            _showGateDialog(
              title: context.loc.locationServiceRequiredTitle,
              message: context.loc.locationServiceRequired,
              actionText: context.loc.goToSettings,
              onAction: _cubit.openServiceSettings,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<AttendanceCubit>();

          return PopScope(
            canPop: !state.isOverlayLoading,
            child: Scaffold(
              backgroundColor: const Color(0xFFF3F5F9),
              appBar: GlobalAppBar(
                title: context.loc.attendanceTitle,
                actions: [
                  IconButton(
                    onPressed: state.isOverlayLoading
                        ? null
                        : () {
                            Navigation.push(
                              context,
                              appRoutes: AppRoutes.attendanceHistory,
                            );
                          },
                    icon: const Icon(Icons.history),
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: cubit.reload,
                child: ListView(
                  padding: EdgeInsets.all(16.r),
                  physics: state.isOverlayLoading
                      ? const NeverScrollableScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  children: [
                    OfficeContextCard(
                      hasOfficeLocation: state.officeLocation != null,
                      officeCoordinateText: state.officeLocation == null
                          ? null
                          : 'Lat : ${state.officeLocation!.latitude.toStringAsFixed(4)},  Lon : ${state.officeLocation!.longitude.toStringAsFixed(4)}',
                      onSetOfficeLocation: cubit.setOfficeLocationFromCurrent,
                    ),
                    SizedBox(height: 24.h),
                    DistanceTrackerCard(
                      distanceMeters: state.distanceMeters,
                      inRange: state.eligibility?.inRange ?? false,
                    ),
                    SizedBox(height: 10.h),
                    AttendanceStatusLabel(
                      text: context.loc.attendanceRuleLabel,
                    ),
                    SizedBox(height: 20.h),
                    AttendanceActionCard(
                      title: _title(context, state),
                      subtitle: _subtitle(context, state),
                      markedAtText: state.todayRecord == null
                          ? null
                          : '${context.loc.attendanceMarkedAt}: ${DateTimeHelper.toDateTimeLabel(state.todayRecord!.markedAt)}',
                      buttonLabel: _button(context, state),
                      enabled: _isActionEnabled(state),
                      isLoading: state.isSubmitting,
                      onMark: () => _onMarkTap(context, cubit, state),
                      availabilityText: _availabilityWindowText(context),
                      isMarked: state.eligibility?.isAlreadyMarked ?? false,
                      isMarkedLate: state.todayRecord?.status.name == 'late',
                      isLateAction:
                          (state.eligibility?.isLate ?? false) &&
                          !(state.eligibility?.isAlreadyMarked ?? false),
                      showLockIcon: !_isActionEnabled(state),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _syncLoader(AttendanceState state) {
    if (!mounted) {
      return;
    }

    if (state.isOverlayLoading && !_isLoaderVisible) {
      _isLoaderVisible = true;
      ViewUtil.showLoader(context).then((_) {
        _isLoaderVisible = false;
      });
      return;
    }

    if (!state.isOverlayLoading && _isLoaderVisible) {
      ViewUtil.hideLoader(context);
    }
  }

  Future<void> _showGateDialog({
    required String title,
    required String message,
    required String actionText,
    required Future<void> Function() onAction,
  }) async {
    if (!mounted || _isGateDialogVisible) {
      return;
    }
    _isGateDialogVisible = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: GlobalText.raw(title),
            content: GlobalText.raw(message),
            actions: [
              FilledButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await onAction();
                },
                child: GlobalText.raw(actionText),
              ),
            ],
          ),
        );
      },
    );
    _isGateDialogVisible = false;
  }

  String _title(BuildContext context, AttendanceState state) {
    if (state.eligibility?.isAlreadyMarked == true) {
      return state.todayRecord?.status.name == 'late'
          ? context.loc.lateAttendanceMarked
          : context.loc.attendanceMarked;
    }
    if (state.eligibility?.isLate == true) {
      return context.loc.markLateAttendance;
    }
    return context.loc.markAttendance;
  }

  String _subtitle(BuildContext context, AttendanceState state) {
    final inRange = state.eligibility?.inRange ?? false;
    final alreadyMarked = state.eligibility?.isAlreadyMarked ?? false;
    final isLate = state.eligibility?.isLate ?? false;

    if (alreadyMarked) {
      return '';
    }
    if (!alreadyMarked &&
        inRange &&
        !isLate &&
        DateTimeHelper.now().isBefore(
          DateTimeHelper.startWindow(DateTimeHelper.now()),
        )) {
      return context.loc.attendanceEarlyArrival;
    }
    if (!inRange) {
      return isLate
          ? context.loc.enterWithinRangeForLateDynamic(_rangeMetersLabel)
          : context.loc.moveWithinRangeDynamic(_rangeMetersLabel);
    }
    return context.loc.attendanceReady;
  }

  bool _isActionEnabled(AttendanceState state) {
    final eligibility = state.eligibility;
    if (eligibility == null) {
      return false;
    }
    if (eligibility.isAlreadyMarked) {
      return false;
    }
    if (eligibility.canMarkNow) {
      return true;
    }
    return false;
  }

  void _onMarkTap(
    BuildContext context,
    AttendanceCubit cubit,
    AttendanceState state,
  ) {
    final eligibility = state.eligibility;
    if (eligibility == null) {
      return;
    }
    if (eligibility.isAlreadyMarked) {
      return;
    }
    cubit.markAttendance();
  }

  String _button(BuildContext context, AttendanceState state) {
    if (state.eligibility?.isAlreadyMarked == true) {
      return context.loc.attendanceMarked;
    }
    if (state.eligibility?.isLate == true) {
      return context.loc.markLateAttendance;
    }
    return context.loc.markAttendance;
  }

  String _availabilityWindowText(BuildContext context) {
    final startLabel = DateTimeHelper.toWindowTimeLabel(
      hour: AttendanceConstants.attendanceStartHour.value.toInt(),
      minute: AttendanceConstants.attendanceStartMinute.value.toInt(),
    );
    final endLabel = DateTimeHelper.toWindowTimeLabel(
      hour: AttendanceConstants.lateThresholdHour.value.toInt(),
      minute: AttendanceConstants.lateThresholdMinute.value.toInt(),
    );
    return context.loc.attendanceAvailabilityWindowDynamic(
      startLabel,
      endLabel,
    );
  }

  String get _rangeMetersLabel =>
      AttendanceConstants.inRangeThresholdMeters.value.toStringAsFixed(0);
}
