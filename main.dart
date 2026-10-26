import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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

  final List<String> _notes = [];

  void _addNote() {
    String inputValue = _controller.text;

    if (inputValue.isNotEmpty) {
      setState(() {
        _notes.add(inputValue);
      });

      _controller.clear();
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  void _editNote(int index) {
    final TextEditingController editController =
        TextEditingController(text: _notes[index]);

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
                  setState(() {
                    _notes[index] = editController.text;
                  });

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
              child: ListView.builder(
                itemCount: _notes.length,

                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_notes[index]),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _editNote(index);
                          },
                          icon: const Icon(Icons.edit),
                        ),

                        IconButton(
                          onPressed: () {
                            _deleteNote(index);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
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