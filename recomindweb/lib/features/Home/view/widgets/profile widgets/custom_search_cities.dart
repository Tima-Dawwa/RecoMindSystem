import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Home/model/cities_model.dart';
import 'package:recomindweb/features/Home/view%20model/cubit/home_cubit.dart';

class CustomSearchCities extends SearchDelegate {
  final List<CitiesModel> countries;

  CustomSearchCities({required this.countries});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Map<String, String>> filteredCities = [];

    if (query.isEmpty) {
      for (var country in countries) {
        for (var city in country.cities) {
          filteredCities.add({"city": city, "country": country.country});
        }
      }
    } else {
      for (var country in countries) {
        for (var city in country.cities) {
          if (city.toLowerCase().contains(query.toLowerCase())) {
            filteredCities.add({"city": city, "country": country.country});
          }
        }
      }
    }

    return ListView.builder(
      itemCount: filteredCities.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.location_city,
                  color: Themes.primary,
                  size: 30,
                ),
                title: Text(
                  filteredCities[index]["city"]!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Themes.text,
                  ),
                ),
                subtitle: Text(
                  filteredCities[index]["country"]!,
                  style: TextStyle(
                    fontSize: 15,
                    color: Themes.text.withAlpha(180),
                  ),
                ),
                onTap: () async {
                  await BlocProvider.of<HomeCubit>(context).changeLocation(
                    city: filteredCities[index]["city"]!,
                    country: filteredCities[index]["country"]!,
                  );
                  Get.toNamed('/', preventDuplicates: false);
                },
              ),
              const Divider(height: 5, indent: 20, endIndent: 30),
            ],
          ),
        );
      },
    );
  }
}
