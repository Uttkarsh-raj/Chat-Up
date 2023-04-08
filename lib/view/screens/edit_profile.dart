import 'dart:io';

import 'package:chatit/controllers/user_profile_controller.dart';
import 'package:chatit/core/utils.dart';
import 'package:chatit/view/screens/profile_page.dart';
import 'package:chatit/view/widgets/edit_field_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

import '../../constants/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  TextEditingController bioController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  File? bannerFile;
  File? profileFile;

  @override
  void dispose() {
    bioController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerFile = banner;
      });
    }
  }

  void selectProfileImage() async {
    final profile = await pickImage();
    if (profile != null) {
      setState(() {
        profileFile = profile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(userProfileControllerProvider);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (bannerFile != null)
                          SizedBox(
                            height: size.height * 0.24,
                            width: size.width,
                            child: GestureDetector(
                              onTap: selectBannerImage,
                              child: Image.file(
                                bannerFile!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          (user?.bannerPic == null)
                              ? GestureDetector(
                                  onTap: selectBannerImage,
                                  child: Container(
                                    height: size.height * 0.24,
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey[600]),
                                  ),
                                )
                              : SizedBox(
                                  height: size.height * 0.24,
                                  width: size.width,
                                  child: GestureDetector(
                                    onTap: selectBannerImage,
                                    child: FancyShimmerImage(
                                      imageUrl: '${user?.bannerPic}',
                                      boxFit: BoxFit.cover,
                                    ),
                                  )),
                        SizedBox(height: size.height * 0.08),
                        Center(
                          child: Text(
                            '${user?.name}',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            '@${user?.name}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: EditFields(
                            controller: nameController,
                            title:
                                (user?.name == null) ? 'name' : '${user?.name}',
                            maxlines: 1,
                            height: size.height * 0.07,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: EditFields(
                            controller: bioController,
                            title: 'Bio',
                            maxlines: null,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              ref
                                  .watch(userProfileControllerProvider.notifier)
                                  .updateUserProfile(
                                    userModel: user!,
                                    context: context,
                                    bannerFile: bannerFile,
                                    profileFile: profileFile,
                                  );
                            },
                            child: const CustomButtonGreen(
                              title: 'Save',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: size.height * 0.1582,
                      left: size.width * 0.34,
                      child: GestureDetector(
                        onTap: selectProfileImage,
                        child: (profileFile != null)
                            ? CircleAvatar(
                                backgroundImage: Image.file(profileFile!).image,
                                radius: 60,
                              )
                            : CircleAvatar(
                                backgroundImage:
                                    NetworkImage('${user?.profilePic}'),
                                radius: 60,
                              ),
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.076,
                      left: size.width * 0.02,
                      child: GestureDetector(
                        onTap: () {
                          showAlertDialog(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_outlined,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Discard"),
      onPressed: () {
        Navigator.push(
          context,
          PageTransition(
            child: const ProfilePage(),
            type: PageTransitionType.fade,
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Discard"),
      content: const Text("Discard current changes?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
