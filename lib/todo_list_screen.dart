import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile_project/main.dart';
import 'todo_item.dart';

const int _pageIndexTodoList = 0;
const int _pageIndexOtherScreen = 1;

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  int _currentPageIndex = _pageIndexTodoList;
  bool _isLightMode = true;
  List<TodoItem> todoList = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();

  void _addTodo() {
    final String newTitle = _titleController.text;
    final String newDescription = _descriptionController.text;
    final int newPriority = int.tryParse(_priorityController.text) ?? 0;

    if (newTitle.isNotEmpty) {
      setState(() {
        todoList.add(TodoItem(
          title: newTitle,
          description: newDescription,
          completed: false,
          priority: newPriority,
        ));
      });

      _titleController.clear();
      _descriptionController.clear();
      _priorityController.clear();
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
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  'Priority: ${todoItem.priority}',
                  style: const TextStyle(
                    color: Colors.grey,
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
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                _editTodoItem(todoItem);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteTodoItem(todoItem);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editTodoItem(TodoItem todoItem) {
    final int index = todoList.indexOf(todoItem); // 수정할 Todo 항목의 인덱스

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _editTitleController =
            TextEditingController(text: todoItem.title);
        final TextEditingController _editDescriptionController =
            TextEditingController(text: todoItem.description);
        final TextEditingController _editPriorityController =
            TextEditingController(text: todoItem.priority.toString());

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
              TextField(
                controller: _editPriorityController,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                ),
                keyboardType: TextInputType.number,
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
                final int editedPriority =
                    int.tryParse(_editPriorityController.text) ?? 0;

                setState(() {
                  todoList[index].title = editedTitle;
                  todoList[index].description = editedDescription;
                  todoList[index].priority = editedPriority;
                });

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteTodoItem(TodoItem todoItem) {
    setState(() {
      todoList.remove(todoItem);
    });
  }

  MaterialColor setColor(int priority) {
    if (priority <= 2) {
      return Colors.red;
    } else if (priority <= 4) {
      return Colors.orange;
    } else if (priority <= 6) {
      return Colors.yellow;
    } else if (priority <= 8) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  List<TodoItem> _sortTodoListByPriority() {
    // 우선순위에 따라 Todo 항목 정렬
    todoList.sort((a, b) => a.priority.compareTo(b.priority));

    return todoList;
  }

  Widget _buildTodoListScreen() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            itemCount: _sortTodoListByPriority().length,
            itemBuilder: (context, index) {
              final sortedTodoList = _sortTodoListByPriority();
              final todoItem = sortedTodoList[index];

              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  minLeadingWidth: 80,
                  leading: Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      color: setColor(todoItem.priority),
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(
                    todoItem.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: todoItem.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  onTap: () {
                    _showTodoDetails(todoItem);
                  },
                  trailing: Checkbox(
                    value: todoItem.completed,
                    onChanged: (value) {
                      setState(() {
                        todoItem.completed = value!;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOtherScreen() {
    Color switchColor = _isLightMode ? Colors.blue : Colors.black;
    Color textColor = _isLightMode ? Colors.blue : Colors.black;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Switch(
            value: _isLightMode,
            onChanged: (val) {
              Get.isDarkMode
                  ? Get.changeTheme(ThemeData.light())
                  : Get.changeTheme(ThemeData.dark());
              // setState(() {
              //   _isLightMode = val;
              // });
              MyApp.themeNotifier.value =
                  MyApp.themeNotifier.value == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
            },
            activeColor: switchColor, // Apply color to the switch
          ),
          SizedBox(height: 10), // Add spacing between the switch and the text
          Text(
            _isLightMode ? 'Light Mode' : 'Dark Mode',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor, // Apply color to the text
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: IndexedStack(
        index: _currentPageIndex,
        children: [
          _buildTodoListScreen(),
          _buildOtherScreen(),
        ],
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
                    TextField(
                      controller: _priorityController,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                      ),
                      keyboardType: TextInputType.number,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Todo List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Other Screen',
          ),
        ],
      ),
    );
  }
}
