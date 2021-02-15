import "package:flutter/material.dart";
import "package:camera/camera.dart";

class ScanPicture extends StatefulWidget {
  @override
  _ScanPictureState createState() => _ScanPictureState();
}

class _ScanPictureState extends State<ScanPicture> with WidgetsBindingObserver {
  List<CameraDescription> cameras;
  CameraController controller;
  int selected = 0;

  Future<void> setupCamera() async {
    cameras = await availableCameras();
    var _controller = await selectCamera();
    setState(() => controller = _controller);
  }
  selectCamera() async {
    var controller = CameraController(cameras[selected], ResolutionPreset.high);
    await controller.initialize();
    return controller;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(controller == null || !controller.value.isInitialized) {
      return;
    }
    if(state == AppLifecycleState.inactive) {
      controller?.dispose();
    }else if(state == AppLifecycleState.resumed) {
      setupCamera();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupCamera();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    if(controller != null) {
      return Stack(
        children: <Widget>[
          CameraPreview(controller),
          Container(
            margin: EdgeInsets.all(12.0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                    width:  MediaQuery.of(context).size.width/4,
                    height:  MediaQuery.of(context).size.width/4,
                  ),
                  child: TextButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber[600].withOpacity(0.8),
                      shape: CircleBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width:5.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }else {
      return Text("loading...");
    }
  }
}
