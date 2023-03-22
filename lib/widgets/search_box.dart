import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../generated/l10n.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key, this.onChanged, this.controller})
      : super(key: key);
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            prefixIcon: const Icon(
              Icons.search,
              size: 20,
              color: tdBlack,
            ),
            prefixIconConstraints:
                const BoxConstraints(maxHeight: 20, minWidth: 25),
            border: InputBorder.none,
            hintText: S.of(context).search,
            hintStyle: const TextStyle(color: tdGrey),
          ),
        ),
      ),
    );
  }
}
