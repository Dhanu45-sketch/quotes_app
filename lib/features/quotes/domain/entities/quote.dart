import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  const Quote({required this.id, required this.text, required this.author});

  final int id;
  final String text;
  final String author;

  @override
  List<Object?> get props => [id, text, author];
}
