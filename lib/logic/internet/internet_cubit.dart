import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_handler/model/internet_enum.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final bool enableInitialConnectionCheck;
  InternetCubit({this.enableInitialConnectionCheck = false})
      : super(InternetState(
          loading: true,
          internetConnectionType: InternetConnectionType.none,
        )) {
    monitorInternetConnection(enableInitialConnectionCheck);
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

  Future<StreamSubscription<ConnectivityResult>> monitorInternetConnection(
      bool enableInitialConnectionCheck) async {
    if (enableInitialConnectionCheck) {
      final initialConnectionStatus = await connectivity.checkConnectivity();
      checkConnectivity(initialConnectionStatus);
    }

    return _connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen(
      (connectivityResult) {
        checkConnectivity(connectivityResult);
      },
    );
  }

  void emitInternetConnected(InternetConnectionType internetConnectionType) {
    emit(state.copyWith(loading: true));
    emit(state.copyWith(
      connected: true,
      internetConnectionType: internetConnectionType,
    ));
  }

  void emitInternetDisconnected() {
    emit(state.copyWith(loading: true));
    emit(state.copyWith(disconnected: true));
  }

  @override
  Future<void> close() {
    _connectivityStreamSubscription.cancel();
    return super.close();
  }

  @pragma('vm:entry-point')

  /// Check for internet connectivity
  Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }
}
