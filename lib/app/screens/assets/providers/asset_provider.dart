import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/document.dart';

class AssetState {
  final bool isPaginate;
  final AsyncValue<List<Document>> documents;
  final int index; // for pdf viewer

  AssetState({this.isPaginate = false, this.documents = const AsyncValue.loading(), this.index = 0});

  AssetState copyWith({bool? isPaginate, AsyncValue<List<Document>>? documents, int? index}) {
    return AssetState(
        isPaginate: isPaginate ?? this.isPaginate, documents: documents ?? this.documents, index: index ?? this.index);
  }
}

class AssetNotifier extends StateNotifier<AssetState> with Apis {
  final String activityID;

  AssetNotifier(this.activityID) : super(AssetState()) {
    getData();
  }

  List<Map<dynamic, dynamic>> documents = [];
  List<String> pdfs = [];

  Future getData() async {
    try {
      documents = [];
      state = state.copyWith(documents: const AsyncValue.loading());
      final res = await assetApi.getDocuments(activityID);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(res.data['data'] ?? []);
      List<Document> docs = data.map((e) => Document.fromJson(e)).toList();

      final grouped = data.groupBy('type', addKeys: ['type']);

      for (Map<dynamic, dynamic> e in grouped) {
        String type = e['type'];
        documents.add({
          'title': type,
          'documents': (e[type] as List).map((e) => Document.fromJson(e)).toList(),
        });
      }

      pdfs = data.where((e) => e['url'].toString().contains('.pdf')).map((e) => e['url'].toString()).toList();
      state = state.copyWith(documents: AsyncValue.data(docs));
    } catch (e, s) {
      state = state.copyWith(documents: const AsyncValue.data([]));
      Errors.check(e, s);
    }
  }

  int get length => pdfs.length;
  int get index => state.index;
  bool isLoading = false;

  void selectPDF(int index) async {
    isLoading = true;
    state = state.copyWith(index: index);
    await Future.delayed(100.ms);
    isLoading = false;
    state = state.copyWith(index: index);
  }
}

final assetProvider = StateNotifierProvider.autoDispose.family<AssetNotifier, AssetState, String>((ref, activityID) {
  return AssetNotifier(activityID);
});
