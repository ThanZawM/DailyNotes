import 'package:DailyNotes/src/models/note.dart';
import 'package:DailyNotes/src/repository/repository.dart';

class NoteActions {
  final _table = 'notes';

  Repository _repository;

  NoteActions() {
    _repository = Repository();
  }

  saveNotes(Note note) async {
    return await _repository.insertData(_table, note.toMap());
  }

  readNotes() async {
    return await _repository.readData(_table);
  }

  readNoteById(categoryId) async {
    return await _repository.readDataById(_table, categoryId);
  }

  readNoteByCategory(category) async {
    return await _repository.readDataByColumnName(_table, 'category', category);
  }
}
