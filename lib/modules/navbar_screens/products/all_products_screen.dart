import 'package:conditional/conditional.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/navbar_screens/cubit/home_cubit.dart';
import 'package:shop/modules/navbar_screens/cubit/home_states.dart';
import 'package:shop/shared/components/components.dart';

class AllProductsScreen extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        print(cubit.products[0].name);
        return Scaffold(
            appBar: AppBar(
              title: Text(
                'All Products',
                style: appBarStyle(context),
              ),
            ),
            body: Conditional(
              condition: cubit.products.length == 0,
              onConditionTrue: Center(
                child: Text(
                  'No data'.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              onConditionFalse: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 0.6),
                      itemCount: cubit.products.length,
                      itemBuilder: (context, index) => buildGridItems(
                          cubit.products[index], context, cubit))),
            ));
      },
    );
  }
}
