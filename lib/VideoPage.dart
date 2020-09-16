import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideo;
  double _lowerValue = 50;
  double _upperValue = 180;
  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.asset("assets/files/video.mp4")
          ..addListener(() {});
    _initializeVideo = _videoPlayerController.initialize().then((value) {
      setState(() {
        _videoPlayerController.play();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _initializeVideo,
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio / 2,
                      child: VideoPlayer(_videoPlayerController),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: getSlider(),
                  ),
                ],
              );
            }
          }),
    );
  }

  Container getSlider() {
    double mval = _videoPlayerController.value as double;
    print("cont val: $mval");
    return Container(
      color: Colors.amber,
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: FlutterSlider(
        handlerWidth: 20,
        hatchMark: FlutterSliderHatchMark(
          linesDistanceFromTrackBar: 5,
          displayLines: true,
          linesAlignment: FlutterSliderHatchMarkAlignment.right,
          density: 0.5,
          disabled: true,
          labels: [
            FlutterSliderHatchMarkLabel(percent: 0, label: Icon(Icons.add)),
            FlutterSliderHatchMarkLabel(percent: 10, label: Icon(Icons.add)),
            FlutterSliderHatchMarkLabel(percent: 20, label: Icon(Icons.add)),
          ],
        ),
        jump: true,
        trackBar: FlutterSliderTrackBar(),
        handler: FlutterSliderHandler(
          decoration: BoxDecoration(),
          child: Container(
            decoration: new BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
        values: [mval],
        min: 0,
        max: 100,
        touchSize: 15,
        rangeSlider: false,
        step: FlutterSliderStep(step: 10),
        onDragging: (handlerIndex, lowerValue, upperValue) {
//          lowerValue = _videoPlayerController.value.;
          setState(() {
            mval = lowerValue as double;
          });
          print("lo val : $lowerValue");
//          print("up val : $upperValue ... _up: $_upperValue");
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoPlayerController.dispose();
    super.dispose();
  }
}
