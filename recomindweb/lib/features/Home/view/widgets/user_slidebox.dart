import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:recomindweb/core/Widgets/custom_loading.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Authentication/view%20model/cubit/auth_cubit.dart';
import 'package:recomindweb/features/Authentication/view%20model/cubit/auth_states.dart';

class UserSlidebox extends StatefulWidget {
  const UserSlidebox({super.key, required this.logoutTap});
  final void Function()? logoutTap;

  @override
  State<UserSlidebox> createState() => _UserSlideboxState();
}

class _UserSlideboxState extends State<UserSlidebox> {
  Uint8List? pickedImage;

  void chooseImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        pickedImage = result.files.single.bytes;
      });
    }
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
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child:
                        pickedImage != null
                            ? CircleAvatar(
                              radius: 28,
                              backgroundImage: MemoryImage(pickedImage!),
                            )
                            : CircleAvatar(
                              radius: 28,
                              backgroundColor: Themes.primary.withAlpha(80),
                              child: Icon(
                                Icons.person,
                                color: Themes.primary.withAlpha(180),
                                size: 30,
                              ),
                            ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Themes.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GestureDetector(
                        onTap: chooseImage,
                        child: Icon(Icons.add, color: Themes.bg, size: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sara Najati",
                    style: TextStyle(
                      color: Themes.text,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Damascus, Syria",
                        style: TextStyle(color: Themes.text, fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.edit,
                        size: 16,
                        color: Themes.text.withAlpha(150),
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
                return ListTile(
                  leading: Icon(
                    Icons.logout,
                    size: 20,
                    color: Themes.secondary,
                  ),
                  title: Text(
                    "Log out",
                    style: TextStyle(fontSize: 18, color: Themes.text),
                  ),
                  onTap: widget.logoutTap,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
