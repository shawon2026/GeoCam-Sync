import '/core/error/exceptions.dart';
import '../models/home_model.dart';

abstract class HomeLocalDataSource {
  Future<List<HomeModel>> getHome();
  Future<void> cacheHome(List<HomeModel> homeList);
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  List<HomeModel> _cachedHome = [];

  @override
  Future<List<HomeModel>> getHome() async {
    if (_cachedHome.isEmpty) {
      throw CacheException(message: 'No cached data');
    }
    return _cachedHome;
  }

  @override
  Future<void> cacheHome(List<HomeModel> homeList) async {
    _cachedHome = homeList;
  }
}
