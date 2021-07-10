import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/my_network.dart';
import '../my_provider.dart';

class UserProvider extends StateNotifier<UserModel> {
  final _userApi = UserApi();

  final _sessionProvider = SessionProvider();

  UserProvider() : super(const UserModel());

  Future<Map<String, dynamic>> registration({
    required String fullName,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    final result = await _userApi.registration({
      'fullName': fullName,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
    });
    return result;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final result = await _userApi.login({
      'email': email,
      'password': password,
    });

    final user = UserModel.fromJson(result['data'] as Map<String, dynamic>);
    log('userLogin $user');
    await _sessionProvider.setSessionLogin(user);
    return result;
  }

  Future<Map<String, dynamic>> updateImage(
    int idUser, {
    required File? image,
  }) async {
    final result = await _userApi.updateImage(
      {
        'id': '$idUser',
        'image': await MultipartFile.fromFile(image?.path ?? ''),
      },
    );

    final user = UserModel.fromJson(result['data'] as Map<String, dynamic>);
    await _sessionProvider.setSessionLogin(user);
    return result;
  }

  Future<Map<String, dynamic>> updatePassword(
    int idUser, {
    required String passwordOld,
    required String passwordNew,
    required String passwordConfirm,
  }) async {
    final result = await _userApi.updatePassword(
      {
        'id': '$idUser',
        'password_old': passwordOld,
        'password_new': passwordNew,
        'password_confirm': passwordConfirm,
      },
    );
    final user = UserModel.fromJson(result['data'] as Map<String, dynamic>);
    await _sessionProvider.setSessionLogin(user);
    return result;
  }
}

final userProvider = StateNotifierProvider<UserProvider, UserModel>((ref) => UserProvider());
