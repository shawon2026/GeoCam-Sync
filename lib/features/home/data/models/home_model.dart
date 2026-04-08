import '../../domain/entities/home.dart';

class HomeModel extends Home {
  const HomeModel({
    required super.id,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

