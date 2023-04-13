import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chatit/constants/appwrite_constants.dart';
import 'package:chatit/models/message_model.dart';
import 'package:chatit/models/provider/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final messageApiProvider = Provider((ref) {
  return MessageApi(
      db: ref.watch(
    appwriteDatabaseProvider,
  ));
});

abstract class IMessageApi {
  Future<Either<String, Document>> sendMessage(MessageModel messageModel);
}

class MessageApi extends IMessageApi {
  final Databases _db;

  MessageApi({required Databases db}) : _db = db;

  @override
  Future<Either<String, Document>> sendMessage(
      MessageModel messageModel) async {
    try {
      final document = await _db.createDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.messagesCollectionId,
          documentId: ID.unique(),
          data: messageModel.toMap());
      return right(document);
    } on AppwriteException catch (e) {
      return left(e.message ?? 'Some unexpected error occured');
    } catch (e) {
      return left(e.toString());
    }
  }
}
