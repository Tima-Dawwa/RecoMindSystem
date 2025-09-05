import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/core/Widgets/custom_button.dart';
import 'package:recomindweb/features/Home/view%20model/cubit/home_cubit.dart';
import 'package:recomindweb/features/Home/view/home_page.dart';
import 'package:recomindweb/features/Home/view/widgets/profile%20widgets/user_box.dart';

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
  final LayerLink layerLink = LayerLink();
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
                  width: widget.desktop ? 300 : 220,
                  child: Material(
                    color: Colors.transparent,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        child: UserBox(
                          logoutTap: logoutTap,
                          close: closeOverlay,
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
            children: [
              Image.asset(
                'assets/Images/logo.png',
                height: 150,
                width: 150,
                alignment: Alignment.topCenter,
                fit: BoxFit.contain,
              ),
              Spacer(flex: 1),
              if (!widget.logged)
                CustomButton(
                  text: "Login",
                  borderRadius: 40,
                  size: widget.desktop ? 20 : 15,
                  width: widget.desktop ? 100 : 80,
                  height: widget.desktop ? 32 : 25,
                  press: () {
                    Get.toNamed('/login', preventDuplicates: false);
                  },
                ),
              if (widget.logged)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        size: widget.desktop ? 30 : 22,
                      ),
                      color: Themes.bg,
                      onPressed: () {
                        Get.toNamed('/cart', preventDuplicates: false);
                      },
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.local_shipping_outlined,
                        size: widget.desktop ? 30 : 22,
                      ),
                      color: Themes.bg,
                      onPressed: () {
                        Get.toNamed('/orders', preventDuplicates: false);
                      },
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.favorite_outline_rounded,
                        size: widget.desktop ? 30 : 22,
                      ),
                      color: Themes.bg,
                      onPressed: () {
                        Get.toNamed('/favourites', preventDuplicates: false);
                      },
                    ),
                    const SizedBox(width: 5),
                    CompositedTransformTarget(
                      link: layerLink,
                      child: IconButton(
                        padding: EdgeInsets.all(0),
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
              if (!widget.logged) SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }

  void logoutTap() async {
    closeOverlay();
    await BlocProvider.of<HomeCubit>(context).logout();
    setState(() {
      Get.to(() => HomePage());
    });
  }
}
