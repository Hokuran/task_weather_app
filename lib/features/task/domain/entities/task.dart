import 'package:equatable/equatable.dart';

class MyTask extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final bool isCompleted;

  const MyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [id, title, description, category, isCompleted];
}
