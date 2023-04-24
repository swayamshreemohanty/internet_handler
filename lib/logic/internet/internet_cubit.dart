import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/internet_enum.dart';
part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;

  InternetCubit({required this.connectivity}) : super(InternetLoading()) {
    monitorInternetConnection();
  }

  late StreamSubscription _connectivityStreamSubscription;

  void checkConnectivity(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.wifi) {
      emitInternetConnected(ConnectionType.wifi);
    } else if (connectivityResult == ConnectivityResult.mobile) {
      emitInternetConnected(ConnectionType.mobile);
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

  void emitInternetConnected(ConnectionType connectionType) {
    emit(InternetLoading());
    emit(InternetConnected(connectionType: connectionType));
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
}
