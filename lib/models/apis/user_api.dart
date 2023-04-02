import 'package:appwrite/appwrite.dart';
import 'package:chatit/constants/appwrite_constants.dart';
import 'package:chatit/models/provider/providers.dart';
import 'package:chatit/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

abstract class IUserApi {
  Future<Either<String, void>> saveUserData(UserModel userModel);
}

final userApiProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return UserApi(db: db);
});

class UserApi implements IUserApi {
  final Databases _db;
  UserApi({required Databases db}) : _db = db;

  @override
  Future<Either<String, void>> saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.collectionId,
        documentId: ID.unique(),
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e) {
      return left(e.message ?? 'Some unexpected error occured');
    } catch (e) {
      return left(e.toString());
    }
  }
}
