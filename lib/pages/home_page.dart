import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vcard_project/main.dart';
import 'package:vcard_project/pages/scan_page.dart';
import 'package:vcard_project/providers/contact_provider.dart';
import 'package:vcard_project/utils/helper_functions.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  void didChangeDependencies() {
    Provider.of<ContactProvider>(context, listen: false).getAllContacts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(ScanPage.routeName);
        },
        shape: const CircleBorder(),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
            backgroundColor: Colors.blue[100],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            currentIndex: selectedIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'All'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Favorite'),
            ]),
      ),
      body: Consumer<ContactProvider>(
          builder: (context, provider, child) => ListView.builder(
              itemCount: provider.contactList.length,
              itemBuilder: (context, index) {
                final contact = provider.contactList[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: EdgeInsets.only(right: 20),
                    alignment: FractionalOffset.centerRight,
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: _showConfirmtionDialog,
                  onDismissed: (_) async {
                    await provider.deleteContact(contact.id);
                    showMsg(context, 'Delete');
                  },
                  child: ListTile(
                    leading: Text('${contact.id}'),
                    title: Text(contact.name),
                    trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(contact.favorite
                            ? Icons.favorite
                            : Icons.favorite_border)),
                  ),
                );
              })),
    );
  }

  Future<bool?> _showConfirmtionDialog(DismissDirection direction) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete Contact'),
              content: const Text('Are your sure to delete this contact?'),
              actions: [
                OutlinedButton(
                    onPressed: () {
                      context.pop(false);
                    },
                    child: const Text('No')),
                OutlinedButton(
                  onPressed: () {
                    context.pop(true);
                  },
                  child: const Text('YES'),
                ),
              ],
            ));
  }
}
