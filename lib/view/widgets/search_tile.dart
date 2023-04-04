import 'package:chatit/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModel;
  const SearchTile({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(4, 3, 4, 0),
        shape: const Border(
          top: BorderSide(color: Color.fromRGBO(66, 66, 66, 1)),
          bottom: BorderSide(color: Color.fromRGBO(66, 66, 66, 1)),
        ),
        onTap: () {},
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            userModel.profilePic ??
                'https://upload.wikimedia.org/wikipedia/en/9/98/SaitamaWikipediapage.png',
          ),
          radius: 30,
        ),
        title: Text(
          userModel.name,
          style: TextStyle(
            color: AppColors.mainText,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(0, 3, 0, 8),
          child: Text(
            '@${userModel.name}',
            style: TextStyle(
              color: AppColors.subText,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
