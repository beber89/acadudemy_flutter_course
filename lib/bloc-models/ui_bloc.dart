import 'package:rxdart/rxdart.dart';

import "dart:async";

class UiBloc  {

  var _isLoadingStateController = BehaviorSubject<bool>();
  StreamSink<bool> get inIsLoading =>
      _isLoadingStateController.sink;
  Stream<bool> get outIsLoading => _isLoadingStateController.stream;

  UiBloc() {
    inIsLoading.add(false);
  }

  Future<bool> loadScreen() {
    inIsLoading.add(true) ;
    return outIsLoading.first;
  }

  Future<bool> unloadScreen() {
    inIsLoading.add(false) ;
    return outIsLoading.first;
  }

  void dispose() {
    _isLoadingStateController.close();
  }
}
