import 'package:chatit/constants/app_colors.dart';
import 'package:chatit/screens/widgets/custom_button.dart';
import 'package:chatit/screens/widgets/info_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

import '../../models/user_model.dart';
import 'edit_profile.dart';
import 'home_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage(this.copyofUser, {super.key});
  final UserModel copyofUser;

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (widget.copyofUser.bannerPic == null)
                      ? Container(
                          height: size.height * 0.24,
                          decoration:
                              BoxDecoration(color: Colors.blueGrey[600]),
                        )
                      : SizedBox(
                          height: size.height * 0.24,
                          width: size.width,
                          child: FancyShimmerImage(
                            imageUrl: '${widget.copyofUser.bannerPic}',
                            boxFit: BoxFit.cover,
                          )),
                  SizedBox(height: size.height * 0.08),
                  Center(
                    child: Text(
                      '${widget.copyofUser.name}',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '@${widget.copyofUser.name}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InfoTab(
                      title: 'Email',
                      value: '${widget.copyofUser.email}',
                    ),
                  ),
                  if (widget.copyofUser.bio != null)
                    SizedBox(
                      height: size.height * 0.26,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bio',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.grey,
                                ),
                              ),
                              Text(
                                '${widget.copyofUser.bio}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: EditProfile(widget.copyofUser),
                            type: PageTransitionType.fade,
                          ),
                        );
                      },
                      child: const CustomButtonGreen(
                        title: 'Edit Profile',
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: size.height * 0.1582,
                left: size.width * 0.34,
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage('${widget.copyofUser.profilePic}'),
                  radius: 60,
                ),
              ),
              Positioned(
                top: size.height * 0.076,
                left: size.width * 0.02,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: const HomePage(),
                        type: PageTransitionType.fade,
                      ),
                    );
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
}
