import 'package:flutter/material.dart';
import 'todo_item.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoItem> todoList = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _addTodo() {
    final String newTitle = _titleController.text;
    final String newDescription = _descriptionController.text;
    if (newTitle.isNotEmpty) {
      setState(() {
        todoList.add(TodoItem(
          title: newTitle,
          description: newDescription,
          completed: false,
        ));
      });
      _titleController.clear();
      _descriptionController.clear();
    }
    Navigator.of(context).pop();
  }

  void _showTodoDetails(TodoItem todoItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(todoItem.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5.0),
                Text(
                  todoItem.description,
                  style: TextStyle(
                    color: Colors.grey, // 적용할 색상 설정
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteTodoItem(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  void _editTodoItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _editTitleController =
            TextEditingController(text: todoList[index].title);
        final TextEditingController _editDescriptionController =
            TextEditingController(text: todoList[index].description);

        return AlertDialog(
          title: const Text('Edit Todo'),
          content: Column(
            children: [
              TextField(
                controller: _editTitleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                autofocus: true,
              ),
              TextField(
                controller: _editDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final String editedTitle = _editTitleController.text;
                final String editedDescription =
                    _editDescriptionController.text;

                setState(() {
                  todoList[index].title = editedTitle;
                  todoList[index].description = editedDescription;
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              minLeadingWidth: 80,
              title: Text(
                todoList[index].title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: todoList[index].completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              onTap: () {
                _showTodoDetails(todoList[index]);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: todoList[index].completed,
                    onChanged: (value) {
                      setState(() {
                        todoList[index].completed = value!;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editTodoItem(index);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteTodoItem(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add Todo'),
                content: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      autofocus: true,
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Add'),
                    onPressed: _addTodo,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
