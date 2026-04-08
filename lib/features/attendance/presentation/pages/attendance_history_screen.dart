import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/di/service_locator.dart';
import '/core/presentation/widgets/global_appbar.dart';
import '/core/utils/extension.dart';
import '/features/attendance/presentation/cubit/attendance_cubit.dart';
import '/features/attendance/presentation/cubit/attendance_state.dart';
import '/features/attendance/presentation/widgets/attendance_history_card.dart';
import '/features/attendance/presentation/widgets/attendance_history_shimmer_list.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AttendanceCubit>()..initializeHistoryOnly(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5F9),
        appBar: GlobalAppBar(title: context.loc.attendanceHistoryTitle),
        body: BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            if (state.status == AttendanceViewStatus.loading) {
              return const AttendanceHistoryShimmerList();
            }

            if (state.history.isEmpty) {
              return Center(child: Text(context.loc.noAttendanceHistory));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.history.length,
              separatorBuilder: (_, separatorIndex) =>
                  const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = state.history[index];
                return AttendanceHistoryCard(item: item);
              },
            );
          },
        ),
      ),
    );
  }
}
