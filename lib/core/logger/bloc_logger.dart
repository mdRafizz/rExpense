import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_logger.dart';

/// BLoC observer that logs every event, state transition, and error
/// across ALL cubits/blocs in the app automatically.
class AppBlocObserver extends BlocObserver {
  static const _tag = 'BLoC';

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    AppLogger.d(_tag, '✦ Created  ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    AppLogger.d(_tag, '→ Event    ${bloc.runtimeType} ← ${event.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    AppLogger.v(
      _tag,
      '~ State    ${bloc.runtimeType}\n'
      '    from: ${change.currentState.runtimeType}\n'
      '    to:   ${change.nextState.runtimeType}',
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    AppLogger.i(
      _tag,
      '✔ Transition ${bloc.runtimeType} '
      '[${transition.event.runtimeType}] '
      '→ ${transition.nextState.runtimeType}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    AppLogger.e(
      _tag,
      '✖ Error in ${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    AppLogger.d(_tag, '✦ Closed   ${bloc.runtimeType}');
  }
}
