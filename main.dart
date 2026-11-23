import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/notes_cubit.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => NotesCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _controller = TextEditingController();

  void _addNote() {
    String inputValue = _controller.text;

    if (inputValue.isNotEmpty) {
      context.read<NotesCubit>().addNote(inputValue);
      _controller.clear();
    }
  }

  void _showNote(String note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Просмотр заметки'),
          content: Text(note),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  void _editNote(int index, String note) {
    final TextEditingController editController =
        TextEditingController(text: note);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактирование заметки'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              hintText: 'Введите новый текст',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  context
                      .read<NotesCubit>()
                      .editNote(index, editController.text);

                  Navigator.pop(context);
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Введите текст заметки',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addNote,
              child: const Text('Сохранить'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<NotesCubit, NotesState>(
                builder: (context, state) {
                  return ListView.builder(
                    itemCount: state.notes.length,
                    itemBuilder: (context, index) {
                      double dragDistance = 0;

                      return GestureDetector(
                        onTap: () {
                          _showNote(state.notes[index]);
                        },
                        onDoubleTap: () {
                          context
                              .read<NotesCubit>()
                              .makeImportant(index);
                        },
                        onLongPress: () {
                          _editNote(index, state.notes[index]);
                        },
                        onHorizontalDragStart: (details) {
                          dragDistance = 0;
                        },
                        onHorizontalDragUpdate: (details) {
                          dragDistance += details.delta.dx;
                        },
                        onHorizontalDragEnd: (details) {
                          if (dragDistance > 0) {
                            context
                                .read<NotesCubit>()
                                .makeNormal(index);
                          } else if (dragDistance < 0) {
                            context
                                .read<NotesCubit>()
                                .deleteNote(index);
                          }
                        },
                        child: Container(
                          color: state.importantNotes[index]
                              ? Colors.yellow
                              : Colors.white,
                          child: ListTile(
                            title: Text(state.notes[index]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _editNote(
                                      index,
                                      state.notes[index],
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<NotesCubit>()
                                        .deleteNote(index);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}