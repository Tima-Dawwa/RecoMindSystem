import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/Widgets/custom_loading.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/features/Favourites/model/favourites_model.dart';
import 'package:recomindweb/features/Favourites/view%20model/cubit/favourites_cubit.dart';
import 'package:recomindweb/features/Favourites/view%20model/cubit/favourites_state.dart';
import 'package:recomindweb/features/Favourites/view/widgets/favourites_page_body.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  void initState() {
    super.initState();
    getFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<FavouritesCubit, FavouritesState>(
        listener: (context, state) {
          if (state is RemoveFavouritesSuccessState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is FavouritesLoadingState) {
            return Center(child: CustomLoading());
          } else if (state is FavouritesSuccessState ||
              state is RemoveFavouritesSuccessState ||
              state is RemoveFavouritesLoadingState) {
            List<FavouritesModel> favouritesItems =
                BlocProvider.of<FavouritesCubit>(context).favouritesItems;
            return ResponsiveLayout(
              mobileBody: FavouritesPageBody(
                favouritesItems: favouritesItems,
                desktop: false,
              ),
              desktopBody: FavouritesPageBody(
                favouritesItems: favouritesItems,
                desktop: true,
              ),
            );
          } else {
            return Text("Failure");
          }
        },
      ),
    );
  }

  Future<void> getFavourites() async {
    await BlocProvider.of<FavouritesCubit>(context).getFavourites();
  }
}
