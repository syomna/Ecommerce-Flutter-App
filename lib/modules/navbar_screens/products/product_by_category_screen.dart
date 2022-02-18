import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/shared/blocs/home_cubit/home_cubit.dart';
import 'package:shop/shared/blocs/home_cubit/home_states.dart';
import 'package:shop/shared/styles/themes.dart';
import 'package:shop/shared/widgets/export_widget.dart';

class ProductsByCategoryScreen extends StatelessWidget {
  final String title;
  ProductsByCategoryScreen(this.title);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {

        var cubit = HomeCubit.get(context);

        return Scaffold(
            appBar: AppBar(
              title: Text(
                '$title',
                style: appBarStyle(context),
              ),
            ),
            body: _body(cubit, context));
      },
    );
  }

  Widget _body(HomeCubit cubit, BuildContext context) {
    if (cubit.productsByCategoryModel.data!.data.isEmpty) {
      return Center(
        child: Text(
          'No data'.toUpperCase(),
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    }
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.6),
            itemCount: cubit.productsByCategoryModel.data!.data.length,
            itemBuilder: (context, index) => Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: BuildGridItems(
                      model: cubit.productsByCategoryModel.data!.data[index],
                      cubit: cubit),
                )));
  }
}
