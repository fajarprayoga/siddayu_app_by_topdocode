import 'dart:convert';

import 'package:fetchly/fetchly.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/service/local/storage.dart';

class Auth with ChangeNotifier, Apis {
  final forms = LzForm.make(['email', 'password']);

  Future<bool> login(LzButtonControl state) async {
    try {
      final form = LzForm.validate(forms,
          required: ['*'],
          messages: FormMessages(required: {
            'email': 'Email tidak boleh kosong',
            'password': 'Password tidak boleh kosong',
          }));

      if (!form.ok) {
        return false;
      }

      state.submit();
      final res = await authApi.login(form.value);

      if (res.status) {
        String? token = res.body['access_token'];
        Map<String, dynamic> user = res.data ?? {};

        if (token == null) {
          LzToast.show('Login gagal, invalid token');
          return false;
        }

        // set token to dio
        dio.setToken(token);

        // save token to shared preferences
        prefs.setString('token', token);

        // save user
        prefs.setString('auth', json.encode(user));

        return true;
      }
    } catch (e, s) {
      Errors.check(e, s);
    } finally {
      state.abort();
    }

    return false;
  }
}

final authProvider = ChangeNotifierProvider((ref) => Auth());
