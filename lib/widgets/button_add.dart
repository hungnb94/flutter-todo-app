import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ButtonAdd extends StatelessWidget {
  const ButtonAdd({Key? key, this.onPressed}) : super(key: key);
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        right: 20,
        bottom: 20,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text(
          '+',
          style: TextStyle(
            fontSize: 40,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: tdBlue,
          minimumSize: const Size(60, 60),
          elevation: 10,
        ),
      ),
    );
  }
}
