import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {Key? key, required this.category, required this.onCategoryPressed})
      : super(key: key);

  final CategoryData category;
  final Function()? onCategoryPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCategoryPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        margin: EdgeInsets.all(10.0),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: '${category.image}',
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
              padding: const EdgeInsets.all(2.0),
              width: double.infinity,
              child: Text(
                '${category.name}',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
