import 'package:equatable/equatable.dart';

/// Represents a failure from repository or use case (left side of [Either]).
class Failure extends Equatable {
  const Failure({this.message, this.data});

  final String? message;
  final dynamic data;

  @override
  List<Object?> get props => <Object?>[message, data];
}
