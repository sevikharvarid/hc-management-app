import 'package:equatable/equatable.dart';

abstract class HistorySPGState extends Equatable {
  const HistorySPGState();
}

class HistorySPGLoading extends HistorySPGState {
  @override
  List<Object?> get props => [];
}

class HistorySPGLoaded extends HistorySPGState {
  @override
  List<Object?> get props => [];
}
