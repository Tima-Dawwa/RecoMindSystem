import 'package:dashboard/features/Main%20Page/view%20model/cubit/main_cubit.dart';
import 'package:dashboard/features/Main%20Page/view%20model/cubit/main_state.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/main_page_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    statistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          if (state is MainLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MainSuccessState) {
            return MainPageBody();
          } else {
            return Text('fail');
          }
        },
      ),
    );
  }

  Future<void> statistics() async {
    await BlocProvider.of<MainCubit>(context).getMainData();
  }
}
