import 'package:flutter/material.dart';
import 'package:secure_storage_flutter/data/database_helper.dart';
import 'package:secure_storage_flutter/data/secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secure_storage_flutter/data/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Preferances prefs = Preferances();

  DataBasehelper db = DataBasehelper();

  @override
  void initState() {
    // TODO: implement initState
    var path = db.getDbPath();
    // getExternalStorageDirectory().then((value) {
    //   String dbName = "myDb.db";
    //   String path = (value?.path ?? "") + dbName;
    //   db.open(path, "1234");
    // });
    db.open(path + "mydata.db", 'password');
    super.initState();
    init();
  }

  Future init() async {
    final name = await prefs.getUsername();
    setState(() {
      _usernameController.text = name.toString();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    prefs.deleteSecureData('password');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 20,
        title: Text(
          'Secure Storage Flutter',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.amber[300],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Enter Data Below to Store in Decure Storage.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: 'Enter username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: 'Enter Password',
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                prefs.writeSecureData('username', _usernameController.text);
                prefs.writeSecureData('password', _passwordController.text);

                db
                    .insert(User(
                        username: _usernameController.text,
                        password: _passwordController.text))
                    .then((value) => print(
                        "inserted data successfully in database  ${value?.username}"));
              },
              child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.amber[200],
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(child: const Text('Submit Data'))),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () async {
                  prefs.readSecureData('username');
                  prefs.readSecureData('password');
                  var data = await db.getData(_usernameController.text);
                  print(
                      "Database Data ==>     Username : ${data?.username}  passsword : ${data?.password}");
                },
                child: Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.amber[200],
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                        child: const Text('Show data in DEBUG CONSOLE')))),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                prefs.deleteSecureData('username');
                prefs.deleteSecureData('password');
                db.delete(_usernameController.text).then((value) {
                  print("No of rows deleted are : ${value}");
                });
              },
              child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.amber[200],
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(child: const Text('Delete Data'))),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                db.getAllData().then((value) {
                  value?.forEach((element) {
                    print(element.username);
                  });
                });
              },
              child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.amber[200],
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                      child: const Text('Display all data on DEBUG CONSOLE'))),
            ),
          ],
        ),
      ),
    ));
  }
}
