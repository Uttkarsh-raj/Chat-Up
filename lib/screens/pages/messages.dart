import 'package:chatit/controllers/message_controller.dart';
import 'package:chatit/models/message_model.dart';
import 'package:chatit/screens/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_model.dart';

class Messages extends ConsumerWidget {
  Messages(this.receiver, this.sender, {super.key});
  final UserModel receiver;
  final UserModel sender;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sentMessagesProvider = getMessageProvider(receiver.uid);
    final receivedMessagesProvider = getMessageProvider(sender.uid);

    final sortedMessageProvider = FutureProvider((ref) {
      final combinedMessages = [
        ...ref.watch(sentMessagesProvider).maybeWhen(
              data: (data) {
                List<MessageModel> l = [];
                for (MessageModel i in data) {
                  if (i.receiverId == receiver.uid) {
                    l.add(i);
                  }
                }
                return l;
              },
              orElse: () => [],
            ),
        ...ref.watch(receivedMessagesProvider).maybeWhen(
              data: (data) {
                List<MessageModel> m = [];
                for (MessageModel i in data) {
                  if (i.senderId == receiver.uid) {
                    m.add(i);
                  }
                }
                return m;
              },
              orElse: () => [],
            )
      ];
      combinedMessages.sort((a, b) => a.createdOn.compareTo(b.createdOn));
      return combinedMessages;
    });
    return ref.watch(sortedMessageProvider).when(
          data: (data) {
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final user = data[index];
                return MessageWidget(
                  m: user,
                  u: sender,
                );
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
