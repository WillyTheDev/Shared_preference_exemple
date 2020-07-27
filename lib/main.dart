import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shared preference',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: HomePage.id,
      routes: {
        HomePage.id: (context) => HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  static String id = "HomePage";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void getListOfDogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("dogs") != null) {
      var decodedDogs = prefs.getString("dogs").split(",");
      print(decodedDogs);
      listOfDogs = decodedDogs;
    }
  }

  TextEditingController _tc = TextEditingController();
  List listOfDogs = [];

  @override
  void initState() {
    getListOfDogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Your favorite dog's gif",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 26.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: GridView.builder(
                  gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150.0,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 0.8),
                  itemCount: listOfDogs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Image.network(listOfDogs[index]),
                    );
                  }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tc,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 3.0))),
                        onSubmitted: (value) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          if (prefs.get("dogs") != null) {
                            var encodedDogs =
                                prefs.getString("dogs") + "," + value;
                            print(encodedDogs);
                            prefs.setString("dogs", encodedDogs);
                          } else {
                            prefs.setString("dogs", value);
                          }
                          _tc.clear();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.clear();
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
