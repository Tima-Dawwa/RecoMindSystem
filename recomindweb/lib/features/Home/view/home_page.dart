import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/Widgets/custom_loading.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/core/helpers/custom_shared_preferences.dart';
import 'package:recomindweb/features/Home/view%20model/cubit/home_cubit.dart';
import 'package:recomindweb/features/Home/view%20model/cubit/home_state.dart';
import 'package:recomindweb/features/Home/view/widgets/home_page_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CustomSharedPreferences prefs = CustomSharedPreferences();
  bool logged = true;

  @override
  void initState() {
    super.initState();
    // isLogged();
    // getCollab();
    if (logged) {
      getProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is LoadingHomeState) {
            return Center(child: CustomLoading());
          } else
          // if (state is SuccessHomeState)
          {
            return ResponsiveLayout(
              mobileBody: HomePageBody(desktop: false, logged: logged),
              desktopBody: HomePageBody(desktop: true, logged: logged),
            );
          }
          // else {
          //   return Text('fail');
          // }
        },
      ),
    );
  }

  Future<void> isLogged() async {
    if (await prefs.logged()) {
      setState(() {
        logged = true;
      });
    } else {
      setState(() {
        logged = false;
      });
    }
  }

  Future<void> getCollab() async {
    await BlocProvider.of<HomeCubit>(context).getCollab();
  }

  Future<void> getProfile() async {
    await BlocProvider.of<HomeCubit>(context).getProfile();
  }
}
