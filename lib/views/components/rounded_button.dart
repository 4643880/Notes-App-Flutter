


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final MaterialStateProperty<EdgeInsetsGeometry?>? paddingForRoundedButton;
  final String title;
  final Function()? onTap;
  final Color buttonColor;
  final Color titleColor;
  const RoundedButton({
    Key? key,
    this.onTap,
    required this.title,
    required this.buttonColor,
    required this.titleColor,required this.paddingForRoundedButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonColor),
            padding: paddingForRoundedButton,
          ),
          onPressed: onTap,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              color: titleColor,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
