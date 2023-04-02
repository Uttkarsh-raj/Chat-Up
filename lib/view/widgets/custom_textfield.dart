import 'package:chatit/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField(
      {super.key,
      required this.label,
      required this.icon,
      required this.obscure,
      this.suffixIcon,
      required this.controller});
  final String label;
  final IconData icon;
  bool obscure;
  IconData? suffixIcon;
  final TextEditingController controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.075,
      width: size.width * 0.93,
      decoration: BoxDecoration(
        color: Color.fromRGBO(33, 33, 33, 1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          width: 1.2,
          color: const Color.fromRGBO(47, 46, 46, 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 8, 8, 8),
        child: TextField(
          controller: widget.controller,
          obscureText: widget.obscure,
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(widget.icon),
            iconColor: AppColors.grey,
            hintText: widget.label,
            hintStyle: TextStyle(
              fontSize: 18,
              color: AppColors.grey,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  if (widget.suffixIcon != Icons.visibility_off_outlined) {
                    widget.suffixIcon = Icons.visibility_off_outlined;
                    widget.obscure = true;
                  } else {
                    widget.suffixIcon = Icons.visibility_outlined;
                    widget.obscure = false;
                  }
                });
              },
              child: Icon(widget.suffixIcon),
            ),
            suffixIconColor: Colors.grey[500],
          ),
        ),
      ),
    );
  }
}
