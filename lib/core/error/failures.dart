import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure()
    : super('No internet connection. Check your network and try again.');
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('The request timed out. Please try again.');
}

final class ServerFailure extends Failure {
  const ServerFailure() : super('The server had a problem. Please try again.');
}

final class InvalidResponseFailure extends Failure {
  const InvalidResponseFailure() : super('We received an unexpected response.');
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure() : super('Something went wrong. Please try again.');
}
