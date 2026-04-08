import '/core/network/api_client.dart';
import '/core/constants/api_urls.dart';
import '../models/home_model.dart';
import '../models/home_response.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeModel>> getHome();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<HomeModel>> getHome() async {
    try {
      final response = await _apiClient.request(
        endpoint: ApiUrl.home.url,
        method: HttpMethod.get,
      );
      final homeResponse = HomeResponse.fromJson(response);
      return homeResponse.homeList;
    } catch (e) {
      rethrow;
    }
  }
}
