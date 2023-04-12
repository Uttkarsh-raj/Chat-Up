import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class EditFields extends StatelessWidget {
  const EditFields({
    super.key,
    required this.controller,
    required this.title,
    this.height,
    this.maxlines,
  });
  final TextEditingController controller;
  final String title;
  final double? height;
  final int? maxlines;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.grey!,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      height: (height == null) ? size.height * 0.2 : height,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          keyboardType: TextInputType.name,
          controller: controller,
          maxLines: maxlines,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: title,
            hintStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: AppColors.grey,
            ),
          ),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
