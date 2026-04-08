import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/di/service_locator.dart';
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
  late final AttendanceCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<AttendanceCubit>()..initialize();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }

          if (state.status == AttendanceViewStatus.permissionBlocked) {
            _showGateDialog(
              title: context.loc.locationPermissionRequiredTitle,
              message: state.message ?? context.loc.locationPermissionRequired,
              actionText: context.loc.goToSettings,
              onAction: _cubit.openPermissionSettings,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<AttendanceCubit>();

          return Scaffold(
            backgroundColor: const Color(0xFFF3F5F9),
            appBar: GlobalAppBar(
              title: context.loc.attendanceTitle,
              actions: [
                IconButton(
                  onPressed: () {
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
                padding: const EdgeInsets.all(16),
                children: [
                  OfficeContextCard(
                    hasOfficeLocation: state.officeLocation != null,
                    officeCoordinateText: state.officeLocation == null
                        ? null
                        : 'Lat : ${state.officeLocation!.latitude.toStringAsFixed(4)},  Lon : ${state.officeLocation!.longitude.toStringAsFixed(4)}',
                    onSetOfficeLocation: cubit.setOfficeLocationFromCurrent,
                  ),
                  const SizedBox(height: 24),
                  DistanceTrackerCard(
                    distanceMeters: state.distanceMeters,
                    inRange: state.eligibility?.inRange ?? false,
                  ),
                  const SizedBox(height: 10),
                  AttendanceStatusLabel(text: context.loc.attendanceRuleLabel),
                  const SizedBox(height: 20),
                  AttendanceActionCard(
                    title: _title(context, state),
                    subtitle: _subtitle(context, state),
                    buttonLabel: _button(context, state),
                    enabled: _isActionEnabled(state),
                    isLoading: state.isSubmitting,
                    onMark: () => _onMarkTap(context, cubit, state),
                    availabilityText: context.loc.attendanceAvailabilityWindow,
                    showLockIcon: !_isActionEnabled(state),
                  ),
                  const SizedBox(height: 12),
                  if (state.todayRecord != null)
                    Text(
                      '${context.loc.attendanceMarkedAt}: ${DateTimeHelper.toDateTimeLabel(state.todayRecord!.markedAt)}',
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
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
            title: Text(title),
            content: Text(message),
            actions: [
              FilledButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await onAction();
                },
                child: Text(actionText),
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

    if (alreadyMarked && !inRange) {
      return context.loc.attendanceAlreadyMarked;
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
          ? context.loc.enterWithinRangeForLate
          : context.loc.moveWithinRange;
    }
    if (alreadyMarked) {
      return context.loc.attendanceAlreadyMarked;
    }
    return context.loc.attendanceReady;
  }

  bool _isActionEnabled(AttendanceState state) {
    final eligibility = state.eligibility;
    if (eligibility == null) {
      return false;
    }
    if (eligibility.canMarkNow) {
      return true;
    }
    if (eligibility.isAlreadyMarked && eligibility.inRange) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.attendanceAlreadyMarked)),
      );
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
}
