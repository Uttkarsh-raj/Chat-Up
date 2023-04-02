import 'package:chatit/constants/app_colors.dart';
import 'package:chatit/constants/assets_constants.dart';
import 'package:flutter/material.dart';

class CustomButtonGreen extends StatelessWidget {
  const CustomButtonGreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.07,
      width: size.width * 0.6,
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class CustomButtonGrey extends StatelessWidget {
  CustomButtonGrey({super.key, required this.title, required this.icon});
  final String title;
  String icon = "";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.072,
      width: size.width * 0.6,
      decoration: BoxDecoration(
        color: AppColors.darkgrey,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
