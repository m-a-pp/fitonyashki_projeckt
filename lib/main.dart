import 'package:fitonyashki_projeckt/pages/home_page.dart';
import 'package:fitonyashki_projeckt/pages/new_activity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitonyashki_projeckt/pages/first_run.dart';
import 'package:fitonyashki_projeckt/user.dart';
late SharedPreferences preferences;
bool seen = false;
User user = User(name: '', height: 175, weight: 60);
void main() async{
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance()
        .then((prefs){
      setState(() => preferences = prefs);
      seen = preferences.getBool('seen') ?? false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'WorkSans',
        primaryColor: Colors.white,
      ),
      title: 'Fitonyash',
      initialRoute: '/',
      routes: {
        '/': (context) => seen ? HomePage() : firstRun(),
        '/CurrentActivity': (context) => CurrentActivity(),
        '/Help': (context) => Help(),
      },
    );
  }
}






