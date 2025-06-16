import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recomindweb/core/Widgets/custom_text_button.dart';
import 'package:recomindweb/core/theme.dart';

class HomePageFooter extends StatefulWidget {
  const HomePageFooter({super.key, required this.desktop});
  final bool desktop;
  @override
  State<HomePageFooter> createState() => _HomePageFooterState();
}

class _HomePageFooterState extends State<HomePageFooter> {
  bool showContact = false;
  bool showAbout = false;
  bool showTerms = false;
  bool showTeam = false;
  bool showCookies = false;
  bool showPrivacy = false;
  String descreption = "";
  double shownSize = 0;
  double notShownSize = 0;
  @override
  Widget build(BuildContext context) {
    shownSize = widget.desktop ? 25 : 20;
    notShownSize = widget.desktop ? 20 : 15;
    return Container(
      width: double.infinity,
      color: Themes.primary,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TRENDOVA",
            style: TextStyle(
              color: Themes.bg,
              fontSize: widget.desktop ? 40 : 30,
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextButton(
                text: "Contact",
                size: showContact ? shownSize : notShownSize,
                color: showContact ? Themes.bg : Themes.bg.withAlpha(150),
                weight: showContact ? FontWeight.bold : FontWeight.normal,
                press: contactTap,
              ),
              CustomTextButton(
                text: "Privacy & Policy",
                size: showPrivacy ? shownSize : notShownSize,
                color: showPrivacy ? Themes.bg : Themes.bg.withAlpha(150),
                weight: showPrivacy ? FontWeight.bold : FontWeight.normal,
                press: privacyTap,
              ),
              CustomTextButton(
                text: "Terms",
                size: showTerms ? shownSize : notShownSize,
                color: showTerms ? Themes.bg : Themes.bg.withAlpha(150),
                weight: showTerms ? FontWeight.bold : FontWeight.normal,
                press: termsTap,
              ),
              CustomTextButton(
                text: "Cookies",
                size: showCookies ? shownSize : notShownSize,
                color: showCookies ? Themes.bg : Themes.bg.withAlpha(150),
                weight: showCookies ? FontWeight.bold : FontWeight.normal,
                press: cookiesTap,
              ),
              CustomTextButton(
                text: "About",
                size: showAbout ? shownSize : notShownSize,
                color: showAbout ? Themes.bg : Themes.bg.withAlpha(150),
                weight: showAbout ? FontWeight.bold : FontWeight.normal,
                press: aboutTap,
              ),
              CustomTextButton(
                text: "Our Team",
                size: showTeam ? shownSize : notShownSize,
                color: showTeam ? Themes.bg : Themes.bg.withAlpha(150),
                weight: showTeam ? FontWeight.bold : FontWeight.normal,
                press: teamTap,
              ),
            ],
          ),
          SizedBox(height: 15),
          if (showAbout ||
              showCookies ||
              showContact ||
              showPrivacy ||
              showTeam ||
              showTerms)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                descreption,
                style: TextStyle(
                  color: Themes.bg.withAlpha(150),
                  fontSize: widget.desktop ? 20 : 18,
                ),
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Follow us",
                style: TextStyle(
                  color: Themes.bg,
                  fontSize: widget.desktop ? 25 : 22,
                ),
              ),
              SizedBox(width: 30),
              Icon(
                FontAwesomeIcons.facebook,
                color: Themes.bg,
                size: widget.desktop ? 25 : 22,
              ),
              SizedBox(width: 30),
              Icon(
                FontAwesomeIcons.instagram,
                color: Themes.bg,
                size: widget.desktop ? 25 : 22,
              ),
              SizedBox(width: 30),
              Icon(
                FontAwesomeIcons.xTwitter,
                color: Themes.bg,
                size: widget.desktop ? 25 : 22,
              ),
              SizedBox(width: 30),
              Icon(
                FontAwesomeIcons.linkedin,
                color: Themes.bg,
                size: widget.desktop ? 25 : 22,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void contactTap() {
    setState(() {
      descreption = 'trendovestore@gmail.com \n+963 999999999';
      showContact = !showContact;
      showAbout = false;
      showCookies = false;
      showPrivacy = false;
      showTeam = false;
      showTerms = false;
    });
  }

  void privacyTap() {
    setState(() {
      descreption =
          'We value your privacy and protect your personal information.\nYour data is securely stored and used only to improve your shopping experience.';
      showPrivacy = !showPrivacy;
      showAbout = false;
      showCookies = false;
      showContact = false;
      showTeam = false;
      showTerms = false;
    });
  }

  void termsTap() {
    setState(() {
      descreption =
          'By shopping with us, you agree to our terms of service.\nWe aim to provide quality products and a smooth shopping experience.';
      showTerms = !showTerms;
      showAbout = false;
      showCookies = false;
      showContact = false;
      showPrivacy = false;
      showTeam = false;
    });
  }

  void cookiesTap() {
    setState(() {
      descreption =
          'Our site uses cookies to enhance your experience and personalize your shopping journey.\nBy continuing, you accept our use of cookies.';
      showCookies = !showCookies;
      showAbout = false;
      showContact = false;
      showPrivacy = false;
      showTeam = false;
      showTerms = false;
    });
  }

  void aboutTap() {
    setState(() {
      descreption =
          'We are passionate about fashion and committed to bringing you trendy, high-quality clothing.\nOur store is built for style lovers who seek unique pieces. Thank you for being part of our journey!';
      showAbout = !showAbout;
      showCookies = false;
      showContact = false;
      showPrivacy = false;
      showTeam = false;
      showTerms = false;
    });
  }

  void teamTap() {
    setState(() {
      descreption =
          'Sara Najati,  Tima Dawwa,  Abd Alaziz Aushar,  Hamza Tinawi,  Malik Imam';
      showTeam = !showTeam;
      showAbout = false;
      showCookies = false;
      showContact = false;
      showPrivacy = false;
      showTerms = false;
    });
  }
}
