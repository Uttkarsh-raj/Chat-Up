import 'package:chatit/controllers/message_controller.dart';
import 'package:chatit/models/message_model.dart';
import 'package:chatit/screens/widgets/message_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/appwrite_constants.dart';
import '../../models/user_model.dart';

class Messages extends ConsumerWidget {
  Messages(this.receiver, this.sender, {super.key});
  final UserModel receiver;
  final UserModel sender;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var sentMessagesProvider = getMessageProvider(receiver.uid);
    var receivedMessagesProvider = getMessageProvider(sender.uid);

    var sortedMessageProvider = FutureProvider((ref) {
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

    return ref.watch(getLatestMessageDataProvider).when(
          data: (data) {
            if (data.events.contains(
                    'databases.*.collections.${AppWriteConstants.messagesCollectionId}.documents.*.create') ||
                data.events.contains(
                    'databases.*.collections.${AppWriteConstants.messagesCollectionId}.documents.*.update')) {
              sentMessagesProvider = getMessageProvider(receiver.uid);
              receivedMessagesProvider = getMessageProvider(sender.uid);
              var d = data.payload;
              sortedMessageProvider = FutureProvider((ref) {
                var combinedMessages = [
                  ...ref.watch(sentMessagesProvider).maybeWhen(
                        data: (data) {
                          List<MessageModel> l = [];
                          for (MessageModel i in data) {
                            if (i.receiverId == receiver.uid) {
                              l.add(i);
                            }
                          }
                          if ((MessageModel.fromMap(d).senderId == sender.uid &&
                              MessageModel.fromMap(d).receiverId ==
                                  receiver.uid)) {
                            l.add(MessageModel.fromMap(d));
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
                          if ((MessageModel.fromMap(d).senderId ==
                                  receiver.uid &&
                              MessageModel.fromMap(d).receiverId ==
                                  sender.uid)) {
                            m.add(MessageModel.fromMap(d));
                          }
                          return m;
                        },
                        orElse: () => [],
                      ),
                ];
                combinedMessages
                    .sort((a, b) => a.createdOn.compareTo(b.createdOn));
                return combinedMessages;
              });
            }
            return ref.watch(sortedMessageProvider).when(
                  data: (data) {
                    int d = data.length - 1;
                    return ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final user = data[d - index];
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
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                );
          },
          error: (error, st) =>
              Scaffold(body: Center(child: Text(error.toString()))),
          loading: () {
            return ref.watch(sortedMessageProvider).when(
                  data: (data) {
                    int d = data.length - 1;
                    return ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final user = data[d - index];
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
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                );
          },
        );
  }
}
