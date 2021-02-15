import "package:flutter/material.dart";
import "package:camera/camera.dart";

class ScanPicture extends StatefulWidget {
  @override
  _ScanPictureState createState() => _ScanPictureState();
}

class _ScanPictureState extends State<ScanPicture> with WidgetsBindingObserver {
  //The cameras
  List<CameraDescription> cameras;
  //The camera controller
  CameraController controller;
  //The int value that will hold value of the current camera
  int selected = 0;

  //The camera setup function
  Future<void> setupCamera() async {
    //Waits to until the cameras are available
    cameras = await availableCameras();
    //Select camera and assign it to the camera controller variable
    var _controller = await selectCamera();
    setState(() => controller = _controller);
  }
  selectCamera() async {
    //Assign camera to a controller and set the Resolution preset to high
    var controller = CameraController(cameras[selected], ResolutionPreset.high);
    //Initialise controller
    await controller.initialize();
    return controller;
  }

  @override
  void dispose() {
    //Interface for classes that register with the Widgets layer binding.
    WidgetsBinding.instance.addObserver(this);
    //Dispose of the controller when necessary
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(controller == null || !controller.value.isInitialized) {
      return;
    }

    if(state == AppLifecycleState.inactive) {
      //Dispose of controller when necessary
      controller?.dispose();
    }else if(state == AppLifecycleState.resumed) {
      //Set up camera when App lifecycle state resumed
      setupCamera();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Set up the camera
    setupCamera();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    if(controller != null) {
      //A Widget for absolute positioning other widgets
      return Stack(
        children: <Widget>[
          //The camera viewfinder
          CameraPreview(controller),
          //The container to hold the take picure button
          Container(
            margin: EdgeInsets.all(12.0),
            //Set it to the full width of the app
            width: MediaQuery.of(context).size.width,
            //A column to vertical align the button
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //A constrained box to set the button to 1/4 the width of the app
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                    width:  MediaQuery.of(context).size.width/4,
                    height:  MediaQuery.of(context).size.width/4,
                  ),
                  //The button with a spherical border
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
