import 'package:flutter/material.dart';
import 'package:shop/shared/styles/themes.dart';

class HomeCustomText extends StatelessWidget {
  const HomeCustomText({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Row(
        children: [
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          TextButton(
              onPressed: onPressed,
              child: Text(
                'view all'.toUpperCase(),
                style: TextStyle(
                    color: kDefaultColor, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
