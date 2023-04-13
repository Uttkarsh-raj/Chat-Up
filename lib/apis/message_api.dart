import 'package:appwrite/appwrite.dart';
import 'package:chatit/constants/appwrite_constants.dart';
import 'package:chatit/models/message_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class IMessageApi {
  Future<Either<String, void>> saveMessage(MessageModel messageModel);
}

class MessageApi extends IMessageApi {
  final Databases _db;

  MessageApi({required Databases db}) : _db = db;

  @override
  Future<Either<String, void>> saveMessage(MessageModel messageModel) async {
    try {
      await _db.createDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.messagesCollectionId,
          documentId: messageModel.mId,
          data: messageModel.toMap());
      return right(null);
    } on AppwriteException catch (e) {
      return left(e.message ?? 'Some unexpected error occured');
    } catch (e) {
      return left(e.toString());
    }
  }
}
