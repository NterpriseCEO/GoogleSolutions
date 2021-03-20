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
import "package:best_before_app/notifications/LocalNotifications.dart";
import 'components/EditScan.dart';


typedef void Callback(String category);

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
  bool barCodeScanned = false;
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

  Future<void> scanBarcode() async {
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
    } on PlatformException {
      barcode = 'Failed to get platform version.';
      DropdownBanner.showBanner(
        text: 'Failed to complete scan request',
        color: Colors.red[600],
        textStyle: TextStyle(color: Colors.white),
      );
      setState(() {
        barCodeScanned = false;
      });
    }
    String itemName = await barcodeResult(this.barcode);
    confirmBarcode(itemName, context,
        (String itemName, String category, int amount) {
      setState(() {
        barCodeScanned = true;
      });
      readExpiry(itemName, category, amount);
    });
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
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      //Dispose of controller when necessary
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
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
    if (controller != null) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //A constrained box to set the button to 1/4 the width of the app
                Text(
                  "Scan Barcode Then Scan Expiry Date",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.white,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                ),
                Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.width / 4,
                    ),
                    //The button with a spherical border
                    child: TextButton(
                      onPressed: scanBarcode,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black.withOpacity(0.2),
                        shape: CircleBorder(
                          side: BorderSide(
                            color: Colors.amber,
                            width: 5.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.keyboard),
                      onPressed: () {
                        confirmBarcode("", context,
                            (String itemName, String category, int amount) {
                          setState(() {
                            barCodeScanned = true;
                          });
                          readExpiry(itemName, category, amount);
                        });
                      })
                ]),
              ],
            ),
          ),
        ],
      );
    } else {
      return Align(
        child: Icon(
          Icons.camera_alt,
          size: 60.0,
        ),
      );
    }
  }

  Future<Null> readExpiry(
      String productName, String category, int quantity) async {
    List<OcrText> texts = [];
    DateTime expiry;
    try {
      texts = await FlutterMobileVision.read(
        flash: false,
        showText: false,
        autoFocus: true,
        multiple: true,
        camera: _ocrCamera,
        waitTap: true,
      );
      setState(() {
        expiryDate = texts[0].value;
        for (OcrText text in texts) {
          if (expiry == null) {
            expiry = checkIfExpiry(text.value);
          } else {
            break;
          }
        }

        int daysTillExpiry = expiry.difference(DateTime.now()).inDays;
        expiryItems.add(ExpiryItemData(
            expiryDate: expiry,
            product: productName,
            quantity: quantity,
            daysTillExpiry: daysTillExpiry,
            category: category));
        notification(productName, quantity, daysTillExpiry);

        setState(() {
          barCodeScanned = false;
        });

        final snackBar = SnackBar(
          content:
              Text('$quantity $productName have been added to your inventory'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } on Exception {
      texts.add(OcrText('Failed to recognize text'));
    }
  }
}
