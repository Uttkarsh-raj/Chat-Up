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
        leading: CircleAvatar(
          backgroundImage: NetworkImage(userModel.profilePic ??
              'https://upload.wikimedia.org/wikipedia/en/9/98/SaitamaWikipediapage.png'),
          radius: 30,
        ),
      ),
    );
  }
}
