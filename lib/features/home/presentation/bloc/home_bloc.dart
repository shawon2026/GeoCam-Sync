import 'package:flutter_bloc/flutter_bloc.dart';

import '/features/home/presentation/bloc/event/home_event.dart';
import '/features/home/presentation/bloc/state/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<LoadHome>(_onLoadHome);
    on<RefreshHome>(_onRefreshHome);
  }

  Future<void> _onLoadHome(
    LoadHome event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    
    try {
      // TODO: Implement use case call
      // final result = await _getHomeUseCase(NoParams());
      
      // result.fold(
      //   (failure) => emit(HomeError(failure.message)),
      //   (data) => emit(HomeLoaded(data)),
      // );
      
      // Placeholder
      emit(const HomeLoaded([]));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshHome(
    RefreshHome event,
    Emitter<HomeState> emit,
  ) async {
    // Same as load but can be customized
    await _onLoadHome(const LoadHome(), emit);
  }
}
