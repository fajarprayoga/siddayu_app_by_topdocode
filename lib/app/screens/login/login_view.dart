import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/core/constants/app.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/providers/login/login_provider.dart';
import 'package:todo_app/app/routes/paths.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(authProvider);
    final forms = notifier.forms;

    // set or unset form value
    forms.fill({'email': 'kasipem@siddayu.org', 'password': 'password'});

    return Wrapper(
      child: Scaffold(
          body: Center(
        child: SizedBox(
          width: 320,
          child: LzListView(
            padding: Ei.sym(v: 50),
            scrollLimit: const [50, 50],
            shrinkWrap: true,
            children: [
              // form title
              Column(
                children: [
                  Text('Sistem Informasi Digital Desa Ayunan', style: Gfont.fs16.bold, textAlign: Ta.center),
                  Textr('Silakan login untuk menggunakan aplikasi SIDDAYU.',
                      textAlign: TextAlign.center, margin: Ei.only(t: 5)),
                ],
              ).margin(b: 25),

              // form input
              LzFormGroup(
                type: FormType.underlined,
                children: [
                  LzForm.input(hint: 'Enter your email', model: forms['email']),
                  LzForm.input(hint: 'Enter your password', obsecureToggle: true, model: forms['password']),
                ],
              ),

              // form button
              LzButton(
                text: 'Login',
                color: primary,
                textColor: Colors.white,
                onTap: (state) async {
                  final ok = await notifier.login(state);

                  if (ok && context.mounted) {
                    context.go(Paths.home);
                  }
                },
              ),

              Text('v${App.version} - ${App.build}', style: Gfont.fs14.muted, textAlign: Ta.center).margin(t: 15)
            ],
          ),
        ),
      )),
    );
  }
}
