import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recomindweb/core/Widgets/custom_button.dart';
import 'package:recomindweb/core/Widgets/custom_loading.dart';
import 'package:recomindweb/core/Widgets/custom_text_button.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Home/model/cities_model.dart';
import 'package:recomindweb/features/Home/model/profile_model.dart';
import 'package:recomindweb/features/Home/view%20model/cubit/home_cubit.dart';
import 'package:recomindweb/features/Home/view%20model/cubit/home_state.dart';
import 'package:recomindweb/features/Home/view/widgets/profile%20widgets/user_info.dart';

class UserBox extends StatefulWidget {
  const UserBox({super.key, required this.logoutTap, required this.close});
  final void Function()? logoutTap;
  final void Function() close;

  @override
  State<UserBox> createState() => _UserBoxState();
}

class _UserBoxState extends State<UserBox> {
  File? image;
  ProfileModel? profile;
  ImagePicker picker = ImagePicker();
  XFile? pickedImage;
  bool show = false;
  List<CitiesModel> countries = [];

  @override
  void initState() {
    super.initState();
    profile = BlocProvider.of<HomeCubit>(context).profile;
    countries = BlocProvider.of<HomeCubit>(context).countries;
  }

  Future getImage() async {
    pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage!.path);
        show = true;
      }
    });
  }

  ImageProvider? get profileImage {
    if (image != null) {
      return NetworkImage(image!.path);
    } else if (profile?.picture != null &&
        profile?.picture != '/images/default_profile.jpg') {
      return NetworkImage(
        "${getIt.get<Api>().baseUrl}${profile!.picture}",
        headers: {"ngrok-skip-browser-warning": "true"},
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is LoadingProfileState) {
          return Center(child: CustomLoading());
        } else {
          return Container(
            width: 250,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Themes.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: Themes.primary.withAlpha(50),
                                backgroundImage: profileImage,
                                child:
                                    profileImage == null ||
                                            profile?.picture ==
                                                '/images/default_profile.jpg'
                                        ? Icon(
                                          Icons.person,
                                          color: Themes.primary.withAlpha(180),
                                          size: 30,
                                        )
                                        : null,
                              ),
                            ),
                            Positioned(
                              bottom: 3,
                              right: 4,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Themes.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: GestureDetector(
                                  onTap: getImage,
                                  child: Icon(
                                    Icons.add,
                                    color: Themes.bg,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (show) SizedBox(height: 6),
                        if (show)
                          CustomButton(
                            text: 'Submit',
                            width: 50,
                            height: 25,
                            size: 14,
                            press: submitImage,
                          ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    UserInfo(
                      profile: profile!,
                      countries: countries,
                      close: widget.close,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 20, color: Themes.secondary),
                      SizedBox(width: 6),
                      CustomTextButton(
                        text: "Log out",
                        press: widget.logoutTap!,
                        size: 18,
                        color: Themes.text,
                        weight: FontWeight.normal,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<void> submitImage() async {
    if (image != null) {
      setState(() {
        show = false;
      });
      await BlocProvider.of<HomeCubit>(
        context,
      ).changeImage(image: pickedImage!);
      setState(() {
        profile = BlocProvider.of<HomeCubit>(context).profile;
      });
    }
  }
}
