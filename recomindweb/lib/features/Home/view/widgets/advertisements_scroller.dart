import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AdvertisementsScroller extends StatefulWidget {
  const AdvertisementsScroller({super.key});

  @override
  State<AdvertisementsScroller> createState() => _AdvertisementsScrollerState();
}

class _AdvertisementsScrollerState extends State<AdvertisementsScroller> {
  int activeIndex = 0;
  final controller = CarouselSliderController();
  final List<String> images = [];

  @override
  void initState() {
    super.initState();
    chooseAdv();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: controller,
          options: CarouselOptions(
            aspectRatio: 6 / 1,
            viewportFraction: 0.75,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            pauseAutoPlayOnTouch: false,
            enlargeCenterPage: true,
            onPageChanged:
                (index, reason) => setState(() => activeIndex = index),
          ),
          itemCount: 4,
          itemBuilder: (context, index, realIndex) {
            final image = images[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: 4,
          onDotClicked: (int index) => controller.animateToPage(index),
          effect: SwapEffect(
            type: SwapType.yRotation,
            dotWidth: 10,
            dotHeight: 10,
            dotColor: Themes.primary.withAlpha(100),
            activeDotColor: Themes.primary,
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  void chooseAdv() {
    List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8];
    numbers.shuffle(Random());
    for (int number in numbers) {
      images.add("assets/Images/adv$number.jpg");
    }
  }
}
