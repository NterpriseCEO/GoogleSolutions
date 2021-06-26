import "package:best_before_app/UpdateDatabase.dart";
import 'package:best_before_app/components/BarcodeResult.dart';
import "package:camera/camera.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:toast/toast.dart';

import 'components/EditScan.dart';

typedef void Callback(String category);

bool scanning = false;

class ScanPicture extends StatefulWidget {
  String itemName;
  String category;
  int quantity;

  @override
  _ScanPictureState createState() => _ScanPictureState();
}

class _ScanPictureState extends State<ScanPicture> with WidgetsBindingObserver {
  //The cameras
  List<CameraDescription> cameras;
  CameraDescription camera;
  Future<void> _initializeControllerFuture;

  //The camera controller
  CameraController controller;

  final textDetector = GoogleMlKit.vision.textDetector();
  final barcodeScanner = GoogleMlKit.vision.barcodeScanner();

  //The int value that will hold value of the current camera
  bool barCodeScanned = false;
  bool scanningBarcode = false;
  bool isLooping = false;

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
    var controller = CameraController(cameras[0], ResolutionPreset.medium);
    camera = cameras[0];
    //Initialise controller
    _initializeControllerFuture = controller.initialize();
    return controller;
  }

  Future<void> scanBarcode() async {
    scanning = true;
    widget.itemName = "";
    widget.category = "";
    widget.quantity = 0;

    InputImage inputImage;
    bool hasScanned = false;
    int scannerCounter = 0;

    controller?.startImageStream((CameraImage cameraImage) async {
      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in cameraImage.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes
          .done()
          .buffer
          .asUint8List();

      final Size imageSize =
      Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

      final imageRotation = InputImageRotationMethods.fromRawValue(
          camera.sensorOrientation) ?? InputImageRotation.Rotation_0deg;

      final inputImageFormat = InputImageFormatMethods.fromRawValue(
          cameraImage.format.raw) ?? InputImageFormat.NV21;

      final planeData = cameraImage.planes.map((Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      }).toList();

      final inputImageData = InputImageData(
        size: imageSize,
        imageRotation: imageRotation,
        inputImageFormat: inputImageFormat,
        planeData: planeData,
      );

      inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

      final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);

      scannerCounter++;

      if(scannerCounter == 100000000) {
        controller?.stopImageStream();
      }

      for (Barcode barcode in barcodes) {
        final BarcodeType type = barcode.type;

        // See API reference for complete list of supported types
        if(type == BarcodeType.product && !hasScanned) {
          hasScanned = true;
          controller?.stopImageStream();
          this.barcode = barcode.value.displayValue;
          String itemName = await barcodeResult(this.barcode);
          //Sets the itemName depending on if data was found
          itemName = itemName != "noData" ? itemName : "";
          if(itemName != "") {
            confirmBarcode(itemName, context, (String itemName, String category, int amount, bool canceled) {
              if(!canceled) {
                //Sets variables if not canceled
                setState(() {
                  //Sets this variable to indicate that the barcode has been scanned
                  barCodeScanned = true;
                });
                widget.itemName = itemName;
                widget.category = category;
                widget.quantity = amount;
              }
              Toast.show("Barcode Successfully Scanned", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
              readExpiry();
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    //Interface for classes that register with the Widgets layer binding.
    WidgetsBinding.instance.removeObserver(this);
    //Dispose of the controller when necessary
    try {
      controller.stopImageStream();
    }catch(e) {
      print(e);
    }
    controller?.dispose();
    super.dispose();
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
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        //The camera viewfinder
        FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(controller);
            }else {
              return Align(
                child: Icon(
                  Icons.camera_alt,
                  size: 60.0,
                ),
              );
            }
          }
        ),
        //The container to hold the take picure button
        Positioned(
          left: MediaQuery.of(context).size.width*0.125,
          top: MediaQuery.of(context).size.height*0.375,
          width: MediaQuery.of(context).size.width*0.75,
          height: MediaQuery.of(context).size.height/8,
          child: Container(
            decoration: BoxDecoration(
              color: scanningBarcode ? Colors.black.withOpacity(0.2) : Colors.transparent,
              border: Border.all(
                width: 3,
                color: scanningBarcode ? Colors.amber[800] : Colors.transparent,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(12.0),
          //Set it to the full width of the app
          width: MediaQuery.of(context).size.width,
          //A column to vertical align the button
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //A constrained box to set the button to 1/4 the width of the app
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Text(
                  //Sets the text based on if expiry date has been scanned yet
                  barCodeScanned ? "Scan Expiry Date" : "Scan Barcode",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 25.0,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: SizedBox(width:20.0)
                  ),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        width: MediaQuery.of(context).size.width / 4,
                        height: MediaQuery.of(context).size.width / 4,
                      ),
                      //The button with a spherical border
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            scanningBarcode = true;
                          });

                          //Determines which function to run on click
                          if(!barCodeScanned) {
                            await scanBarcode();
                          }
                        },
                        //The button style
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
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.keyboard),
                      iconSize: 40.0,
                      color: Colors.white,
                      onPressed: () {
                        //Determines which popup to show on button click
                        if(!barCodeScanned) {
                          confirmBarcode("", context, (String itemName, String category, int amount, bool canceled) {
                            if(!canceled) {
                              setState(() {
                                barCodeScanned = true;
                              });
                              widget.itemName = itemName;
                              widget.category = category;
                              widget.quantity = amount;

                              enterExpiry(context, widget.itemName, widget.category, widget.quantity, null);
                            }
                          });
                        }else {
                          scanningBarcode = false;
                          controller?.stopImageStream();
                          enterExpiry(context, widget.itemName, widget.category, widget.quantity, null);
                        }
                      }
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<Null> readExpiry() async {
    InputImage inputImage;
    DateTime expiry;
    int counter = 0;
    controller?.startImageStream((CameraImage cameraImage) async {
      if(counter < 20) {
        counter++;
      }else {
        counter = 0;
        if(!isLooping) {
          isLooping = true;
          final WriteBuffer allBytes = WriteBuffer();
          for (Plane plane in cameraImage.planes) {
            allBytes.putUint8List(plane.bytes);
          }
          final bytes = allBytes.done().buffer.asUint8List();

          final Size imageSize =
          Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

          final imageRotation = InputImageRotationMethods.fromRawValue(camera.sensorOrientation) ?? InputImageRotation.Rotation_0deg;

          final inputImageFormat = InputImageFormatMethods.fromRawValue(cameraImage.format.raw) ?? InputImageFormat.NV21;

          final planeData = cameraImage.planes.map((Plane plane) {
            return InputImagePlaneMetadata(
              bytesPerRow: plane.bytesPerRow,
              height: plane.height,
              width: plane.width,
            );
          }).toList();

          final inputImageData = InputImageData(
            size: imageSize,
            imageRotation: imageRotation,
            inputImageFormat: inputImageFormat,
            planeData: planeData,
          );

          inputImage =
              InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

          final RecognisedText recognisedText = await textDetector.processImage(inputImage);
          for (TextBlock block in recognisedText.blocks) {
            if(scanningBarcode) {
              for (TextLine line in block.lines) {
                // Same getters as TextBlock
                if (expiry == null) {
                  expiry = checkIfExpiry(line.text);
                  if(expiry != null) {
                    enterExpiry(context, widget.itemName, widget.category, widget.quantity, expiry);
                    textDetector.close();
                    controller?.stopImageStream();

                    setState(() {
                      scanningBarcode = false;
                    });
                  }
                } else {
                  break;
                }
              }
            }
          }
          scanning = false;
          isLooping = false;
        }
      }
    });
  }

  void enterExpiry(BuildContext context, String productName, String category, int quantity, DateTime date) async {
    date = date == null ? DateTime.now() : date;
    //Shows the date picker
    DateTime expiry = await showDatePicker(
      context: context,
      initialDate:date,
      firstDate:DateTime.now().subtract(Duration(days: 10)),
      lastDate: DateTime(2100)
    );
    //Checks if the expiry date picker was not canceled
    if(expiry != null) {
      //Adds the product to the database
      addItemToDB(productName, category, quantity, expiry.toString());
      DateTime now = DateTime.now();
      int daysTillExpiry = expiry.difference(DateTime(now.year, now.month, now.day)).inDays;
      print("this is the amount of days till it expires: $daysTillExpiry, this is the expiry date: $expiry");
      //Creates a notification

      //Shows message saying that item was added to inventory
      final snackBar = SnackBar(
        content: Text('$quantity $productName have been added to your inventory'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    setState(() {
      barCodeScanned = false;
    });
  }
}
