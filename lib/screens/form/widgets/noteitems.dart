import 'package:flutter/material.dart';
import 'package:todo/core/colors.dart';
import '../screen_form.dart.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    super.key,
    required this.title,
    required this.discription,
    required this.id,
    required this.toDelete,
    required this.items,
  });

  final String id;
  final String title;
  final String discription;
  final Function(String id) toDelete;
  final Map items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          color: appBarColor),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(
                  title,
                  style: const TextStyle(color: appbarTitleColor),
                  overflow: TextOverflow.ellipsis,
                )),
                PopupMenuButton(
                  color: titleColor, 
                  icon: const Icon(
                    
                    Icons.more_vert,
                    color: buttonColor, 
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      navigate(context, items, true, id);
                    } else if (value == 'delete') {
                      toDelete(id);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(
                          value: 'delete', child: Text('Delete')),
                    ];
                  },
                )
              ],
            ),
          ),
          Text(discription, style: const TextStyle(color: titleColor)),
        ],
      ),
    );
  }
}

void navigate(BuildContext context, Map items, bool isEdit, String id) {
  final navigte = MaterialPageRoute(
    builder: (context) => ScreenForm(
      id: id,
      note: items,
      isEdit: isEdit,
    ),
  );
  Navigator.push(context, navigte);
}
