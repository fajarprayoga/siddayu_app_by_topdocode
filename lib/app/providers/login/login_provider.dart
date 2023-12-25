// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/extensions/dio_extension.dart';
import 'package:todo_app/app/core/helpers/toast.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/service/local/storage.dart';

// import 'package:todo_app/app/providers/user/user_provider.dart';
import '../../routes/paths.dart';

class Auth with ChangeNotifier, UseApi {
  final username = TextEditingController(text: 'kades@example.org'),
      password = TextEditingController(text: 'password');
  bool loading = false;
  Future login(BuildContext context) async {
    try {
      loading = true;
      notifyListeners();
      final res = await authApi.login({
        'email': username.text,
        'password': password.text,
      });
      final map = json.decode(res.data);
      final data = map['data'];

      loading = false;
      notifyListeners();
      print(map['access_token']);
      String? token = map['access_token'];

      if (token != null) {
        if (!context.mounted) return;
        Toasts.show('Login Successful');

        // set token to dio
        dio.setToken(token);

        // save token to shared preferences
        prefs.setString('token', token);
        // save user
        prefs.setString('auth', json.encode(data));
        // go to home
        // await Future.delayed(const Duration(seconds: 2));

        context.go(Paths.home);
      }
    } catch (e, s) {
      print('Error: $e, StackTrace: $s');
      return Toasts.show('error');
    } finally {
      loading = false;
    }
  }
}

final authProvider = ChangeNotifierProvider((ref) => Auth());
