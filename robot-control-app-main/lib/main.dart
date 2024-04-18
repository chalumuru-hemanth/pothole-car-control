import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Robot Control App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String status = "Status: ";
  TextEditingController ipaddress = TextEditingController();
  String value = "null";

  void sendCommand(String command) async {
    try {
      String url = "http://$value/?State=$command";
      print(url);
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          status = "Status: ${truncateCoordinates(response.body)}";
        });
      } else {}
    } catch (e) {
      print('Error: $e');
    }
  }

  String truncateCoordinates(String coordinates) {
    const int maxCharacters = 50;
    return coordinates.length > maxCharacters
        ? "${coordinates.substring(0, maxCharacters)}..."
        : coordinates;
  }

  Widget buildControlButton(String command, String label, Color color) {
    return GestureDetector(
      onTapDown: (_) {
        sendCommand(command);
      },
      onTapUp: (_) {
        sendCommand("S");
      },
      onTapCancel: () => sendCommand("S"),
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color.withOpacity(1.0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Changed background color
      appBar: AppBar(
        backgroundColor: Colors.grey[900], // Changed app bar color
        title: const Text('Robot Control App'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter IP Address',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.all(15), // Added padding
                      ),
                      controller: ipaddress,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    if (ipaddress.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("IP address is empty")));
                    } else {
                      setState(() {
                        value = ipaddress.text;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.lightBlueAccent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Enter",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            "IP Address : $value",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            status,
            style: TextStyle(fontSize: 16, color: Colors.white),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildControlButton("F", "Forward", Colors.green),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildControlButton("L", "Left", Colors.orange),
                      buildControlButton("S", "Stop", Colors.red),
                      buildControlButton("R", "Right", Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildControlButton("B", "Backward", Colors.blue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
