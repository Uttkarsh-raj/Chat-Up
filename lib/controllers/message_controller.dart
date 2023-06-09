import 'package:chatit/apis/message_api.dart';
import 'package:chatit/controllers/auth_controller.dart';
import 'package:chatit/core/utils.dart';
import 'package:chatit/models/message_model.dart';
import 'package:chatit/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageControllProvider =
    StateNotifierProvider<MessageController, bool>((ref) {
  return MessageController(
    ref: ref,
    messageApi: ref.watch(messageApiProvider),
  );
});

final getMessageProvider = FutureProvider.family((ref, String receiver) async {
  // await Future.delayed(const Duration(seconds: 3));
  final messagecontroller = ref.watch(messageControllProvider.notifier);
  return messagecontroller.getMessages(receiver);
});

final getLatestMessageDataProvider = StreamProvider((ref) {
  final userApi = ref.watch(messageApiProvider);
  return userApi.getLatestMessageData();
});

class MessageController extends StateNotifier<bool> {
  final Ref _ref;
  final MessageApi _mssgApi;
  MessageController({required Ref ref, required MessageApi messageApi})
      : _ref = ref,
        _mssgApi = messageApi,
        super(false);

  void sendMessage({
    required String text,
    required UserModel rec,
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      showSnackbar(context, 'Please enter text');
      return;
    }
    _shareTextMessage(text: text, rec: rec, context: context);
  }

  void _shareTextMessage({
    required String text,
    required UserModel rec,
    required BuildContext context,
  }) async {
    state = true;
    String link = _getLinkFromText(text);
    MessageModel messageModel = MessageModel(
        mId: '',
        receiverId: rec.uid,
        senderId: _ref.read(currentUserDetailsProvider).value!.uid,
        message: text,
        createdOn: DateTime.now());
    final response = await _mssgApi.sendMessage(messageModel);
    state = false;
    response.fold((l) => showSnackbar(context, l.toString()), (r) => null);
  }

  Future<List<MessageModel>> getMessages(String receiver) async {
    final messages = await _mssgApi.getMessages(receiver);
    var m = messages.map((e) => MessageModel.fromMap(e.data)).toList();
    return m;
  }

  String _getLinkFromText(String text) {
    List<String> wordsInSentence = text.split(' ');
    String link = '';
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }
}
