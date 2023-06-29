part of 'internet_cubit.dart';

abstract class InternetState extends Equatable {
  @override
  List<Object> get props => [];
}

class InternetLoading extends InternetState {}

class InternetConnected extends InternetState {
  final InternetConnectionType internetConnectionType;
  InternetConnected({
    required this.internetConnectionType,
  });

  @override
  List<Object> get props => [internetConnectionType];
}

class InternetDisconnected extends InternetState {}
