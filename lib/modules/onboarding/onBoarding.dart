import 'package:flutter/material.dart';
import 'package:shop/modules/login/login_screen.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'package:shop/shared/styles/themes.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  var pageController = PageController();

  bool isLast = false;

  List<OnBoardingData> onBoarding = [
    OnBoardingData(
        title: 'Shopping Online',
        subtitle: 'We help you to get what you want in the most easiest way!',
        image: 'assets/images/onboarding_one.png'),
    OnBoardingData(
        title: 'WishList',
        subtitle: 'Mark your wish products to reach them easier!',
        image: 'assets/images/onboarding_two.png'),
    OnBoardingData(
        title: 'Adding To Cart',
        subtitle: 'Collect your products to order them in one package!',
        image: 'assets/images/onboarding_three.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                CacheHelper.setData(key: 'onBoarding', value: false)
                    .then((value) {
                  print(value);
                  navigateAndReplacment(context, LoginScreen());
                });
              },
              child: Text(
                'skip'.toUpperCase(),
                style: TextStyle(
                    color: defaultColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                  onPageChanged: (value) {
                    if (value == onBoarding.length - 1) {
                      print(value);
                      setState(() {
                        isLast = true;
                      });
                    } else {
                      print(value);
                      setState(() {
                        isLast = false;
                      });
                    }
                  },
                  controller: pageController,
                  itemBuilder: (context, index) {
                    return boardingBuild(onBoarding[index], context);
                  }),
            ),
          const  SizedBox(
              height: 15.0,
            ),
            Row(
              children: [
                buildSmoothPageIndicator(
                    pageController: pageController,
                    listLength: onBoarding.length),
                Spacer(),
                FloatingActionButton(
                    child: Icon(Icons.arrow_right_outlined),
                    onPressed: () {
                      if (isLast == false) {
                        pageController.nextPage(
                            duration: Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn);
                      } else {
                        CacheHelper.setData(key: 'onBoarding', value: false)
                            .then((value) {
                          print(value);
                          navigateAndReplacment(context, LoginScreen());
                        });
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  boardingBuild(OnBoardingData data, context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(image: AssetImage(data.image)),
      const  SizedBox(
          height: 15,
        ),
        ListTile(
          title: Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle: Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.grey[700]),
          ),
        )
      ],
    );
  }
}

class OnBoardingData {
  String title;
  String subtitle;
  String image;

  OnBoardingData(
      {@required this.title, @required this.subtitle, @required this.image});
}
