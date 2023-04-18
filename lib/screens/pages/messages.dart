import 'package:chatit/controllers/message_controller.dart';
import 'package:chatit/screens/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/message_model.dart';
import '../../models/user_model.dart';

class Messages extends ConsumerWidget {
  Messages(this.receiver, this.sender, {super.key});
  final UserModel receiver;
  final UserModel sender;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sentMessagesProvider = getMessageProvider(sender.uid);
    final receivedMessagesProvider = getMessageProvider(receiver.uid);

    final sortedMessagesProvider =
        Provider.family<List<MessageModel>, String>((ref, receiver) {
      final messages = ref.watch(getMessageProvider(receiver));
      return messages.when(
        data: (data) {
          // Sort messages by createdOn attribute
          data.sort((a, b) => a.createdOn.compareTo(b.createdOn));
          return data;
        },
        error: (error, st) {
          throw error;
        },
        loading: () => [],
      );
    });

    final sortedMessageProvider = FutureProvider((ref) {
      final combinedMessages = [
        ...ref.watch(sentMessagesProvider).maybeWhen(
              data: (data) => data,
              orElse: () => [],
            ),
        ...ref.watch(receivedMessagesProvider).maybeWhen(
              data: (data) => data,
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
    // return Consumer(
    //   builder: (context, watch, child) {
    //     final sortedMessages = ref.watch(sortedMessagesProvider);
    //     return ListView.builder(
    //       itemCount: sortedMessages.length,
    //       itemBuilder: (context, index) {
    //         final message = sortedMessages[index];
    //         return MessageWidget(m: message);
    //         // Return widget for each message
    //       },
    //     );
    //   },
    // );
    // return Consumer(
    //   builder: (context, watch, child) {
    //     final combinedMessagesAsync = ref.watch(sortedMessageProvider);
    //     return combinedMessagesAsync.when(
    //       data: (combinedMessages) {
    //         return ListView.builder(
    //           itemCount: combinedMessages.length,
    //           itemBuilder: (context, index) {
    //             final message = combinedMessages[index];
    //             return Text(message.message);
    //           },
    //         );
    //       },
    //       loading: () => const Center(child: CircularProgressIndicator()),
    //       error: (error, stackTrace) => Text('Error: $error'),
    //     );
    //   },
    // );
  }
}
