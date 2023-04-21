import 'package:chatit/constants/app_colors.dart';
import 'package:chatit/constants/assets_constants.dart';
import 'package:chatit/screens/pages/signup_page.dart';
import 'package:chatit/screens/widgets/custom_button.dart';
import 'package:chatit/screens/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

import '../../controllers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void onLogin() {
    final res = ref.read(authControllerProvider.notifier).logIn(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
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
                      controller: emailController,
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      obscure: false,
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    CustomTextField(
                      controller: passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscure: true,
                      suffixIcon: Icons.visibility_off_outlined,
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
                    GestureDetector(
                      onTap: onLogin,
                      child: const CustomButtonGreen(
                        title: 'Login',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // const Text(
                    //   'or continue with',
                    //   style: TextStyle(
                    //     fontSize: 17,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    // CustomButtonGrey(
                    //   title: 'Google',
                    //   icon: Assets.google,
                    // ),
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: const SignupPage(),
                                  type: PageTransitionType.fade,
                                  duration: const Duration(milliseconds: 100),
                                  alignment: Alignment.center,
                                ),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: AppColors.green,
                              ),
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
