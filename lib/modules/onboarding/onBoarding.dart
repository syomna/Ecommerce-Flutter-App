import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop/modules/login/login_screen.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'package:shop/shared/styles/themes.dart';
import 'package:shop/shared/widgets/export_widget.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  var pageController = PageController();

  bool isLast = false;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        actions: [
          TextButton(
              onPressed: () {
                CacheHelper.setData(key: 'onBoarding', value: false)
                    .then((value) {
                  print(value);
                  navigateAndRemove(context, LoginScreen());
                });
              },
              child: Text(
                'skip'.toUpperCase(),
                style: TextStyle(
                    color: kDefaultColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
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
                  allowImplicitScrolling: true,
                  onPageChanged: (value) {
                    if (value == onBoarding.length - 1) {
                      print('$value the last');
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
                  itemCount: onBoarding.length,
                  itemBuilder: (context, index) {
                    return boardingBuild(onBoarding[index], context);
                  }),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Row(
              children: [
                BuildSmoothPageIndicator(
                    pageController: pageController,
                    listLength: onBoarding.length),
                Spacer(),
                FloatingActionButton(
                    backgroundColor: kDefaultColor,
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
                          navigateAndRemove(context, LoginScreen());
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
        Image(
          image: AssetImage(data.image),
          errorBuilder: (context, child, stack) => Icon(Icons.broken_image),
        ),
        const SizedBox(
          height: 15,
        ),
        ListTile(
          title: Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle: Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: Colors.grey[700]),
          ),
        )
      ],
    );
  }
}
