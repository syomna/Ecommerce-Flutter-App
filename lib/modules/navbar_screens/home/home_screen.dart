import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/navbar_screens/categories/all_categories_screen.dart';
import 'package:shop/modules/navbar_screens/cubit/home_cubit.dart';
import 'package:shop/modules/navbar_screens/cubit/home_states.dart';
import 'package:shop/modules/navbar_screens/products/all_products_screen.dart';
import 'package:shop/shared/network/constants.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/styles/themes.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    print(token);
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeChangeFavoritesSuccessState) {
          if (!state.model.status) {
            showToast(
                toastText: state.model.message, toastColor: ToastColor.ERROR);
          } else {
            showToast(
                toastText: state.model.message, toastColor: ToastColor.SUCESS);
          }
        }
        if (state is HomeChangeCartSuccessState) {
          if (!state.model.status) {
            showToast(
                toastText: state.model.message, toastColor: ToastColor.ERROR);
          } else {
            showToast(
                toastText: state.model.message, toastColor: ToastColor.SUCESS);
          }
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        print('rebuild');
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildCarouselSlider(cubit, context),
            const  SizedBox(
                height: 15,
              ),
              buildCustomText('Categories', context,
                  () => navigateTo(context, AllCategoriesScreen())),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cubit.categories.length,
                    itemBuilder: (context, index) {
                      return categoriesContainer(
                          cubit.categories[index], cubit, context);
                    }),
              ),
             const SizedBox(
                height: 15,
              ),
              buildCustomText('Products', context,
                  () => navigateTo(context, AllProductsScreen())),
              Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 1.4),
                      itemCount: cubit.products.length,
                      itemBuilder: (context, index) => buildGridItems(
                          cubit.products[index], context, cubit)))
            ],
          ),
        );
      },
    );
  }

  Widget buildCustomText(String text, context, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Row(
        children: [
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          TextButton(
              onPressed: onPressed,
              child: Text(
                'view all'.toUpperCase(),
                style:
                    TextStyle(color: defaultColor, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }

  Widget buildCarouselSlider(HomeCubit cubit, BuildContext context) {
    return CarouselSlider(
      items: cubit.banners
          .map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Image(fit: BoxFit.fill, image: NetworkImage('${e.image}')),
              ))
          .toList(),
      options: CarouselOptions(
        aspectRatio: 2,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        autoPlay: true,
      ),
    );
  }
}
