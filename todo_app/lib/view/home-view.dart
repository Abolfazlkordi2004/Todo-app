import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/dialogs/error-dialog.dart';
import 'package:todo_app/dialogs/logout_dialog.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _Homeview();
}

class _Homeview extends State<Homeview> {
  late TextEditingController _searchBox;

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
    // if (!mounted) return;

    switch (index) {
      case 0:
        try {
          bool shouldLogout = await showLogOutDialog(context);
          if (shouldLogout) {
            await FirebaseAuth.instance.signOut();
            // if (!mounted) return; // Guard to check if context is still valid
            Navigator.of(context).pushNamedAndRemoveUntil(
              loginRoute,
              (route) => false,
            );
          }
        } on FirebaseAuthException catch (e) {
          // if (!mounted) return; // Guard again
          await showErrordialog(context, e.code);
        }
        break;

      case 1:
        // Simple navigation to the profile route
        Navigator.of(context).pushNamed(profileRoute);
        break;

      default:
        break;
    }

    // Always update the selected index after the logic is completed
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Padding(
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
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.5),
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
      ),
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
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey.shade600,
        iconSize: 28,
        selectedFontSize: 15,
        unselectedFontSize: 13,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
