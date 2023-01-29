import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

//my files
import './home.dart';
import './askPermission.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Splash Screen',
      theme: ThemeData(
        //primarySwatch: Colors.green,
        //primaryColor: Color.fromARGB(255, 38, 120, 40)
        colorScheme: ColorScheme.fromSwatch().copyWith(

          primary: Color.fromARGB(255, 38, 120, 40),
          //secondary: Color.fromARGB(255, 38, 120, 40)

          // or from RGB

          /*primary: const Color(0xFF343A40),
          secondary: const Color(0xFFFFC107),*/

        ),
      ),
      home: MySplashScreenPage(),
      //debugShowCheckedModeBanner: false,
    );
  }
}

class MySplashScreenPage extends StatefulWidget {
  //const MySplashScreenPage({Key? key}) : super(key: key);

  @override
  _MySplashScreenPageState createState() => _MySplashScreenPageState();

}

class _MySplashScreenPageState extends State<MySplashScreenPage> {

  bool _permissionGranted = false;

  _MySplashScreenPageState() {
    
  }

  @override
  void initState() {
    super.initState();

    //find out if app has (internal) storage access
    _getStoragePermission();

    //Automatically redirect to the next phase
    //after displaying the splashscreen for 5 seconds
    Timer(Duration(seconds: 5), () {

      if(_permissionGranted == true) {

        //if (internal) storage has been granted
        //go to the Home page where you can view
        //the images and videos from WhatsApp statues
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => Home())
        );

      } else {

        //if (internal) storage has not been granted
        //go to the page to ask for storage permission
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => AskPermission())
        );

      }
    });
  }

  //Function to check if (internal) storage access has been granted
  Future _getStoragePermission() async {

    if(await Permission.storage.isGranted == true) {
      setState(() {
        _permissionGranted = true;
      });
    } else {
      setState(() {
        _permissionGranted = false;
      });
    }

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //primarySwatch: Colors.green,
        //primaryColor: Color.fromARGB(255, 38, 120, 40)
        colorScheme: ColorScheme.fromSwatch().copyWith(

          primary: Color.fromARGB(255, 38, 120, 40),
          //secondary: Color.fromARGB(255, 38, 120, 40)

          // or from RGB

          /*primary: const Color(0xFF343A40),
          secondary: const Color(0xFFFFC107),*/

        ),
      ),
      home: Container(
        decoration: const BoxDecoration(color: Colors.white),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "my_assets/images/download-1915753_1280.png",
                width: 100,
                height: 100,
              )
            ),
            Center(
              child: Text(
                "Developed by Colin Uchem",
                style: GoogleFonts.acme(
                  textStyle: const TextStyle(
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black
                  )
                ),
              )
            )
          ],
        )
      )
    );
  }
}
