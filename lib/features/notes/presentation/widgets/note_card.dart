import 'package:flutter/material.dart';

import '../../domain/entities/note_entity.dart';
import '../screens/note_edit_screen.dart';

class NoteCard extends StatelessWidget {
  final NoteEntity note;
  final Widget? trailing;
  const NoteCard({super.key, required this.note, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        contentPadding: EdgeInsets.only(left: 10, right: 10),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              note.formattedDate,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            trailing ?? const SizedBox(),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NoteEditScreen(note: note),
            ),
          );
        },
      ),
    );
  }
}
