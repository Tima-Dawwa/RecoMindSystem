import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/core/Widgets/custom_button.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({super.key, required this.desktop, required this.logged});
  final bool desktop;
  final bool logged;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar>
    with SingleTickerProviderStateMixin {
  OverlayEntry? overlayEntry;
  final LayerLink _layerLink = LayerLink();
  Uint8List? pickedImage;
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    slideAnimation = Tween<Offset>(
      begin: Offset(0, -0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void toggleOverlay(BuildContext context) {
    if (overlayEntry == null) {
      overlayEntry = createOverlayEntry(context);
      Overlay.of(context).insert(overlayEntry!);
      animationController.forward();
    } else {
      closeOverlay();
    }
  }

  void closeOverlay() async {
    await animationController.reverse();
    overlayEntry?.remove();
    overlayEntry = null;
  }

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

  OverlayEntry createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
      builder:
          (context) => GestureDetector(
            onTap: closeOverlay,
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                Positioned.fill(child: Container()),
                Positioned(
                  top: offset.dy + 70,
                  right: 20,
                  width: widget.desktop ? 250 : 180,
                  child: Material(
                    color: Colors.transparent,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
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
                                        child: CircleAvatar(
                                          radius: 28,
                                          backgroundImage: AssetImage(
                                            'assets/user.jpg',
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
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: chooseImage,
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
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            style: TextStyle(
                                              color: Themes.text,
                                              fontSize: 14,
                                            ),
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
                              ListTile(
                                leading: Icon(
                                  Icons.logout,
                                  size: 20,
                                  color: Themes.secondary,
                                ),
                                title: Text(
                                  "Log out",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Themes.text,
                                  ),
                                ),
                                onTap: () {
                                  closeOverlay();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        Container(
          height: widget.desktop ? 100 : 50,
          width: double.infinity,
          padding: EdgeInsets.all(widget.desktop ? 15 : 10),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Images/bar.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset(
                  'assets/Images/logo.png',
                  height: 150,
                  width: 150,
                  alignment: Alignment.topCenter,
                ),
              ),
              Row(
                children: [
                  if (!widget.logged)
                    CustomButton(
                      text: "Login",
                      width: widget.desktop ? 100 : 80,
                      height: widget.desktop ? 32 : 25,
                      size: widget.desktop ? 20 : 15,
                      borderRadius: 40,
                      press: () {
                        Get.toNamed('/login', preventDuplicates: false);
                      },
                    ),
                  const SizedBox(width: 20),
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Themes.bg,
                    size: widget.desktop ? 30 : 22,
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(
                      Icons.local_shipping_outlined,
                      size: widget.desktop ? 30 : 22,
                    ),
                    color: Themes.bg,
                    onPressed: () {
                      Get.toNamed('/orders', preventDuplicates: false);
                    },
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.favorite_outline_rounded,
                    color: Themes.bg,
                    size: widget.desktop ? 30 : 22,
                  ),
                  if (widget.logged) const SizedBox(width: 10),
                  if (widget.logged)
                    CompositedTransformTarget(
                      link: _layerLink,
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.circleUser,
                          color: Themes.bg,
                          size: widget.desktop ? 30 : 22,
                        ),
                        onPressed: () => toggleOverlay(context),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
