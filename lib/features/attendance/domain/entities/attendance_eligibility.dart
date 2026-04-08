import 'package:equatable/equatable.dart';
import '/features/attendance/domain/entities/attendance_record.dart';

class AttendanceEligibility extends Equatable {
  const AttendanceEligibility({
    required this.inRange,
    required this.canMarkNow,
    required this.isLate,
    required this.isAlreadyMarked,
    this.markedRecord,
  });

  final bool inRange;
  final bool canMarkNow;
  final bool isLate;
  final bool isAlreadyMarked;
  final AttendanceRecordEntity? markedRecord;

  @override
  List<Object?> get props => [
    inRange,
    canMarkNow,
    isLate,
    isAlreadyMarked,
    markedRecord,
  ];
}
