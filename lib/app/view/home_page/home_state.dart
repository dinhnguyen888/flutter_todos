import 'package:equatable/equatable.dart';
import 'package:flutter_todos/utils/enums.dart';

class HomeState extends Equatable {
  const HomeState({this.tab = HomeTab.home});

  final HomeTab tab;
  @override
  List<Object?> get props => [tab];
}
