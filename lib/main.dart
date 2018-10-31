import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'dart:async';

Permission permissionFromString(String value) {
  Permission permission;
  for (Permission item in Permission.values) {
    if (item.toString() == value) {
      permission = item;
      break;
    }
  }
  return permission;
}

void main() async {
  await SimplePermissions.requestPermission(
      permissionFromString("Permission.ReadContacts"));
  await SimplePermissions.requestPermission(
      permissionFromString("Permission.WriteContacts"));

  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _state createState() => new _state();
}

class _state extends State<MyApp> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _create() async {
    Contact contact = new Contact(
      familyName: 'Mak',
      givenName: 'BCA',
      emails: [new Item(label: 'work', value: 'maksud@samcomtechnologies.com')],
    );
    await ContactsService.addContact(contact);
    showInSnackbar('Contact Created');
  }

  void _find() async {
    Iterable<Contact> people = await ContactsService.getContacts(query: 'BCA');
    showInSnackbar('there are: ${people.length} people named mak');
  }

  void _read() async {
    Iterable<Contact> people = await ContactsService.getContacts(query: 'BCA');
    Contact contact = people.first;
    showInSnackbar('Email: ${contact.emails.first.value}');
  }

  void _delete() async {
    Iterable<Contact> people = await ContactsService.getContacts(query: 'BCA');
    Contact contact = people.first;

    await ContactsService.deleteContact(contact);
    showInSnackbar('Contact Deleted');
  }

  void showInSnackbar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('My Title'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text('Hello World!'),
              new RaisedButton(
                onPressed: _create,
                child: new Text('Create'),
              ),
              new RaisedButton(
                onPressed: _find,
                child: new Text('Find'),
              ),
              new RaisedButton(
                onPressed: _read,
                child: new Text('Read'),
              ),
              new RaisedButton(
                onPressed: _delete,
                child: new Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
