import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/shared/blocs/home_cubit/home_cubit.dart';
import 'package:shop/shared/blocs/home_cubit/home_states.dart';
import 'package:shop/shared/styles/themes.dart';
import 'package:shop/shared/widgets/export_widget.dart';

class AllProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        print(cubit.products![0].name);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'All Products',
              style: appBarStyle(context),
            ),
          ),
          body: cubit.products!.length == 0
              ? Center(
                  child: Text(
                    'No data'.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 0.6),
                      itemCount: cubit.products!.length,
                      itemBuilder: (context, index) => BuildGridItems(
                         model : cubit.products![index], cubit : cubit))),
        );
      },
    );
  }
}
