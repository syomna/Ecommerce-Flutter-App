import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layouts/home_layout.dart';
import 'package:shop/modules/login/login_screen.dart';
import 'package:shop/modules/onboarding/onBoarding.dart';
import 'package:shop/shared/blocs/home_cubit/home_cubit.dart';
import 'package:shop/shared/blocs/layout_cubit/layout_cubit.dart';
import 'package:shop/shared/blocs/login_cubit/login_cubit.dart';
import 'package:shop/shared/blocs/register_cubit/register_cubit.dart';
import 'package:shop/shared/myBlocObserver.dart';
import 'package:shop/shared/network/constants.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'package:shop/shared/network/remote/dio_helper.dart';
import 'package:shop/shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();

  await CacheHelper.init();
  bool? isOnBoarding = CacheHelper.getData('onBoarding');
  token = CacheHelper.getData('token');
  BlocOverrides.runZoned(() {
    runApp(MyApp(
      isOnBoarding: isOnBoarding,
    ));
  }, blocObserver: MyBlocObserver());
}

class MyApp extends StatelessWidget {
  final bool? isOnBoarding;

  MyApp({
    required this.isOnBoarding,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(),
          ),
          BlocProvider<RegisterCubit>(
            create: (context) => RegisterCubit(),
          ),
          BlocProvider<LayoutCubit>(create: (context) => LayoutCubit()),
          BlocProvider<HomeCubit>(
              create: (context) => HomeCubit()
                ..getHomeData()
                ..getCategories()
                ..getUserData()
                ..getFavorites()
                ..getCart())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          title: 'Y-Shop',
          home: chooseHome(),
        ));
  }

  Widget chooseHome() {
    if (isOnBoarding == null) {
      return OnBoarding();
    } else {
      if (token == null) {
        return LoginScreen();
      } else {
        return HomeLayout();
      }
    }
  }
}
