class Paths {
  static const String home = '/';
  static const String login = '/login';
  static const String formTodo = '/form-todo';
  static const String managementTataKelola = '/management-tata-kelola';
  static String managementTataKelolaDetail(String? id) {
    if (id != null && id.isNotEmpty) {
      return '/management-tata-kelola-detail/:$id';
    } else {
      return '/management-tata-kelola-detail/:id';
    }
  }

  static const String formManagementTataKelola = '/form-management-tata-kelola';
  static const String formManagementTataKelolaDetail =
      '/form-management-tata-kelola-detail';
  static const String formPertanggungJawaban = '/form-pertanggung-jawaban';
}
