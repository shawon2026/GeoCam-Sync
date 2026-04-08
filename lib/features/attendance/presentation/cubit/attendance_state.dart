import 'package:equatable/equatable.dart';
import '/features/attendance/domain/entities/attendance_eligibility.dart';
import '/features/attendance/domain/entities/attendance_record.dart';
import '/features/attendance/domain/entities/office_location.dart';

enum AttendanceViewStatus {
  initial,
  loading,
  permissionBlocked,
  serviceBlocked,
  noOfficeLocation,
  ready,
  error,
}

class AttendanceState extends Equatable {
  const AttendanceState({
    this.status = AttendanceViewStatus.initial,
    this.message,
    this.distanceMeters = double.infinity,
    this.officeLocation,
    this.todayRecord,
    this.eligibility,
    this.history = const [],
    this.isSubmitting = false,
    this.gateVersion = 0,
  });

  final AttendanceViewStatus status;
  final String? message;
  final double distanceMeters;
  final OfficeLocation? officeLocation;
  final AttendanceRecordEntity? todayRecord;
  final AttendanceEligibility? eligibility;
  final List<AttendanceRecordEntity> history;
  final bool isSubmitting;
  final int gateVersion;

  bool get isOverlayLoading =>
      status == AttendanceViewStatus.loading || isSubmitting;

  AttendanceState copyWith({
    AttendanceViewStatus? status,
    String? message,
    double? distanceMeters,
    OfficeLocation? officeLocation,
    AttendanceRecordEntity? todayRecord,
    AttendanceEligibility? eligibility,
    List<AttendanceRecordEntity>? history,
    bool? isSubmitting,
    int? gateVersion,
  }) {
    return AttendanceState(
      status: status ?? this.status,
      message: message,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      officeLocation: officeLocation ?? this.officeLocation,
      todayRecord: todayRecord ?? this.todayRecord,
      eligibility: eligibility ?? this.eligibility,
      history: history ?? this.history,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      gateVersion: gateVersion ?? this.gateVersion,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    distanceMeters,
    officeLocation,
    todayRecord,
    eligibility,
    history,
    isSubmitting,
    gateVersion,
  ];
}
