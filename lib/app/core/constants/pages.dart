import 'package:flutter/material.dart';
import 'package:todo_app/app/screens/home/views/home_view.dart';
import 'package:todo_app/app/screens/kependudukan/kependudukan.dart';
import 'package:todo_app/app/screens/management_tata_kelola/views/management_tata_kelola.dart';

List<Map<String, dynamic>> pages = const [
  {'title': 'Home', 'page': HomeView(), 'icon': Icons.home},
  {'title': 'Kependudukan', 'page': Kependudukan(), 'icon': Icons.person},
  {
    'title': 'Management Tata Kelola',
    'page': ManagementTataKelola(),
    'icon': Icons.task
  }
];
