import 'package:equatable/equatable.dart';

class OfficeLocation extends Equatable {
  const OfficeLocation({
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
  });

  final double latitude;
  final double longitude;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [latitude, longitude, updatedAt];
}
