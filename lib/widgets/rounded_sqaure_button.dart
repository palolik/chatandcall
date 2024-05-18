import 'package:flutter/material.dart';

class RoundedShapeButton extends StatelessWidget {
  const RoundedShapeButton(
      {super.key,
      required this.label,
      this.icon,
      this.color = Colors.lightBlue,
      this.radius = 15,
      this.fontSize = 17,
      this.textColor = Colors.white,
      this.size,
      required this.onPressed});
  final String label;
  final IconData? icon;
  final Color? color;
  final double? radius;
  final double? fontSize;
  final Color? textColor;
  final double? size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = size ?? screenWidth;
    return SizedBox(
      width: buttonWidth,
      height: 50.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius!),
          ),
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: fontSize),
                  const SizedBox(width: 8.0),
                  Text(
                    label,
                    style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              )
            : Text(
                label,
                style: TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                    fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
