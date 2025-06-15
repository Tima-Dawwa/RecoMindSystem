import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:recomindweb/core/Widgets/custom_button.dart';
import 'package:recomindweb/core/theme.dart';

class ChatbotBar extends StatelessWidget {
  const ChatbotBar({super.key, this.desktop});
  final bool? desktop;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: desktop! ? 40 : 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "AI Experience",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Themes.text,
                      fontSize:
                          desktop!
                              ? MediaQuery.of(context).size.width * 0.03
                              : MediaQuery.of(context).size.width * 0.033,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    FontAwesomeIcons.wandMagicSparkles,
                    color: Themes.text,
                    size:
                        desktop!
                            ? MediaQuery.of(context).size.width * 0.03
                            : MediaQuery.of(context).size.width * 0.033,
                  ),
                ],
              ),
              Text(
                "Smart chatbot assistant",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Themes.text,
                  fontSize:
                      desktop!
                          ? MediaQuery.of(context).size.width * 0.02
                          : MediaQuery.of(context).size.width * 0.024,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: desktop! ? 30 : 20),
              padding: EdgeInsets.symmetric(
                horizontal: desktop! ? 20 : 10,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Themes.bg,
                border: Border.all(color: Themes.primary, width: 2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                  bottomLeft: Radius.circular(60),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.06,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Lottie.asset("assets/animations/chatbot.json"),
                    ),
                  ),
                  Spacer(flex: 1),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hey friend !",
                          style: TextStyle(
                            color: Themes.text,
                            fontSize: MediaQuery.of(context).size.width * 0.022,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          desktop!
                              ? "Don't waste your time searching normally, Let me make it easier"
                              : "Don't waste your time searching normally,\nLet me make it easier",
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                            color: Themes.text,
                            fontSize:
                                desktop!
                                    ? MediaQuery.of(context).size.width * 0.015
                                    : MediaQuery.of(context).size.width * 0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(flex: 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: AspectRatio(
                      aspectRatio: 2 / 0.6,
                      child: CustomButton(
                        text: "Try now",
                        borderRadius: 40,
                        size: desktop! ? 20 : 10,
                        color: WidgetStatePropertyAll(Themes.secondary),
                        press: () {
                          context.go('/chatbot');
                        },
                      ),
                    ),
                  ),
                  Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
