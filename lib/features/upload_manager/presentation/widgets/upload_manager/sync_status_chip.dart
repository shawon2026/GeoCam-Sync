import 'package:flutter/material.dart';

import '/features/upload_manager/domain/entities/sync_status.dart';

class SyncStatusChip extends StatelessWidget {
  const SyncStatusChip({
    required this.networkLabel,
    required this.phase,
    super.key,
  });

  final String networkLabel;
  final SyncPhase phase;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 10, color: Color(0xFF22C58B)),
          const SizedBox(width: 8),
          Text(
            '$networkLabel  ${phase.name.toUpperCase()}',
            style: const TextStyle(
              color: Color(0xFF15803D),
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}
