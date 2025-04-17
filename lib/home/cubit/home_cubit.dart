// Import thư viện BLoC để tạo Cubit
import 'package:bloc/bloc.dart';

// Import thư viện Equatable giúp so sánh state hiệu quả
import 'package:equatable/equatable.dart';

// Import phần state từ file tách riêng
part 'home_state.dart';

/// Cubit dùng để quản lý trạng thái của tab hiện tại trong HomePage.
/// Có 2 tab: Todos và Stats.
class HomeCubit extends Cubit<HomeState> {
  /// Constructor khởi tạo với tab mặc định là `HomeTab.todos`
  HomeCubit() : super(const HomeState());

  /// Hàm dùng để đổi tab hiện tại, khi gọi sẽ emit state mới
  void setTab(HomeTab tab) => emit(HomeState(tab: tab));
}
