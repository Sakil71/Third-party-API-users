import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> users = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('API Users'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUsers,
        child: const Text('Call'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              final user = users[index];
              final email = user['email'];
              final titleName = user['name']['title'];
              final firstName = user['name']['first'];
              final lastName = user['name']['last'];
              return Card(
                color: user['gender'] == 'male'
                    ? Colors.orange[400]
                    : Colors.pinkAccent[200],
                child: ListTile(
                  title: Text(
                    titleName + ' ' + firstName + ' ' + lastName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(email),
                  trailing: Text(
                    user['location']['country'],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
            itemCount: users.length,
          ),
        ),
      ),
    ));
  }

  void fetchUsers() async {
    const url = 'https://randomuser.me/api/?results=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['results'];
    });

    print('fetch users completed');
  }
}
