import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/constants/font.dart';
import 'package:todo_app/app/providers/login/login_provider.dart';
import 'package:todo_app/app/widgets/widget.dart';
// import 'package:todo_app/app/providers/login/login_provider.dart';

// import '../../../core/constants/font.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(authProvider);
    final username = notifier.username, password = notifier.password;

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
        body: notifier.loading
            ? Loading(
                isLoading: true,
              )
            : Center(
                child: SizedBox(
                  width: 320,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    shrinkWrap: true,
                    children: [
                      // form title
                      Column(
                        children: [
                          Text('Sistem Informasi Digital Desa Ayunan',
                              style: Gfont.fs18.bold),
                          const SizedBox(height: 5),
                          Text(
                              'Silahkan login untuk menggunakan aplikasi SIDDAYU.',
                              textAlign: TextAlign.center,
                              style: Gfont.muted),
                        ],
                      ),

                      const SizedBox(height: 50),

                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            // text input email
                            TextFormField(
                              validator: (String? arg) {
                                if (arg!.length < 3) {
                                  return 'Email must be more than 2 charater';
                                }
                                return null;
                              },
                              controller: username,
                              decoration: const InputDecoration(
                                  hintText: 'Type your email address'),
                              onSaved: (String? val) {
                                username.text = val ?? '';
                              },
                            ),

                            // text input password
                            TextFormField(
                              validator: (String? arg) {
                                if (arg!.length < 6) {
                                  return 'Password must be more than 6 charater';
                                }
                                return null;
                              },
                              controller: password,
                              decoration: const InputDecoration(
                                  hintText: 'Type your password'),
                              onSaved: (String? val) {
                                password.text = val ?? '';
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      // form button
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState?.save();
                            notifier.login(context);
                          }
                        },
                        child: const Text('Login'),
                      )
                    ],
                  ),
                ),
              ));
  }
}
