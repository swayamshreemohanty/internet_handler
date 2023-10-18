// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'internet_cubit.dart';

class InternetState extends Equatable {
  final bool loading;
  final bool connected;
  final bool disconnected;
  final bool initialConnectionCheck;
  final InternetConnectionType internetConnectionType;

  InternetState({
    this.loading = false,
    this.connected = false,
    this.disconnected = false,
    this.initialConnectionCheck = false,
    required this.internetConnectionType,
  });

  @override
  List<Object> get props {
    return [
      loading,
      connected,
      disconnected,
      initialConnectionCheck,
      internetConnectionType,
    ];
  }

  InternetState copyWith({
    bool? loading,
    bool? connected,
    bool? disconnected,
    bool? initialConnectionCheck,
    InternetConnectionType? internetConnectionType,
  }) {
    return InternetState(
      loading: loading ?? false,
      connected: connected ?? false,
      disconnected: disconnected ?? false,
      initialConnectionCheck: initialConnectionCheck ?? false,
      internetConnectionType:
          internetConnectionType ?? InternetConnectionType.none,
    );
  }
}
