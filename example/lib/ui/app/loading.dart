import 'package:flutter_base/blocs/loading_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyLoadingBloc extends LoadingBloc {
  @override
  void startLoading(StartLoadingApp event, Emitter<LoadingState> emit) async {
    emit(AppLoadProgressState(message: 'Start'));
    await Future.delayed(const Duration(seconds: 5));
    emit(AppLoadProgressState(message: 'Almost there...'));
    await Future.delayed(const Duration(seconds: 5));
    emit(AppLoadedState());
  }
}
