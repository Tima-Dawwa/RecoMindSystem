import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Home/view%20model/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitialHomeState());

}
