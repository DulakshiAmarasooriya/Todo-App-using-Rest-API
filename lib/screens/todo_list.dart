import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:convert';
import '../services/todo_services.dart';
import '../utilis/snackbar_helper.dart';
import '../widget/todo_card.dart';
import 'add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchToDo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchToDo,
        child: Visibility(
          visible: items.isNotEmpty,
          replacement: Center(
            child: Text(
              'No Todo Item',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          child: ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'] as String;
              return TodoCard(
                index: index,
                DeleteById: DeleteById,
                navigateEdit: navigateToEditPage,
                item: item,
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text('Add Todo'),
      ),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (contetx) => AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchToDo();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (contetx) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchToDo();
  }

  Future<void> DeleteById(String id) async {
    //Delete the item

    final isSuccess = await TodoService.deleteById(id);
    //Remove item from the List
    if (isSuccess) {
      final filtered =
          items = items.where((element) => element['_id'] != id).toList();
      setState(
        () {
          items = filtered;
        },
      );
    } else {
      showErrorMessage(context, message: 'Deletion Failed');
    }
  }

  Future<void> fetchToDo() async {
    setState(
      () {
        isLoading = false;
      },
    );
    final response = await TodoService.fetchToDo();

    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context, message: 'Something went wrong');
    }
    setState(
      () {
        isLoading = false;
      },
    );
  }
}
