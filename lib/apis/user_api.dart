import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:chatit/constants/appwrite_constants.dart';
import 'package:chatit/models/provider/providers.dart';
import 'package:chatit/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

abstract class IUserApi {
  Future<Either<String, void>> saveUserData(UserModel userModel);
  Future<List<model.Document>> searchUserByName(String name);
  Future<model.Document> getUserData(String uid);
  Future<Either<String, void>> addToContacts(UserModel user);
  Future<Either<String, void>> updateUserData(UserModel userModel);
  Stream<RealtimeMessage> getLatestUserProfileData();
}

final userApiProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return UserApi(
      db: ref.watch(appwriteDatabaseProvider),
      realtime: ref.watch(appwriteRealtimeProvider));
});

class UserApi implements IUserApi {
  final Databases _db;
  final Realtime _realtime;
  UserApi({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  Future<Either<String, void>> saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e) {
      return left(e.message ?? 'Some unexpected error occured');
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<List<model.Document>> searchUserByName(String name) async {
    final documents = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.userCollectionId,
      queries: [
        Query.search('name', name),
      ],
    );
    return documents.documents;
  }

  Future<List<model.Document>> searchUserById(String id) async {
    final documents = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.userCollectionId,
      queries: [
        Query.search('Document ID', id),
      ],
    );
    return documents.documents;
  }

  @override
  Future<Either<String, void>> addToContacts(UserModel user) async {
    try {
      await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userCollectionId,
        documentId: user.uid,
        data: {
          'contacts': user.contacts,
        },
      );
      return right(null);
    } on AppwriteException catch (e) {
      return left(e.message ?? 'Some unexpected error occured');
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<model.Document> getUserData(String uid) async {
    return _db.getDocument(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.userCollectionId,
      documentId: uid,
    );
  }

  @override
  Future<Either<String, void>> updateUserData(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e) {
      return left(e.message ?? 'Some unexpected error occured');
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    return _realtime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.userCollectionId}.documents'
    ]).stream;
  }
}
