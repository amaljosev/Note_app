import 'package:flutter/material.dart';
import 'package:todo/core/api.dart';
import 'package:todo/core/colors.dart';
import 'package:todo/screens/form/widgets/noteitems.dart';
import 'package:todo/utiles/snakebars.dart';
import '../form/screen_form.dart.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          'Note App',
          style: TextStyle(color: appbarTitleColor),
        ),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchAllData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
              child: Text('Notes Empty', style: TextStyle(color: buttonColor)),
            ),
            child: GridView.count(
              padding: const EdgeInsets.all(8),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: List.generate(items.length, (index) {
                final item = items[index] as Map;
                final id = item['_id'];
                return NoteItem(
                  id: id,
                  items: item,
                  title: item['title'] ?? '',
                  discription: item['description'] ?? '',
                  toDelete: (id) => deleteData(id),
                );
              }),
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        onPressed: () => navigate(context),
        child: const Icon(
          Icons.add,
          color: appbarTitleColor,
        ),
      ),
    );
  }

  Future<void> fetchAllData() async {
    final response = await Api.fetchNotes();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, 'Fetch failed');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteData(String id) async {
    final isSuccess = await Api.deleteById(id);
    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, 'Deletion failed'); 
    }
  }

  void navigate(BuildContext context) {
    final navigte = MaterialPageRoute(
      builder: (context) => const ScreenForm(isEdit: false),
    );
    Navigator.push(context, navigte);
  }
}
