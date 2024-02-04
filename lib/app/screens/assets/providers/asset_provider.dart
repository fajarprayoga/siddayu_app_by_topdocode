import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazyui/lazyui.dart';
import 'package:todo_app/app/data/api/api.dart';
import 'package:todo_app/app/data/models/document.dart';

class AssetState {
  final bool isPaginate;
  final AsyncValue<List<Document>> documents;
  AssetState({this.isPaginate = false, this.documents = const AsyncValue.loading()});

  AssetState copyWith({bool? isPaginate, AsyncValue<List<Document>>? documents}) {
    return AssetState(isPaginate: isPaginate ?? this.isPaginate, documents: documents ?? this.documents);
  }
}

class AssetNotifier extends StateNotifier<AssetState> with Apis {
  final String activityID;

  AssetNotifier(this.activityID) : super(AssetState()) {
    getData();
  }

  List<Map<dynamic, dynamic>> documents = [];

  Future getData() async {
    try {
      state = state.copyWith(documents: const AsyncValue.loading());
      final res = await assetApi.getDocuments(activityID);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(res.data['data'] ?? []);
      List<Document> docs = data.map((e) => Document.fromJson(e)).toList();

      final grouped = data.groupBy('type', wrapWith: (date) {
        return [...data.map((e) => Document.fromJson(e))];
      }, addKeys: ['type']);

      documents = grouped;
      logg(documents);

      // split by type
      // documents = state = state.copyWith(documents: AsyncValue.data(docs));
      state = state.copyWith(documents: AsyncValue.data(docs));
    } catch (e, s) {
      state = state.copyWith(documents: const AsyncValue.data([]));
      Errors.check(e, s);
    }
  }
}

final assetProvider = StateNotifierProvider.autoDispose.family<AssetNotifier, AssetState, String>((ref, activityID) {
  return AssetNotifier(activityID);
});
