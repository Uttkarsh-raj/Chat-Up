import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../models/provider/providers.dart';

abstract class IAuthApi {
  Future<Either<String, model.Account>> signup({
    required String email,
    required String password,
  });

  Future<Either<String, model.Session>> login({
    required String email,
    required String password,
  });

  Future<model.Account?> currentUserAccount();

  Future<Either<String, void>> logout();
}

final authApiProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthApi(account: account);
});

class AuthApi implements IAuthApi {
  final Account _account;
  AuthApi({required Account account}) : _account = account;

  @override
  Future<model.Account?> currentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<String, model.Account>> signup(
      {required String email, required String password}) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return right(account);
    } on AppwriteException catch (e) {
      return left(e.message ?? '');
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, model.Session>> login(
      {required String email, required String password}) async {
    try {
      final session =
          await _account.createEmailSession(email: email, password: password);
      return right(session);
    } on AppwriteException catch (e) {
      return left(e.message ?? '');
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      return right(null);
    } on AppwriteException catch (e) {
      return left(e.message ?? '');
    } catch (e) {
      return left(e.toString());
    }
  }
}
