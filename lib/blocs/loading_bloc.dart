import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class LoadingEvent {}

final class StartLoadingApp extends LoadingEvent {}

class LoadingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppLoadProgressState extends LoadingState {
  final String message;
  AppLoadProgressState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AppLoadedState extends LoadingState {}

class LoadingBloc extends Bloc<LoadingEvent, LoadingState> {
  LoadingBloc() : super(LoadingState()) {
    on<StartLoadingApp>(startLoading);
  }

  void startLoading(StartLoadingApp event, Emitter<LoadingState> emit) {}
}
