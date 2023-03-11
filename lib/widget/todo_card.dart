import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) DeleteById;
  const TodoCard(
      {super.key,
      required this.index,
      required this.item,
      required this.navigateEdit,
      required this.DeleteById});

  @override
  Widget build(BuildContext context) {
    final id = item['_id'];
    return Card(
      child: ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(item['title']),
          subtitle: Text(item['description']),
          trailing: PopupMenuButton(
            onSelected: (value) {
              if (value == 'edit') {
                //open the edit page
                navigateEdit(item);
              } else if (value == 'delete') {
                //delete and remove the item
                DeleteById(id);
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Edit'),
                  value: 'edit',
                ),
                PopupMenuItem(
                  child: Text('Delete'),
                  value: 'delete',
                ),
              ];
            },
          )),
    );
    ;
  }
}
