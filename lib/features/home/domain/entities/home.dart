import 'package:equatable/equatable.dart';

class Home extends Equatable {
  final int id;
  const Home({required this.id});

  @override
  List<Object?> get props => [id];
}
