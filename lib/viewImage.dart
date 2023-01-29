import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:share/share.dart';

class ViewImage extends StatefulWidget {

  final int imageIndex; //the index of the current image being viewed from the list of images
  final List<String> imageList; //the image list of the images

  ViewImage(this.imageList, this.imageIndex);

  @override
  State<StatefulWidget> createState() {
    return _ViewImageState(this.imageList, this.imageIndex);
  }
}

class _ViewImageState extends State<ViewImage> {
  //const ViewImage({ Key? key }) : super(key: key);

  final int imageIndex; //the initializer of the index of the current image being viewed
  final List<String> imageList; //the imGE list of the images
  late int currentImageIndex; //the index of the current image being viewed

  _ViewImageState(this.imageList, this.imageIndex) {
    currentImageIndex = imageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Limsaver",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        
        children: [
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                height: MediaQuery.of(context).size.height,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                initialPage: imageIndex,
                onPageChanged: (int newImageIndex, CarouselPageChangedReason carouselPageChangedReason) {
                  setState(() {
                    //set the current image to the newImageIndex
                    //once the carousel is changed
                    currentImageIndex = newImageIndex;
                  });
                }
              ),
              items: imageList
                .map((item) =>  
                    Container(
                    /*decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                        width: 5.0
                      ),
                    ),*/
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: InteractiveViewer(
                      child: Image.file(
                        File(item),
                        fit: BoxFit.contain,
                      )
                    ),
                  ),
                ).toList(),
            ),
          )
        ]
      ),
      floatingActionButton: SpeedDial( //Speed dial menu
        //marginBottom: 10, //margin bottom
        icon: Icons.add, //icon on Floating action button
        activeIcon: Icons.close, //icon when menu is expanded on button
        backgroundColor: const Color.fromARGB(255, 38, 120, 40), //background color of button
        foregroundColor: Colors.white, //font color, icon color in button
        activeBackgroundColor: const Color.fromARGB(255, 38, 120, 40), //background color when menu is expanded
        activeForegroundColor: Colors.white,
        buttonSize: const Size(56.0, 56.0), //button size
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'), // action when menu opens
        onClose: () => print('DIAL CLOSED'), //action when menu closes

        elevation: 8.0, //shadow elevation of button
        shape: CircleBorder(), //shape of button
        
        children: [
          SpeedDialChild( //speed dial child
            child: Icon(Icons.save),
            backgroundColor: const Color.fromARGB(255, 38, 120, 40),
            foregroundColor: Colors.white,
            label: 'Save',
            labelStyle: TextStyle(fontSize: 18.0),
            //onTap: () => print('FIRST CHILD'),
            onTap: () async {

              //save the image in the device's Limsaver folder in the internal storage

              String imagepath = imageList[currentImageIndex]; 

              print("The image path: " + imagepath);

              File imageFile = File(imagepath); //convert the image string to an image file

              String fileName = imageFile.path.split('/').last;

              String newImageFilePath = "/storage/emulated/0/Limsaver/" + fileName;

              final Directory _appDocDirFolder = Directory("/storage/emulated/0/Limsaver/");

              final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true); //create Limsaver directory if it does not exist
              
              File newImageFileSaved = await imageFile.copy(newImageFilePath);

              String message; // message to display in the snackbar
              if(newImageFileSaved == null) {
                message = "Error saving image. Please retry.";
              } else {
                message = "Image saved successfully";
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  /*action: SnackBarAction(
                    label: 'Action',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),*/
                  content: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),
                  duration: const Duration(milliseconds: 1500),
                  width: 250.0, // Width of the SnackBar.
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, // Inner padding for SnackBar content.
                    vertical: 15.0
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              );
            },
            onLongPress: () => print('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.share),
            backgroundColor: const Color.fromARGB(255, 38, 120, 40),
            foregroundColor: Colors.white,
            label: 'Share',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {

              //share the image via the share button being clicked

              List<String> imagePaths = [imageList[currentImageIndex]];

              await Share.shareFiles(imagePaths);//, text: "Image shared");
            },
            onLongPress: () => print('SECOND CHILD LONG PRESS'),
          ),
        ],
      ),
    );
  }
}