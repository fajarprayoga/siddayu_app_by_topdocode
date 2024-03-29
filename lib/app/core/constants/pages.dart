import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/screens/home/views/home_view.dart';
import 'package:todo_app/app/screens/kependudukan/kependudukan.dart';
import 'package:todo_app/app/screens/management_tata_kelola/views/management_tata_kelola_screen.dart';

List<Map<String, dynamic>> pages = const [
  {'title': 'Home', 'page': HomeView(), 'icon': Ti.home},
  {'title': 'Kependudukan', 'page': Kependudukan(), 'icon': Ti.users},
  {
    'title': 'Management Tata Kelola',
    'page': ManagementTataKelola(),
    'icon': Ti.clipboardCheck
  },
  {'title': 'Logout', 'page': '', 'icon': Ti.logout}
];
