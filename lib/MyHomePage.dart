import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_text_demo/VideoInfo.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VideoPlayerController videoPlayerController;
  Future<void> initializeVideoPlayer;
  bool _isPlaying = false;
  List<VideoInfo> mList = [];
  String mText = "";
  bool isTextVisible = false;
  VideoInfo mInfo = VideoInfo();

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.asset("assets/files/video.mp4");
    /*..addListener(() {
            final bool isPlaying = videoPlayerController.value.isPlaying;
          });*/
    initializeVideoPlayer = videoPlayerController.initialize();
    /*.then((_) {
      print("initialization done");
      videoPlayerController.play();
      //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });*/
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      body: FutureBuilder(
          future: initializeVideoPlayer,
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.done) {
              return Center(
                child: Transform.scale(
                  scale: videoPlayerController.value.aspectRatio / deviceRatio,
                  child: AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    child: Stack(children: [
                      VideoPlayer(videoPlayerController),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VideoProgressIndicator(
                          videoPlayerController,
                          allowScrubbing: true,
                          padding: const EdgeInsets.all(30),
                          colors:
                              VideoProgressColors(playedColor: Colors.amber),
                        ),
                      ),
                      Visibility(
                        visible: isTextVisible,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: 20,
                              width: 200,
                              color: Colors.red,
                              child: Text(
                                "$mText",
                                style: TextStyle(
                                    backgroundColor: Colors.orange,
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              if (videoPlayerController.value.isPlaying) {
                                videoPlayerController.pause();
                                addTextDialog(context);
                              } else {
                                videoPlayerController.play();
                                videoPlayerController.setLooping(true);
                              }
                            });
                          },
                          child: Icon(videoPlayerController.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow),
                        ),
                      ),
                    ]),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  void addTextDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Your Tag"),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  mText = value;
                  isTextVisible = true;
                });
              },
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  mInfo = VideoInfo();
                  mInfo.mText = mText;
                  mInfo.mtime = (videoPlayerController.value.position)
                      .inSeconds
                      .toString();
                  mList.add(mInfo);
                  for (int i = 0; i < mList.length; i++) {
                    print("mTime ${mList[i].mtime}");
                    print("mText : ${mList[i].mText}");
                  }
                  Navigator.of(context).pop();
                },
                child: Text("SAVE"),
              ),
            ],
          );
        });
  }
}
/*Center(
      child: Transform.scale(
        scale: videoPlayerController.value.aspectRatio / deviceRatio,
        child: AspectRatio(
          aspectRatio: videoPlayerController.value.aspectRatio,
          child: Stack(children: [
            VideoPlayer(videoPlayerController),
            Align(
              alignment: Alignment.bottomCenter,
              child: VideoProgressIndicator(
                videoPlayerController,
                allowScrubbing: true,
                padding: const EdgeInsets.all(30),
                colors: VideoProgressColors(playedColor: Colors.amber),
              ),
            )
          ]),
        ),
      ),
    );*/
