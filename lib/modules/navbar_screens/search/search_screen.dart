import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/navbar_screens/cubit/home_cubit.dart';
import 'package:shop/modules/navbar_screens/cubit/home_states.dart';
import 'package:shop/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  final searchController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
                  body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        defaultTextField(
                            label: 'Search',
                            controller: searchController,
                            prefixIcon: Icons.search,
                            onSubmit: (value) {
                              cubit.searchProducts(value);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'enter product name to search';
                              }
                            },
                            keyboardType: TextInputType.name),
                       const SizedBox(
                          height: 10.0,
                        ),
                        if (state is HomeGetSearchLoadingState)
                          LinearProgressIndicator(),
                      const  SizedBox(
                          height: 10.0,
                        ),
                        if (state is HomeGetSearchSuccessState)
                          Expanded(
                            child: ListView.builder(
                                itemCount: cubit.searchModel!.data!.data.length,
                                itemBuilder: (context, index) {
                                  return buildListViewItems(
                                      cubit.searchModel!.data!.data[index],
                                      scaffoldKey.currentContext,
                                      cubit,
                                      isSearch: true);
                                }),
                          )
                      ],
                    ),
                  ),
        );
      },
    );
  }
}
