import 'package:best_before_app/components/BarcodeResult.dart';
import 'package:best_before_app/components/ExpiryItem.dart';
import 'package:dropdown_banner/dropdown_banner.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:camera/camera.dart";
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import "package:best_before_app/globals.dart";

class ScanPicture extends StatefulWidget {
  bool disabled = true;

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
  bool barCodeScanned = true;
  String expiryDate = "EMPTY";
  int _ocrCamera = FlutterMobileVision.CAMERA_BACK;

  String barcode = 'Unknown'; //This will hold the returned value from a barcode

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

  Future<void> scanBarcode() async{
    try {

      barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", // This is the line color for scanning part
        "Cancel", //cancel option
        false, //disabling flash as an option
        ScanMode.BARCODE,
      );

      if (!mounted) return;

      setState(() {
        this.barcode = barcode;
      });
    } on PlatformException{
      barcode = 'Failed to get platform version.';
      DropdownBanner.showBanner(
        text: 'Failed to complete scan request',
        color: Colors.red[600],
        textStyle: TextStyle(color: Colors.white),
      );
    }
    String itemName = await barcodeResult(this.barcode);
    confirmBarcode(itemName);

  }

  Future<void> confirmBarcode(String itemName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Product name is $itemName'),
          content: Text('Did we get it right?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                //call expiry scan function
                readExpiry(itemName);
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
                inputProductName();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> inputProductName() async {
    String product;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Product"),
          content: TextField(
            onChanged: (String name) async {
              product = name;
            },
            decoration: InputDecoration(
              hintText: "Enter product name",
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Add"),
              onPressed: () {
                if(product != null && product != "") {
                  Navigator.of(context).pop();
                  readExpiry(product);
                }
              },
            ),
          ],
        );
      },
    );
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
        fit: StackFit.expand,
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
                    onPressed: scanBarcode,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black.withOpacity(0.2),
                      shape: CircleBorder(
                        side: BorderSide(
                          color: Colors.amber,
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

  Future<Null> readExpiry(String productName) async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        flash: false,
        autoFocus: true,
        multiple: true,
        camera: _ocrCamera,
        waitTap: true,
      );
      setState(() {
        expiryDate = texts[0].value;
        print('valueis ${texts}');
        for(OcrText text in texts) {
          print('valueis ${text.value}');
        }
        expiryItems.add(ExpiryItemData(expiryDate: 3, product: productName, quantity: 1));
      });
    } on Exception {
      texts.add( OcrText('Failed to recognize text'));
    }
  }
}
