import "package:best_before_app/UpdateDatabase.dart";
import 'package:best_before_app/components/BarcodeResult.dart';
import "package:camera/camera.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:google_ml_kit/google_ml_kit.dart';

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

  //The camera controller
  CameraController controller;

  final textDetector = GoogleMlKit.vision.textDetector();
  final barcodeScanner = GoogleMlKit.vision.barcodeScanner();

  CustomPaint customPaint;

  //The int value that will hold value of the current camera
  int selected = 0;
  bool barCodeScanned = false;
  bool scanningBarcode = false;

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
    var controller = CameraController(cameras[selected], ResolutionPreset.medium);
    camera = cameras[selected];
    //Initialise controller
    await controller.initialize();
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
        final Rect boundingBox = barcode.value.boundingBox;
        final String displayValue = barcode.value.displayValue;
        final String rawValue = barcode.value.rawValue;

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
              setState(() {
                scanningBarcode = false;
              });
            });
          }
        }
      }
    });

    // try {
    //   try {
    //     //scans the barcode
    //     barcode = await FlutterBarcodeScanner.scanBarcode(
    //       "#ff6666", // This is the line color for scanning part
    //       "Cancel", //cancel option
    //       false, //disabling flash as an option
    //       ScanMode.BARCODE,
    //     );
    //
    //     if (!mounted) return;
    //     //Sets teh barcode variable
    //     setState(() {
    //       this.barcode = barcode;
    //     });
    //   } on PlatformException {
    //     //Called if scan request does not work
    //     barcode = 'Failed to get platform version.';
    //     DropdownBanner.showBanner(
    //       text: 'Failed to complete scan request',
    //       color: Colors.red[600],
    //       textStyle: TextStyle(color: Colors.white),
    //     );
    //     setState(() {
    //       barCodeScanned = false;
    //     });
    //   }
    //   //Runs this code if barcode gotten
    //   if(barcode != "-1") {
    //     //Gets barcode data
    //     String itemName = await barcodeResult(this.barcode);
    //     //Sets the itemName depending on if data was found
    //     itemName = itemName != "noData" ? itemName : "";
    //     //Asks users to confirm the barcode and the product name etc.
    //     confirmBarcode(itemName, context, (String itemName, String category, int amount, bool canceled) {
    //       if(!canceled) {
    //         //Sets variables if not canceled
    //         setState(() {
    //           //Sets this variable to indicate that the barcode has been scanned
    //           barCodeScanned = true;
    //         });
    //         widget.itemName = itemName;
    //         widget.category = category;
    //         widget.quantity = amount;
    //       }
    //     });
    //   }
    //   //Reinits the camera to make sure the screen isn't black
    //   setupCamera();
    //   scanning = false;
    // }catch(e) {
    //   print(e);
    // }
  }

  @override
  void dispose() {
    //Interface for classes that register with the Widgets layer binding.
    WidgetsBinding.instance.removeObserver(this);
    //Dispose of the controller when necessary
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive && scanning == false) {
      //Dispose of controller when necessary
      await controller?.dispose();
    }//else {
    //   setupCamera();
    // }
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
    if (controller == null) {
      //A Widget for absolute positioning other widgets
      return Align(
        child: Icon(
          Icons.camera_alt,
          size: 60.0,
        ),
      );
    }else {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          //The camera viewfinder
          CameraPreview(controller),
          //if(customPaint != null) customPaint,
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
                  color: scanningBarcode ? Colors.amber[800] : Colors.transparent
                )
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
                Text(
                  //Sets the text based on if expiry date has been scanned yet
                  barCodeScanned ? "Scan Expiry Date" : "Scan Barcode",
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
                          onPressed: () {
                            setState(() {
                              scanningBarcode = true;
                            });

                            //Determines which function to run on click
                            if(!barCodeScanned) {
                              scanBarcode();
                            }else {
                              readExpiry(widget.itemName, widget.category, widget.quantity);
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
  }

  Future<Null> readExpiry(String productName, String category, int quantity) async {
    InputImage inputImage;
    DateTime expiry;
    bool dateGotten;
    controller?.startImageStream((CameraImage cameraImage) async {
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

      controller?.stopImageStream();
      final RecognisedText recognisedText = await textDetector.processImage(inputImage);
      String text = recognisedText.text;
      for (TextBlock block in recognisedText.blocks) {
        final Rect rect = block.rect;
        final List<Offset> cornerPoints = block.cornerPoints;
        final String text = block.text;
        final List<String> languages = block.recognizedLanguages;

        for (TextLine line in block.lines) {
          // Same getters as TextBlock
          if (expiry == null) {
            expiry = checkIfExpiry(line.text);
            if(expiry != null) {
              DateTime now = DateTime.now();
              enterExpiry(context, productName, category, quantity, expiry);
              textDetector.close();
            }
          } else {
            break;
          }
          setState(() {
            scanningBarcode = false;
          });
        }
      }
      scanning = false;
    });
    // //The variables
    // scanning = true;
    // List<OcrText> texts = [];
    // DateTime expiry;
    // try {
    //   //Reads the text available to the camera
    //   texts = await FlutterMobileVision.read(
    //     flash: false,
    //     showText: false,
    //     autoFocus: true,
    //     multiple: true,
    //     camera: _ocrCamera,
    //     waitTap: true,
    //   );
    //   setState(() {
    //     //Loops through text and checks if it is an expiry date
    //     for (OcrText text in texts) {
    //       if (expiry == null) {
    //         expiry = checkIfExpiry(text.value);
    //       } else {
    //         break;
    //       }
    //     }
    //
    //     //Checks if expiry date was found
    //     //if(expiry != null) {
    //       //Calculates the days until expiry
    //       DateTime now = DateTime.now();
    //       enterExpiry(context, productName, category, quantity, expiry);
    //     //Re-initialises the camera
    //     setupCamera();
    //     scanning = false;
    //   });
    // } on Exception {
    //   texts.add(OcrText('Failed to recognize text'));
    // }
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
