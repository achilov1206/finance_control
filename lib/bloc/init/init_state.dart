part of 'init_bloc.dart';

enum InitStatus { initial, registiring, registered }

class InitState extends Equatable {
  final InitStatus initStatus;
  const InitState({
    required this.initStatus,
  });
  @override
  List<Object?> get props => throw UnimplementedError();

  factory InitState.initial() {
    return const InitState(initStatus: InitStatus.initial);
  }

  @override
  String toString() => 'InitState(initState: $initStatus)';

  InitState copyWith({
    InitStatus? initStatus,
  }) {
    return InitState(
      initStatus: initStatus ?? this.initStatus,
    );
  }
}
