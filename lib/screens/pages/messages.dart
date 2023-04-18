import 'package:chatit/controllers/message_controller.dart';
import 'package:chatit/screens/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_model.dart';

class Messages extends ConsumerWidget {
  const Messages(this.receiver, {super.key});
  final UserModel receiver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getMessageProvider(receiver.uid)).when(
          data: (data) {
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final user = data[index];
                return MessageWidget(m: user);
              },
            );
          },
          error: (error, st) {
            return Text(error.toString());
          },
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}
