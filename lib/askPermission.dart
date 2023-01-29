import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

//My Flutter Files
import './home.dart';

class AskPermission extends StatefulWidget {

  //const AskPermission({ Key? key }) : super(key: key);
  AskPermission();

  @override
  State<AskPermission> createState() => _AskPermissionState();
}

class _AskPermissionState extends State<AskPermission> with SingleTickerProviderStateMixin {

  bool permissionGranted = false; //bool to know if (internal) storage permission has been granted

  _AskPermissionState();

  @override
  void initState() {
    super.initState();

    _getStoragePermission();

  }

  @override
  void dispose() {
    
    super.dispose();
  }

  //function to know if (internal) storage permission has been granted
  Future _getStoragePermission() async {

    if(await Permission.storage.isGranted == true) {

      //if (internal) storage access has been granted
      //set permission granted to true
      setState(() {
        permissionGranted = true;
      });
      
    } else {

      //if (internal) storage access has been granted
      //set permission granted to false
      setState(() {
        permissionGranted = false;
      });

    }
  }

  //Ask for permission to access (internal) storage and files
  Future _askStoragePermission() async {
    
    //request for storage permission
    //if it is granted, set permissiongranted to true
    //and redirect to the Home page to view files and videos from WhatsApp statues
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home())
      );

    } else if (await Permission.storage.request().isPermanentlyDenied) {

      //if storage access was permanently denied,
      //open app settings so the user can manually grant the file storage access
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {

      //if storage access is denied,
      //set permissionGranted to false
      setState(() {
        permissionGranted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //primarySwatch: ,
        //colorScheme: Color.fromARGB(255, 38, 120, 40),
        //primarySwatch: Color.fromARGB(255, 38, 120, 40),
        //primarySwatch: ,
        //primaryColor: Color.fromARGB(255, 38, 120, 40),
        /*colorScheme: ColorScheme.fromSwatch(
          primaryColor: Color.fromARGB(255, 38, 120, 40),
        )*/
        colorScheme: ColorScheme.fromSwatch().copyWith(

          primary: Color.fromARGB(255, 38, 120, 40),
          //secondary: Color.fromARGB(255, 38, 120, 40)

          // or from RGB

          /*primary: const Color(0xFF343A40),
          secondary: const Color(0xFFFFC107),*/

        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Limsaver"),
          actions: [
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.help_outline,
                  size: 30.0,
                ),
              ),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text(
                      'Usage',
                      textAlign: TextAlign.center,
                    ),
                    content: Container(
                      height: 200.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: double.infinity,
                            child: const Text(
                              '1. Open WhatsApp Status',
                              textAlign: TextAlign.left
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: const Text(
                              '2. View status from WhatsApp',
                              textAlign: TextAlign.left
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: const Text(
                              '3. Open this App to Download',
                              textAlign: TextAlign.left
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Developed by Colin Uchem ",
                                  style: TextStyle(
                                    color: Colors.black
                                  )
                                ),
                                TextSpan(
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  text: "(www.uchemcolin.xyz)",
                                    recognizer: TapGestureRecognizer()..onTap =  () async{
                                      var url = Uri.parse("http://www.uchemcolin.xyz");
                                      //var url = Uri.parse("https://www.google.com");
                                      
                                      if (await canLaunchUrl(url)) {
                                      //try {
                                        await launchUrl(url);
                                      } else {
                                      //} catch(e) {
                                        //throw 'Could not launch $url';

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            /*action: SnackBarAction(
                                              label: 'Action',
                                              onPressed: () {
                                                // Code to execute.
                                              },
                                            ),*/
                                            content: Text(
                                              "Could not open the website",
                                              style: TextStyle(
                                                fontSize: 18
                                              ),
                                              textAlign: TextAlign.center
                                            ),
                                            duration: const Duration(milliseconds: 1500),
                                            width: 200.0, // Width of the SnackBar.
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, // Inner padding for SnackBar content.
                                              vertical: 10.0
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                ),
                              ]
                          )),
                          Divider(
                            color: Colors.black,
                          ),
                          Container(
                            width: double.infinity,
                            child: const Text(
                              'Limsaver version: 1.0.0+1',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13
                              ),
                            ),
                          ),
                        ]
                      )
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  )
                );
              },
            )
          ],
          backgroundColor: const Color.fromARGB(255, 38, 120, 40),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: ElevatedButton(
              onPressed: _askStoragePermission,
              child: Text("Give Storage Access")
            )
          )
        ),
      ),
    );
  }
}