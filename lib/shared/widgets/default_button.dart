import 'package:flutter/material.dart';
import 'package:shop/shared/styles/themes.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton(
      {Key? key,
      required this.buttonText,
      required this.onPressed,
      this.isUpdate = false,
      this.color = kDefaultColor})
      : super(key: key);

  final String buttonText;
  final Function()? onPressed;
  final bool? isUpdate;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: isUpdate == true ? Colors.green : color,
        padding: const EdgeInsets.all(14.0),
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          buttonText,
          // style: Theme.of(context)
          //     .textTheme
          //     .bodyText1
          //     ?.copyWith(color: Colors.white),
        ),
        onPressed: onPressed);
  }
}
