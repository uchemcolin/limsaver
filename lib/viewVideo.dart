import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

class ViewVideo extends StatefulWidget {

  final int videoIndex; //the index current video to be viewed/played from the list of videos
  final List<String> videoList; //the list of the videos from WhatsApp viewed in status

  ViewVideo(this.videoList, this.videoIndex);

  @override
  State<StatefulWidget> createState() {
    return _ViewVideoState(this.videoList, this.videoIndex);
  }
}

class _ViewVideoState extends State<ViewVideo> {
  //const ViewVideo({ Key? key }) : super(key: key);

  final int videoIndex; //the initializer of the index current video to be viewed/played from the list of videos
  final List<String> videoList; //the list of the videos from WhatsApp viewed in status
  late int currentVideoIndex; //the index current video to be viewed/played from the list of videos

  late File currentVideoFile; //the current video to be viewed or played in file

  late List<VideoPlayerController> videoPlayerControllersList = []; //the list of the video controllers of all the videos

  late List<ChewieController> chewieControllersList = []; //the list of the chewie controllers of the video controllers of all the videos

  _ViewVideoState(this.videoList, this.videoIndex) {
    currentVideoIndex = videoIndex; //set the current video being viewed
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    currentVideoFile = File(videoList[currentVideoIndex]); //convert the current video from string to file

    for(int i = 0; i < videoList.length; i++) {

      final VideoPlayerController newVideoPlayerController;

      //if its the current video being viewed, initialize the videoPlayerController,
      //its chewieController and store them in the videoPlayerControllers and chewieControllers
      //and then start the video on load (i.e. autoplay the video)
      if(i == currentVideoIndex) {
        newVideoPlayerController = VideoPlayerController.file(File(videoList[i]))
          ..addListener(() =>  setState(() {}))
          ..setLooping(false);

          newVideoPlayerController.initialize().then((_) {

            final ChewieController newChewieController = ChewieController(
              //aspectRatio: videoPlayerControllersList[i].value.aspectRatio,
              aspectRatio: newVideoPlayerController.value.aspectRatio,
              videoPlayerController: videoPlayerControllersList[i],
              //autoPlay: true,
              looping: false,
              showControls: true,

              errorBuilder: (context, errorMessage) {
                return Center(
                  child: Text(
                    //errorMessage,
                    "An error has occured. Please try again.",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15
                    ),
                    textAlign: TextAlign.center
                  ),
                );
              },
            );

            if(!chewieControllersList.contains(newChewieController)) {

              chewieControllersList.add(newChewieController);
            }
            
          });

      } else {
        //initialize the videoPlayerController,
        //its chewieController and store them in the videoPlayerControllers and chewieControllers

        newVideoPlayerController = VideoPlayerController.file(File(videoList[i]))
          ..addListener(() =>  setState(() {}))
          ..setLooping(false);
          //..initialize().then((_) {

          newVideoPlayerController.initialize().then((_) {
            final ChewieController newChewieController = ChewieController(
              //aspectRatio: videoPlayerControllersList[i].value.aspectRatio,
              aspectRatio: newVideoPlayerController.value.aspectRatio,
              videoPlayerController: videoPlayerControllersList[i],
              looping: false,
              showControls: true,

              errorBuilder: (context, errorMessage) {
                return Center(
                  child: Text(
                    //errorMessage,
                    "An error has occured. Please try again.",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15
                    ),
                    textAlign: TextAlign.center
                  ),
                );
              },
            );

            if(!chewieControllersList.contains(newChewieController)) {

              chewieControllersList.add(newChewieController);

            }
          });
      }

      videoPlayerControllersList.add(newVideoPlayerController);

      if(i == (videoList.length - 1)) {
        videoPlayerControllersList[i].play;
      }
    }
  }

  @override
  void dispose() {

    /*dispose the videoControllers and chewieControllers*/
    for(int i = 0; i < videoPlayerControllersList.length; i++) {
      videoPlayerControllersList[i].dispose();

      print("disposed videoPlayerControllersList element: " + i.toString());
    }

    for(int i = 0; i < chewieControllersList.length; i++) {
      chewieControllersList[i].dispose();

      print("disposed chewieControllersList element: " + i.toString());
    }

    //chewieControllersList.forEach((element) => element.dispose());
    
    //chewieController.dispose();
    super.dispose();
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
      body: chewieControllersList.length == videoPlayerControllersList.length ?
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        
        children: [
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                height: double.infinity,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                initialPage: videoIndex,
                onScrolled: (scr) {
                  setState(() {
                    //pause the current video being played if at all anyone is playing
                    //on page scroll
                    videoPlayerControllersList[currentVideoIndex].pause();
                  });
                },
                onPageChanged: (int changedVideoIndex, CarouselPageChangedReason carouselPageChangedReason) {

                  //once the carousel page is changed

                  print("\nCarousel Change Reason: " + carouselPageChangedReason.toString() + "\n");

                  setState(() {

                    int previousVideoIndex = currentVideoIndex;

                    videoPlayerControllersList[previousVideoIndex].seekTo(Duration(seconds: 0/*any second you want*/ )); //set it to the beginning of the video

                    if(changedVideoIndex != previousVideoIndex) {

                      if(changedVideoIndex > previousVideoIndex) {

                        int videoIndexToPass = videoIndex + 1;

                        if(videoIndexToPass > (videoList.length - 1)) {
                          videoIndexToPass = videoList.length - 1;
                        }

                        //videoPlayerControllersList[videoIndexToPass].play();
                        //chewieControllersList[videoIndexToPass].play();

                      } else {

                        int videoIndexToPass = videoIndex - 1;

                        if(videoIndexToPass < 0) {
                          videoIndexToPass = 0;
                        }

                        //videoPlayerControllersList[videoIndexToPass].play();

                      }

                      currentVideoIndex = changedVideoIndex;

                    } else {
                      //chewieController.play;
                      //videoPlayerControllersList[previousVideoIndex].play();
                    }

                  });
                  
                  setState(() {
                    currentVideoIndex = changedVideoIndex;
                  });
                }
              ),
              items: videoList
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
                    child: videoPlayerControllersList[currentVideoIndex].value.isInitialized ?
                      Container(
                        /*decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 5.0
                          ),
                        ),*/
                        child: Chewie(
                          controller: chewieControllersList[currentVideoIndex],
                        )
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                    )
                  )
                ).toList(),
            ),
          )
        ]
      )
      
      :
      Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: CircularProgressIndicator()
        )
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
            onTap: () async {

              String videopath = videoList[currentVideoIndex];

              print("The video path: " + videopath);

              File videoFile = File(videopath); //convert the video string to an video file

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
            //onTap: () => print('SECOND CHILD'),
            onTap: () async {

              List<String> videoPaths = [videoList[currentVideoIndex]];

              await Share.shareFiles(videoPaths);//, text: "Video shared");
            },
            onLongPress: () => print('SECOND CHILD LONG PRESS'),
          ),
        ],
      ),
    );
  }
}