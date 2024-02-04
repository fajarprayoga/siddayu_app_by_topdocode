import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/providers/login/login_provider.dart';

class Kependudukan extends ConsumerWidget {
  const Kependudukan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(authProvider);
    double screenWidth = MediaQuery.of(context).size.width;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      direction: Axis.horizontal,
      runSpacing: gap,
      spacing: gap,
      children: List.generate(10, (index) {
        return iconBoxCustom(screenWidth, index, notifier);
      }),
    );
  }

  Widget iconBoxCustom(double screenWidth, int index, notifier) {
    return SizedBox(
      width: (screenWidth - 72) / 3, // Atur lebar sesuai kebutuhan Anda
      height: 140.0, // Atur tinggi sesuai kebutuhan Anda
      // Atur warna latar belakang sesuai kebutuhan Anda
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: InkWell(
            onTap: () {},
            child: Column(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    // Atur warna latar belakang sesuai kebutuhan Anda
                    border: Border.all(
                      color: Colors
                          .grey, // Atur warna border sesuai kebutuhan Anda
                      width: 0.8, // Atur lebar border sesuai kebutuhan Anda
                    ),
                    borderRadius: BorderRadius.circular(
                        8.0), // Atur sudut border sesuai kebutuhan Anda
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.lightBlue[300],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text('Pendaftaran')
              ],
            ),
          )),
    );
  }
}
