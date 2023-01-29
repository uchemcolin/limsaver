import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:url_launcher/url_launcher.dart';

//My Flutter Files
import './imagesTab.dart';
import './videosTab.dart';

class Home extends StatefulWidget {

  //const Home({ Key? key }) : super(key: key);
  Home();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  late PermissionStatus internalStorageStatus;
  //late bool internalStorageStatusIsGranted;
  bool internalStorageStatusIsGranted = false;

  String imagesListOrder = "recentFirst"; //how the images should be displayed
  bool imagesListOrderSortedBool = false;

  bool permissionGranted = false;

  final Directory _photoDir = Directory(
    '/storage/emulated/0/WhatsApp/Media/.Statuses/'); //the directory or folder where WhatsApp statues are in when viewed the user's WhatsApp folder

  var imageList; //the list of string of the images in the WhatsApp statues folder

  var initialVideoList;

  var videoList; //the list of string of the videos in the WhatsApp statues folder

  var videoThumbnailFileList = []; //the list of string of the thumbnails of the videos created by the app and temporarily stored

  var _getStoragePermissionBool; //bool to store the value of if the user has granted the app file storage access or (internal) storage access

  //Variables for the tabs
  late TabController _tabController;

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'IMAGES'),
    Tab(text: 'VIDEOS'),
  ]; //The tabs or tab headings for the TabView

  _HomeState();

  @override
  void initState() {
    super.initState();

    setState(() {
      //find out if the user has granted the app (internal) storage access
      _getStoragePermissionBool = _getStoragePermission();
    });

    _tabController = TabController(vsync: this, length: myTabs.length); // 

    //The list of images in the statues folder in String
    imageList = _photoDir
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".jpg") || item.endsWith(".png"))
        .toList(growable: false);

    initialVideoList = imageList;

    //The list of videos in the statues folder in String
    videoList = _photoDir
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".mp4"))
        .toList(growable: false);

    print("Image listing order: " + imagesListOrder);

    createVideoThumbnail(); //create the list of the thumbnails of the videos 
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //Ask for permission to access files

  //Function to create the list of the thumbnails of the videos 
  void createVideoThumbnail() async {

    print("createVideoThumbnail async function");

    for(int i = 0; i < videoList.length; i++) {
      final thumbnailFile = await VideoThumbnail.thumbnailFile(
        video: File(videoList[i]).path,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        //maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        //quality: 25,
      );
      setState(() {});

      videoThumbnailFileList.add(thumbnailFile);
    }

    print("Video File List:\n");
    print(videoList);

    print("\nVideo Thumbnail File List:\n");
    print(videoThumbnailFileList);
  }

  //Function to check if storage access has been graanted by the user
  Future<bool> _getStoragePermission() async {

    //request storage access and if it is granted
    //set permissionGranted to true
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });

    } else if (await Permission.storage.request().isPermanentlyDenied) {
      //if storage access was permanently denied by the user
      //let the user manually set it in the settings app
      await openAppSettings();

    } else if (await Permission.storage.request().isDenied) {

      //if storage access is denied
      //set permissionGranted to false
      setState(() {
        permissionGranted = false;
      });

    }

    return permissionGranted;
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
                                    decoration: TextDecoration.underline
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
                              'Limsaver version: 1.0.0',
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
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            //Tab 1 for images
            ImagesTab(imageList),

            //Tab Two
            //VideosTab(videoList, videoThumbnailFileList)
            VideosTab()
          ],
        ),
      ),
    );
  }
}