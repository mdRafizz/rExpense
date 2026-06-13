import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'graph_beautify_provider.g.dart';

const String _beautifyKey = 'graph_beautify';

@riverpod
class GraphBeautifyNotifier extends _$GraphBeautifyNotifier {
  @override
  bool build() {
    _loadSetting();
    return false;
  }

  Future<void> _loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_beautifyKey) ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_beautifyKey, state);
  }
}
