import 'home_model.dart';

class HomeResponse {
  final List<HomeModel> homeList;
  final int total;

  HomeResponse({required this.homeList, required this.total});

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      homeList: (json['homes'] as List)
          .map((item) => HomeModel.fromJson(item))
          .toList(),
      total: json['total'] ?? 0,
    );
  }
}
