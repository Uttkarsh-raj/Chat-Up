import 'package:chatit/view/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/assets_constants.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CircleAvatar(
                    backgroundImage: Assets.logo,
                    radius: 30,
                  ),
                  Text(
                    'Chat-Up',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.menu,
                    size: 26,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Search',
              icon: Icons.search_outlined,
              obscure: false,
              controller: searchController,
            ),
          ],
        ),
      ),
    );
  }
}
