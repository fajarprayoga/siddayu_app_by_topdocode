import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 24,
          ),
          Text(
            'SIDDAYU',
            style: Gfont.fs(34).bold,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Sistem Informasi Digital Desa Ayunan')
        ],
      ),
    );
  }
}
