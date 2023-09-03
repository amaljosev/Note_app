import 'package:flutter/material.dart';
import '../../core/api.dart';
import '../../core/colors.dart';
import '../../utiles/snakebars.dart';

TextEditingController titleController = TextEditingController();
TextEditingController descrpitionController = TextEditingController();

class ScreenForm extends StatefulWidget {
  const ScreenForm({
    super.key,
    this.id,
    this.note,
    required this.isEdit,
  });

  // ignore: prefer_typing_uninitialized_variables
  final id;
  final Map? note;
  final bool isEdit;

  @override
  State<ScreenForm> createState() => _ScreenFormState();
}

class _ScreenFormState extends State<ScreenForm> {
  @override
  void initState() {
    super.initState();

    if (widget.isEdit == true) {
      final toDo = widget.note;
      if (toDo != null) {
        final title = toDo['title'];
        final description = toDo['description'];
        titleController.text = title;
        descrpitionController.text = description;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.text = '';
    descrpitionController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: titleColor),
          backgroundColor: appBarColor,
          title: Text(
            widget.isEdit ? 'Update note' : 'New note',
            style: const TextStyle(color: appbarTitleColor),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                    hintText: 'Title', hintStyle: TextStyle(color: titleColor)),
                controller: titleController,
                style: const TextStyle(
                  color: titleColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: 5,
                decoration: const InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(color: titleColor)),
                controller: descrpitionController,
                style: const TextStyle(
                  color: titleColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () =>
                    widget.isEdit ? updateData(widget.id) : submitData(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  fixedSize: const Size.fromWidth(380),
                  shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: appbarTitleColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descrpitionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final isSuccess = await Api.addNote(body);

    if (isSuccess) {
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, 'Creation Success');
      titleController.text = '';
      descrpitionController.text = '';
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, 'Creation Faild');
    }
  }

  Future<void> updateData(id) async {
    if (id == null || id.isEmpty) {
      return;
    }
    final title = titleController.text;
    final description = descrpitionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final isSuccess = await Api.updatNote(id, body);

    if (isSuccess) {
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, 'Update Success');
      titleController.text = '';
      descrpitionController.text = '';
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, 'Update Faild');
    }
  }
}
