import 'package:equatable/equatable.dart';

import '/features/home/domain/entities/home.dart';

/// State for Home
sealed class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Home> homes;
  
  const HomeLoaded(this.homes);
  
  @override
  List<Object?> get props => [homes];
}

class HomeError extends HomeState {
  final String message;
  
  const HomeError(this.message);
  
  @override
  List<Object?> get props => [message];
}
