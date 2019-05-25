import 'package:rxdart/rxdart.dart';

import "dart:async";

class UiBloc  {

  var _isLoadingStateController = BehaviorSubject<bool>();
  StreamSink<bool> get _inIsLoading =>
      _isLoadingStateController.sink;
  Stream<bool> get outIsLoading => _isLoadingStateController.stream;

  UiBloc() {
    _inIsLoading.add(false);
  }

  Future<bool> loadScreen() {
    _inIsLoading.add(true) ;
    return outIsLoading.first;
  }

  Future<bool> unloadScreen() {
    _inIsLoading.add(false) ;
    return outIsLoading.first;
  }

  void dispose() {
    _isLoadingStateController.close();
  }
}
