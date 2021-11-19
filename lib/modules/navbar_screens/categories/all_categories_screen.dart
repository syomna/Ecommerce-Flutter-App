import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/navbar_screens/cubit/home_cubit.dart';
import 'package:shop/modules/navbar_screens/cubit/home_states.dart';
import 'package:shop/shared/components/components.dart';

class AllCategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        if (state is HomeGetProductsByCategoryLoadingState)
          Center(
            child: CircularProgressIndicator(),
          );
        return Scaffold(
            appBar: AppBar(
              title: Text(
                'All Categories',
                style: appBarStyle(context),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  scrollDirection: Axis.vertical,
                  itemCount: cubit.categories!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: categoriesContainer(
                          cubit.categories![index], cubit, context),
                    );
                  }),
            ));
      },
    );
  }
}
