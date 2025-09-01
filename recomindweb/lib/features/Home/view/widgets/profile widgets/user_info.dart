import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Home/model/cities_model.dart';
import 'package:recomindweb/features/Home/model/profile_model.dart';
import 'package:recomindweb/features/Home/view/widgets/profile%20widgets/custom_search_cities.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({
    super.key,
    required this.profile,
    required this.countries,
    required this.close,
  });
  final ProfileModel profile;
  final List<CitiesModel> countries;
  final void Function() close;

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.profile.name.first} ${widget.profile.name.last}",
              style: TextStyle(
                color: Themes.text,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.fade,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              widget.profile.gender == 'Female' ? Icons.female : Icons.male,
              color: Themes.text,
              size: 22,
            ),
          ],
        ),
        // SizedBox(height: 4),
        Row(
          children: [
            Text(
              "${widget.profile.location?.city ?? ""} City",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Themes.text, fontSize: 14),
            ),
            IconButton(
              onPressed: search,
              padding: EdgeInsets.all(0),
              icon: Icon(
                Icons.edit,
                size: 18,
                color: Themes.text.withAlpha(120),
              ),
            ),
          ],
        ),
        // SizedBox(height: 5),
        Text(
          "+${widget.profile.number.code} ${widget.profile.number.number}",
          style: TextStyle(color: Themes.text, fontSize: 14),
        ),
      ],
    );
  }

  void search() async {
    widget.close();
    await showSearch(
      context: context,
      delegate: CustomSearchCities(countries: widget.countries),
    );
  }
}
