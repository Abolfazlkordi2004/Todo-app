import 'package:flutter/material.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/dialogs/error-dialog.dart';
import 'package:todo_app/dialogs/logout_dialog.dart';
import 'package:todo_app/services/auth/auth_exception.dart';
import 'package:todo_app/services/auth/auth_service.dart';
import 'package:todo_app/view/task_list_view.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _Homeview();
}

class _Homeview extends State<Homeview> {
  late TextEditingController _searchBox;
  // late final TaskListView _listView;

  int _selectedIndex = 0;

  @override
  void initState() {
    _searchBox = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchBox.dispose();
    super.dispose();
  }

  Future<void> _onItemTapped(int index) async {
    if (!mounted) return;

    switch (index) {
      case 0:
        try {
          bool shouldLogout = await showLogOutDialog(context);
          if (shouldLogout) {
            await AuthService.firebase().logOut();
            if (!mounted) return;
            Navigator.of(context).pushNamedAndRemoveUntil(
              loginRoute,
              (route) => false,
            );
          }
        } on GenericAuthExceptions {
          if (!mounted) return;
          await showErrordialog(context, 'Unknown error');
        }
        break;

      case 1:
        Navigator.of(context).pushNamed(profileRoute);
        break;

      default:
        break;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Task'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
      ),
      body: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        children: [
                          TextField(
                            // controller: _searchBox,
                            decoration: InputDecoration(
                              hintText: 'Search here ...',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.5),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.search),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }

              default:
                return const CircularProgressIndicator();
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.grey.shade600,
        iconSize: 28,
        selectedFontSize: 15,
        unselectedFontSize: 13,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            createTaskRoute,
            (route) => false,
          );
        },
        backgroundColor: Colors.blue.shade200,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
