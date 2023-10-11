import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/internet_enum.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  InternetCubit() : super(InternetLoading()) {
    monitorInternetConnection();
  }

  final connectivity = Connectivity();
  
  late StreamSubscription _connectivityStreamSubscription;

  void checkConnectivity(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.wifi) {
      emitInternetConnected(InternetConnectionType.wifi);
    } else if (connectivityResult == ConnectivityResult.mobile) {
      emitInternetConnected(InternetConnectionType.mobile);
    } else if (connectivityResult == ConnectivityResult.none) {
      emitInternetDisconnected();
    }
  }

  Future<StreamSubscription<ConnectivityResult>>
      monitorInternetConnection() async {
    final initialConnectionStatus = await connectivity.checkConnectivity();
    checkConnectivity(initialConnectionStatus);

    return _connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen(
      (connectivityResult) {
        checkConnectivity(connectivityResult);
      },
    );
  }

  void emitInternetConnected(InternetConnectionType internetConnectionType) {
    emit(InternetLoading());
    emit(InternetConnected(internetConnectionType: internetConnectionType));
  }

  void emitInternetDisconnected() {
    emit(InternetLoading());
    emit(InternetDisconnected());
  }

  @override
  Future<void> close() {
    _connectivityStreamSubscription.cancel();
    return super.close();
  }

  /// Check for internet connectivity
  Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }
}
