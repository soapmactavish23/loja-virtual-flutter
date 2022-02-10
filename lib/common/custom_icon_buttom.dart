import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const CustomIconButton(
      {@required this.iconData, @required this.color, @required this.onTap});

  final IconData? iconData;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              iconData,
              color: onTap != null ? color : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }
}
