import 'package:flutter_base/blocs/loading_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyLoadingBloc extends LoadingBloc {
  @override
  void startLoading(StartLoadingApp event, Emitter<LoadingState> emit) async {
    emit(AppLoadProgressState(message: 'Start'));
    emit(TrendingAppsLoadedState(const ['1', '2']));
    await Future.delayed(const Duration(seconds: 5));
    emit(AppLoadProgressState(message: 'Almost there...'));
    await Future.delayed(const Duration(seconds: 5));
    emit(AppLoadedState());
  }
}

class TrendingAppsLoadedState extends LoadingState {
  final List<String> apps;
  TrendingAppsLoadedState(this.apps);
  @override
  List<Object?> get props => [apps];
}
