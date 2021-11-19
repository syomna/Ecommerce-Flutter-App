import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layouts/cubit/layout_cubit.dart';
import 'package:shop/layouts/home_layout.dart';
import 'package:shop/modules/login/cubit/login_cubit.dart';
import 'package:shop/modules/login/login_screen.dart';
import 'package:shop/modules/navbar_screens/cubit/home_cubit.dart';
import 'package:shop/modules/onboarding/onBoarding.dart';
import 'package:shop/modules/register/cubit/register_cubit.dart';
import 'package:shop/shared/myBlocObserver.dart';
import 'package:shop/shared/network/constants.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'package:shop/shared/network/remote/dio_helper.dart';
import 'package:shop/shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  BlocOverrides.runZoned(() {
    LoginCubit();
    RegisterCubit();
    LayoutCubit();
    HomeCubit();
  }, blocObserver: MyBlocObserver());
  // Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  bool? isOnBoarding = CacheHelper.getData('onBoarding');
  token = CacheHelper.getData('token');
  kCartLength = CacheHelper.getData('CartLength');

  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(
      isOnBoarding: isOnBoarding,
    ),
  ));
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
          locale: DevicePreview.locale(context), // Add the locale here
          builder: DevicePreview.appBuilder,
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
