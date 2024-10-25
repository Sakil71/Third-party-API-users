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

  void fetchUsers() async {
    const url = 'https://randomuser.me/api/?results=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['results'];
    });
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('API Users : ${users.length}'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
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
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user['picture']['medium']),
                    ),
                  ),
                  title: Text(
                    titleName + ' ' + firstName + ' ' + lastName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          // Set initial values before showing the dialog
                          setState(() {
                            titleController.text =
                                users[index]['name']['title'];
                            firstNameController.text =
                                users[index]['name']['first'];
                            lastNameController.text =
                                users[index]['name']['last'];
                            emailController.text = users[index]['email'];
                            selectedIndex = index;
                          });

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Edit User'),
                                content: Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Ensures the dialog fits content
                                  children: [
                                    TextField(
                                      controller: titleController,
                                      decoration: const InputDecoration(
                                        hintText: 'Title name',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: firstNameController,
                                      decoration: const InputDecoration(
                                        hintText: 'First name',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: lastNameController,
                                      decoration: const InputDecoration(
                                        hintText: 'Last name',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        hintText: 'Email',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      String title =
                                          titleController.text.trim();
                                      String firstName =
                                          firstNameController.text.trim();
                                      String lastName =
                                          lastNameController.text.trim();
                                      String email =
                                          emailController.text.trim();

                                      if (title.isNotEmpty &&
                                          firstName.isNotEmpty &&
                                          lastName.isNotEmpty &&
                                          email.isNotEmpty) {
                                        // Clear text fields after use
                                        titleController.clear();
                                        firstNameController.clear();
                                        lastNameController.clear();
                                        emailController.clear();

                                        setState(() {
                                          // Update user data in the nested map
                                          users[selectedIndex]['name']
                                              ['title'] = title;
                                          users[selectedIndex]['name']
                                              ['first'] = firstName;
                                          users[selectedIndex]['name']['last'] =
                                              lastName;
                                          users[selectedIndex]['email'] = email;
                                          selectedIndex = -1; // Reset selection
                                        });

                                        Navigator.of(context)
                                            .pop(); // Close dialog
                                      }
                                    },
                                    child: const Text('Save'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close dialog without saving
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.edit),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () {
                            setState(() {
                              users.removeAt(index);
                            });
                          },
                          child: const Icon(Icons.delete))
                    ],
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
}
