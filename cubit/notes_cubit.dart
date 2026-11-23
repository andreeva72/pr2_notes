import 'package:bloc/bloc.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesState([], []));

  void addNote(String note) {
    List<String> newNotes = List.from(state.notes);
    List<bool> newImportantNotes = List.from(state.importantNotes);

    newNotes.add(note);
    newImportantNotes.add(false);

    emit(NotesState(newNotes, newImportantNotes));
  }

  void deleteNote(int index) {
    List<String> newNotes = List.from(state.notes);
    List<bool> newImportantNotes = List.from(state.importantNotes);

    newNotes.removeAt(index);
    newImportantNotes.removeAt(index);

    emit(NotesState(newNotes, newImportantNotes));
  }

  void editNote(int index, String newText) {
    List<String> newNotes = List.from(state.notes);

    newNotes[index] = newText;

    emit(NotesState(newNotes, state.importantNotes));
  }

  void makeImportant(int index) {
    List<bool> newImportantNotes = List.from(state.importantNotes);

    newImportantNotes[index] = true;

    emit(NotesState(state.notes, newImportantNotes));
  }

  void makeNormal(int index) {
    List<bool> newImportantNotes = List.from(state.importantNotes);

    newImportantNotes[index] = false;

    emit(NotesState(state.notes, newImportantNotes));
  }
}