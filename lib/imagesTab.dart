import 'package:flutter/material.dart';
import 'dart:io';

//My files
import 'viewImage.dart';

class ImagesTab extends StatefulWidget {

  var imageList;

  ImagesTab(this.imageList);
  
  @override
  State<StatefulWidget> createState() {
    return _ImagesTabState(imageList);
  }
}

class _ImagesTabState extends State<ImagesTab> {

  final Directory _photoDir = Directory(
    '/storage/emulated/0/WhatsApp/Media/.Statuses/'); //the directory or folder where WhatsApp statues are in when viewed the user's WhatsApp folder

  late List<String> imageList; //the list of strings with the viewed images from WhatsApp statues in oldest first

  List<String> imageListToUse = []; //the image list to use and display the images

  List<String> reversedImageList = []; //the revered image list making the last first and first last, etc (recent first)

  bool imagesListOrderSortedBool = false; //the order of the images bool, if it is recent first or oldest first

  _ImagesTabState(this.imageList);
  
  //const ({ Key? key }) : super(key: key);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //get the images in the WhatsApp statues folder
    imageList = _photoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".jpg") || item.endsWith(".png"))
          .toList(growable: false);

    //to reverse the images list
    for(int i = 0; i < imageList.length; i++) {

      String imgString = imageList[imageList.length - (i + 1)];

      reversedImageList.add(imgString);
    }

    imageListToUse = reversedImageList; //set the images to use to the reversedImages list
  }

  //Function to create/recreate the image list
  void createImagelist() {
    setState(() {
      imageList = [];

      imageList = _photoDir
      .listSync()
      .map((item) => item.path)
      .where((item) => item.endsWith(".jpg") || item.endsWith(".png"))
      .toList(growable: false);
    });
    
  }

  //Function to create/recreate the reversedImage list
  void createReversedImageList() {
    setState(() {
      reversedImageList = [];

      for(int i = 0; i < imageList.length; i++) {

        String imageString = imageList[imageList.length - (i + 1)];

        reversedImageList.add(imageString);
      }

      imageListToUse = reversedImageList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, status) {
        if(imageListToUse.isNotEmpty) {

          return RefreshIndicator(
            onRefresh: () async {

              setState(() {
                //The list of images in String

                if(imagesListOrderSortedBool == false) {

                  createImagelist(); //to recreate the images List

                  imageListToUse = imageList; //set the images list to use to the new one recreated

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      /*action: SnackBarAction(
                        label: 'Action',
                        onPressed: () {
                          // Code to execute.
                        },
                      ),*/
                      content: Text(
                        "Oldest First",
                        style: TextStyle(
                          fontSize: 20
                        ),
                        textAlign: TextAlign.center
                      ),
                      duration: const Duration(milliseconds: 1500),
                      width: 180.0, // Width of the SnackBar.
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

                  imagesListOrderSortedBool = true; //set the sorted variable to true
                } else {
                  imagesListOrderSortedBool = false; //set the sorted variable to false

                  createReversedImageList();  //to recreate the reversedImages List

                  imageListToUse = reversedImageList; //set the images list to use to the reversed one recreated

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      /*action: SnackBarAction(
                        label: 'Action',
                        onPressed: () {
                          // Code to execute.
                        },
                      ),*/
                      content: Text(
                        "Recent First",
                        style: TextStyle(
                          fontSize: 20
                        ),
                        textAlign: TextAlign.center
                      ),
                      duration: const Duration(milliseconds: 1500),
                      width: 180.0, // Width of the SnackBar.
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
                }

              });
            },
            child: GridView.builder(
              itemCount: imageListToUse.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5
              ),
              itemBuilder: (context, index) {
                return Stack(
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.file(
                          File(imageListToUse[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {

                        //redirect to the view image page
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => ViewImage(imageListToUse, index))
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(right: 5, bottom: 5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 38, 120, 40),
                            borderRadius: BorderRadius.circular(50)
                          ),
                          child: Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 20.0
                          ),
                        ),
                        onTap: () async {
                          String imagepath = imageListToUse[index]; 

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
                                style: TextStyle(
                                  fontSize: 15
                                ),
                                textAlign: TextAlign.center
                              ),
                              duration: const Duration(milliseconds: 1500),
                              width: 220.0, // Width of the SnackBar.
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
                      )
                    )
                  ]
                );
              },
            )
        
          );
        } else {
          return Center(
            child: Text(
              "There are currently no images. Please view some statuses to load some.",
              style: TextStyle(
                fontSize: 17
              ),
            ),
          );
        }
      },
    );
  }
}