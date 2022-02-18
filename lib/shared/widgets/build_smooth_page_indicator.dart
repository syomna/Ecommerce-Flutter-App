import 'package:flutter/material.dart';
import 'package:shop/shared/styles/themes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BuildSmoothPageIndicator extends StatelessWidget {
  const BuildSmoothPageIndicator(
      {Key? key, required this.pageController, required this.listLength})
      : super(key: key);

  final PageController pageController;
  final int listLength;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
        controller: pageController, // PageController
        count: listLength,
        effect: ExpandingDotsEffect(
            activeDotColor: kDefaultColor), // your preferred effect
        onDotClicked: (index) {});
  }
}
