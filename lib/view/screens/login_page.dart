import 'package:chatit/constants/app_colors.dart';
import 'package:chatit/constants/assets_constants.dart';
import 'package:chatit/view/widgets/custom_button.dart';
import 'package:chatit/view/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundImage: Assets.logo,
                radius: 55,
              ),
              const SizedBox(
                height: 7,
              ),
              const Text(
                'Chat-Up',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Login to your Account',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              CustomTextField(
                label: 'Email Address',
                icon: Icons.email_outlined,
                obscure: false,
              ),
              const SizedBox(
                height: 13,
              ),
              CustomTextField(
                label: 'Password',
                icon: Icons.lock_outline,
                obscure: true,
                suffixIcon: Icons.visibility_outlined,
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const CustomButtonGreen(
                title: 'Login',
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'or continue with',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              CustomButtonGrey(
                title: 'Google',
                icon: Assets.google,
              ),
              const SizedBox(
                height: 13,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
