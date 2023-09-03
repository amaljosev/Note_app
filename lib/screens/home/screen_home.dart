import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:todo/core/colors.dart';
import 'package:todo/screens/form/widgets/noteitems.dart';
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
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        onPressed: () => navigate(context),
        child: const Icon(
          Icons.add,
          color: titleColor,
        ),
      ),
    );
  }

  Future<void> fetchAllData() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    } else {
      //show error
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteData(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      //show error
    }
  }

  void navigate(BuildContext context) {
    final navigte = MaterialPageRoute(
      builder: (context) => const ScreenForm(isEdit: false),
    );
    Navigator.push(context, navigte);
  }
}
