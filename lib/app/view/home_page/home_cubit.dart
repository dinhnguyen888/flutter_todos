import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/app/view/home_page/home_state.dart';
import 'package:flutter_todos/utils/enums.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setTab(HomeTab tab) => emit(HomeState(tab: tab));
}
