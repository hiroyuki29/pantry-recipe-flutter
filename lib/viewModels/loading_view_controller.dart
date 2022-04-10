import 'package:hooks_riverpod/hooks_riverpod.dart';

final loadingServiceProvider = StateNotifierProvider<LoadingService, bool>((ref) {
return LoadingService();
});

/// LoadingService represents interfaces to control the progress indicator.
class LoadingService extends StateNotifier<bool> {
LoadingService() : super(false);

int _count = 0;

Future<T> wrap<T>(Future<T> future) async {
  _present();
  try {
    return await future;
  } finally {
    _dismiss();
  }
}

void _present() {
  _count = _count + 1;
  state = true;
}

void _dismiss() {
  _count = _count - 1;
  if (_count == 0) {
    state = false;
  }
}
}