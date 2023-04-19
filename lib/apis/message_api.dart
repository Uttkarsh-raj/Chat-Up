import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
// import 'package:appwrite/models.dart' as model;
import 'package:chatit/constants/appwrite_constants.dart';
import 'package:chatit/models/message_model.dart';
import 'package:chatit/models/provider/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final messageApiProvider = Provider((ref) {
  return MessageApi(
      db: ref.watch(
        appwriteDatabaseProvider,
      ),
      realtime: ref.watch(appwriteRealtimeProvider));
});

abstract class IMessageApi {
  Future<Either<String, Document>> sendMessage(MessageModel messageModel);
  Future<List<Document>> getMessages(String receiver);
  Stream<RealtimeMessage> getLatestMessageData();
}

class MessageApi extends IMessageApi {
  final Databases _db;
  final Realtime _realtime;

  MessageApi({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

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

  @override
  Future<List<Document>> getMessages(String receiver) async {
    final documents = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.messagesCollectionId,
      queries: [
        Query.search('receiverId', receiver),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestMessageData() {
    return _realtime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.messagesCollectionId}.documents'
    ]).stream;
  }
}
