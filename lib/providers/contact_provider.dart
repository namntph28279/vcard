import 'package:flutter/foundation.dart';
import 'package:vcard_project/db/db_helper.dart';
import 'package:vcard_project/models/contact_model.dart';

class ContactProvider extends ChangeNotifier {
  List<ContactModel> contactList = [];
  final db = DbHelper();

  Future<int> insertContact(ContactModel contactModel) async {
    final rowId = await db.insertContact(contactModel);
    contactModel.id = rowId;
    contactList.add(contactModel);
    notifyListeners();
    return rowId;
  }

  Future<void> getAllContacts() async {
    contactList = await db.getAllContact();
    notifyListeners();
  }

  Future<int> deleteContact(int id) {
    return db.deleteContact(id);
  }
}
