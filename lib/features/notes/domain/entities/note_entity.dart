import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class NoteEntity extends Equatable {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;

  const NoteEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
      };

  factory NoteEntity.fromJson(Map<String, dynamic> json) => NoteEntity(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        createdAt: DateTime.parse(json['createdAt']),
      );

  String get formattedDate {
    final formatter = DateFormat('dd MMM, HH:mm');
    return formatter.format(createdAt);
  }

  @override
  List<Object?> get props => [id, title, content, createdAt];
}
