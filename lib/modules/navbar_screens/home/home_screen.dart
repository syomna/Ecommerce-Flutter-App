import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/navbar_screens/categories/all_categories_screen.dart';
import 'package:shop/modules/navbar_screens/products/all_products_screen.dart';
import 'package:shop/modules/navbar_screens/products/product_by_category_screen.dart';
import 'package:shop/shared/blocs/home_cubit/home_cubit.dart';
import 'package:shop/shared/blocs/home_cubit/home_states.dart';
import 'package:shop/shared/network/constants.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/widgets/export_widget.dart';
import 'package:shop/widgets/export_widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    print(token);
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeChangeFavoritesSuccessState) {
          if (!state.model!.status!) {
            showToast(
                toastText: state.model!.message, toastColor: ToastColor.ERROR);
          } else {
            showToast(
                toastText: state.model?.message, toastColor: ToastColor.SUCESS);
          }
        }
        if (state is HomeChangeCartSuccessState) {
          if (!state.model!.status!) {
            showToast(
                toastText: state.model?.message, toastColor: ToastColor.ERROR);
          } else {
            showToast(
                toastText: state.model?.message, toastColor: ToastColor.SUCESS);
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
              HomeCarouselSlider(
                banners: cubit.banners!,
              ),
              const SizedBox(
                height: 15,
              ),
              HomeCustomText(
                  text: 'Categories',
                  onPressed: () => navigateTo(context, AllCategoriesScreen())),
              _categoriesSection(context, cubit),
              const SizedBox(
                height: 15,
              ),
              HomeCustomText(
                  text: 'Products',
                  onPressed: () => navigateTo(context, AllProductsScreen())),
              _gridViewSection(context, cubit)
            ],
          ),
        );
      },
    );
  }

  Widget _categoriesSection(BuildContext context, HomeCubit cubit) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cubit.categories!.length,
          itemBuilder: (context, index) {
            return CategoryCard(
              category: cubit.categories![index],
              onCategoryPressed: () {
                cubit
                    .getProductsByCategory(cubit.categories![index].id)
                    .then((value) {
                  navigateTo(
                      context,
                      ProductsByCategoryScreen(
                          '${cubit.categories![index].name}'));
                });
              },
            );
          }),
    );
  }

  Widget _gridViewSection(BuildContext context, HomeCubit cubit) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1.4),
            itemCount: cubit.products!.length,
            itemBuilder: (context, index) =>
                BuildGridItems(model: cubit.products![index], cubit: cubit)));
  }
}
