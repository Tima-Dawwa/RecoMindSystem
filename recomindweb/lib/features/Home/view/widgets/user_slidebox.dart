import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recomindweb/core/Widgets/custom_button.dart';
import 'package:recomindweb/core/Widgets/custom_loading.dart';
import 'package:recomindweb/core/Widgets/custom_text_button.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Authentication/view%20model/cubit/auth_cubit.dart';
import 'package:recomindweb/features/Authentication/view%20model/cubit/auth_states.dart';
import 'package:recomindweb/features/Home/model/profile_model.dart';
import 'package:recomindweb/features/Home/view%20model/cubit/home_cubit.dart';

class UserSlidebox extends StatefulWidget {
  const UserSlidebox({super.key, required this.logoutTap});
  final void Function()? logoutTap;

  @override
  State<UserSlidebox> createState() => _UserSlideboxState();
}

class _UserSlideboxState extends State<UserSlidebox> {
  File? image;
  ProfileModel? profile;
  ImagePicker picker = ImagePicker();
  XFile? pickedImage;
  bool show = false;

  @override
  void initState() {
    super.initState();
    profile = BlocProvider.of<HomeCubit>(context).profile;
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
    } else if (profile?.picture != null) {
      return NetworkImage("${getIt.get<Api>().baseUrl}${profile!.picture}");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                              profileImage == null
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
                            child: Icon(Icons.add, color: Themes.bg, size: 15),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${profile!.name.first} ${profile!.name.last}",
                        style: TextStyle(
                          color: Themes.text,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        profile!.gender == 'Female' ? Icons.female : Icons.male,
                        color: Themes.text,
                        size: 22,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "${profile!.location.city}, ${profile!.location.country}",
                        style: TextStyle(color: Themes.text, fontSize: 14),
                      ),
                      // const SizedBox(width: 6),
                      // Icon(
                      //   Icons.edit,
                      //   size: 16,
                      //   color: Themes.text.withAlpha(150),
                      // ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        "+${profile!.number.code} ${profile!.number.number}",
                        style: TextStyle(color: Themes.text, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(),
          BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) {
              if (state is SuccessLogoutState) {
                setState(() {});
                Get.toNamed('/', preventDuplicates: false);
              }
            },
            builder: (context, state) {
              if (state is LoadingAuthState) {
                return Center(child: CustomLoading());
              } else {
                return Padding(
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
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> submitImage() async {
    if (image != null) {
      await BlocProvider.of<HomeCubit>(
        context,
      ).changeImage(image: pickedImage!);
      setState(() {
        show = false;
        profile = BlocProvider.of<HomeCubit>(context).profile;
      });
    }
  }
}
