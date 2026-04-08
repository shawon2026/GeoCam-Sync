import 'package:equatable/equatable.dart';

/// Events for Home
sealed class HomeEvent extends Equatable {
  const HomeEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadHome extends HomeEvent {
  const LoadHome();
}

class RefreshHome extends HomeEvent {
  const RefreshHome();
}
