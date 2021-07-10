import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../network/my_network.dart';
import '../../utils/my_utils.dart';

class SessionProvider extends StateNotifier {
  SessionProvider() : super(null);

  Future<bool> setSessionLogin(UserModel user) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final result = await pref.setString(constant.keySessionLogin, json.encode(user));
    return result;
  }

  Future<bool> removeSessionLogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final result = await pref.remove(constant.keySessionLogin);
    return result;
  }

  Future<bool> setSessionOnboarding({required bool value}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final result = await pref.setBool(constant.keySessionOnboarding, value);
    return result;
  }

  Future<UserModel?> getSessionLogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final result = pref.getString(constant.keySessionLogin);
    if (result == null) {
      return null;
    }
    final Map<String, dynamic> _json = json.decode(result) as Map<String, dynamic>;
    final user = UserModel.fromJson(_json);
    return user;
  }

  Future<bool> getSessionOnboarding() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final result = pref.getBool(constant.keySessionOnboarding);
    if (result == null) {
      return false;
    }
    return result;
  }
}

final sessionProvider = StateNotifierProvider((ref) => SessionProvider());

final _checkSessionLogin = FutureProvider.autoDispose<void>((ref) async {
  final _sessionProvider = ref.read(sessionProvider.notifier);
  final result = await _sessionProvider.getSessionLogin();
  ref.read(sessionLogin).state = result;
});

final _checkSessionOnboarding = FutureProvider.autoDispose((ref) async {
  final _sessionProvider = ref.read(sessionProvider.notifier);
  final result = await _sessionProvider.getSessionOnboarding();
  ref.read(sessionOnboarding).state = result;
});

final initializeSession = FutureProvider.autoDispose<void>((ref) async {
  await ref.read(_checkSessionLogin.future);
  await ref.read(_checkSessionOnboarding.future);
});

final sessionLogin = StateProvider<UserModel?>((ref) => null);

final sessionOnboarding = StateProvider<bool>((ref) => false);
