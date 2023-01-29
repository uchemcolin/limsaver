import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

//my files
import 'viewVideo.dart'; //the second last most sure video player page file with empty containers and middle video player carousel page

class VideosTab extends StatefulWidget {

  //var videoList; //the list of the videos in WhatsApp statues

  //var videoThumbnailFileList = []; //the list of the thumbnails of the videos

  //VideosTab(this.videoList, this.videoThumbnailFileList);
  VideosTab();
  
  @override
  State<StatefulWidget> createState() {
    return _VideosTabState();
  }
}

class _VideosTabState extends State<VideosTab> {

  final Directory _photoDir = Directory(
    '/storage/emulated/0/WhatsApp/Media/.Statuses/');

  List<String> videoList = []; //the list of the videos in oldest first

  List<String> reversedVideoList = []; //the reversed list of the videos to recent first

  List<String> videoListToUse = [];

  var videoThumbnailFileList = [];

  var reversedVideoThumbnailFileList = [];

  var videoThumbnailFileListToUse = [];

  //to test code running every interval

  bool videosListOrderSortedBool = false; //the list order of the videos if its recent first or oldest last as bool

  _VideosTabState() {
    print("_VideosTabState()");
    print(videoList);
    print("\n");
  }

  //Function to get/create/recreate the videos viewed on WhatsApp status folder
  void createVideolist() async {
    setState(() {
      videoList = [];

      videoList = _photoDir
      .listSync()
      .map((item) => item.path)
      .where((item) => item.endsWith(".jpg") || item.endsWith(".png"))
      .toList(growable: false);
    });
  }

  //Function to get/create/recreate the reversed videos viewed on WhatsApp status folder
  void createReversedVideoList() async {
    setState(() {
      reversedVideoList = [];

      for(int i = 0; i < videoList.length; i++) {

        String videoString = videoList[videoList.length - (i + 1)];

        reversedVideoList.add(videoString);
      }

    });
  }
  
  //Function to create videos thumbnails
  void createVideoThumbnail() async {

    setState(() {
      videoThumbnailFileList = [];
    });
    

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

      setState(() {
        videoThumbnailFileList.add(thumbnailFile);
      });
      
    }
  }

  //Function to create reversed videos thumbnails
  void createReversedVideoThumbnail() async {

    setState(() {
      reversedVideoThumbnailFileList = [];
    });
    

    print("createReversedVideoThumbnail async function");

    for(int i = 0; i < reversedVideoList.length; i++) {
      final thumbnailFile = await VideoThumbnail.thumbnailFile(
        video: File(reversedVideoList[i]).path,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        //maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        //quality: 25,
      );
      setState(() {});

      setState(() {
        reversedVideoThumbnailFileList.add(thumbnailFile);
      });
      
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //get the videos viewed from WhatsApp
    videoList = _photoDir
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".mp4"))
        .toList(growable: false);

    //reverse the video list and store in reversed video list
    for(int i = 0; i < videoList.length; i++) {

      String videoString = videoList[videoList.length - (i + 1)];

      reversedVideoList.add(videoString);
    }

    createVideoThumbnail(); //create the thumbnails for the videos

    createReversedVideoThumbnail(); //create the reversed video thumbnails

    setState(() {
      videoListToUse = reversedVideoList; //set the video list to use or display to the reversed video list
      videoThumbnailFileListToUse = reversedVideoThumbnailFileList; //set the video thumbnail list to use or display to the reversed video thumbnail list
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, status) {
        if(videoListToUse.isNotEmpty && videoThumbnailFileListToUse.length == videoListToUse.length) {

          return RefreshIndicator(
            onRefresh: () async {
              
              setState(() {
                //The list of images in String

                //if the videos are in the recent first order
                if(videosListOrderSortedBool == false) {

                  setState(() {
                    //set the videos to show in the oldest first

                    videoListToUse = videoList;

                    videoThumbnailFileListToUse = videoThumbnailFileList;
                  });

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

                  videosListOrderSortedBool = true;
                } else { //if the videos are in the oldest first order
                  videosListOrderSortedBool = false;

                  setState(() {
                    //set the videos to show in the recent first

                    videoListToUse = reversedVideoList;

                    videoThumbnailFileListToUse = reversedVideoThumbnailFileList;
                  });

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
              itemCount: videoListToUse.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5
              ),
              itemBuilder: (context, index) {

                return Stack(
                  children: <Widget>[
                    GestureDetector(
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.file(
                              File(videoThumbnailFileListToUse[index]),
                              
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.black.withOpacity(0.2),
                            child: Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 80,
                            )
                          ),
                        ]
                      ),
                      onTap: () {
                        //Open view videos page

                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => ViewVideo(videoListToUse, index)) // for _viewVideo7.dart
                        );
                      }
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
                          String videopath = videoListToUse[index]; 

                          print("The image path: " + videopath);

                          File videoFile = File(videopath); //convert the image string to an image file

                          String fileName = videoFile.path.split('/').last;

                          String newVideoFilePath = "/storage/emulated/0/Limsaver/" + fileName;

                          final Directory _appDocDirFolder = Directory("/storage/emulated/0/Limsaver/");

                          final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true); //create Limsaver directory if it does not exist
                          
                          File newVideoFileSaved = await videoFile.copy(newVideoFilePath);

                          String message; // message to display in the snackbar
                          if(newVideoFileSaved == null) {
                            message = "Error saving video. Please retry.";
                          } else {
                            message = "Video saved successfully";
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
                              width: 200.0, // Width of the SnackBar.
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
                  ],
                  
                );
              },
            )
          );
        } else {

          if(videoListToUse.isNotEmpty) {
            return Center(
              child: CircularProgressIndicator()
            );
          } else {
            return Center(
              child: Text(
                "There are currently no videos. Please view some statuses to load some.",
                style: TextStyle(
                  fontSize: 17
                ),
              ),
            );
          }
        }
      },
    );
  }
}