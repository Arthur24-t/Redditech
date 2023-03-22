import 'package:flutter/material.dart';

/// Creation of the Rounded Button of the login page, to sign in with
/// your reddit account.

class RoundedButton extends StatelessWidget {
  final String text;
  final String iconSrc;
  final VoidCallback? onPressed;
  final Color color, textColor;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.iconSrc,
    required this.onPressed,
    this.color = const Color.fromARGB(220, 245, 12, 44),
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: newElevatedButton(),
      ),
    );
  }

  ///Used:ElevatedButton as FlatButton is deprecated.
  ///Here we have to apply customizations to Button by inheriting the styleFrom.

  Widget newElevatedButton() {
    return ElevatedButton.icon(
      icon: Image.asset(iconSrc, width: 35, height: 35),
      label: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          primary: color,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: TextStyle(
              color: textColor, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }
}
