import 'dart:convert';

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
import 'package:flutter_picker/flutter_picker.dart';

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

  Future<void> confirmBarcode(String itemName) {
    int amount = 1;
    TextEditingController textController = new TextEditingController();
    textController.text = "1";
    String category = "Vegetables";

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Product Details',
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      "Product Name",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      initialValue: itemName,
                      onChanged: (String name) async {
                        itemName = name;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter product name",
                      ),
                    ),
                    SizedBox(height:10.0),
                    Text(
                      "Quantity",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: IconButton(
                            onPressed: () {
                              if(amount > 1) {
                                setState(() {
                                  amount--;
                                  textController.text = amount.toString();
                                });
                              }
                            },
                            icon: Icon(Icons.exposure_minus_1),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: textController,
                            keyboardType: TextInputType.number,
                            onChanged: (String name) async {
                              int value = int.tryParse(name);
                              if(value != null) {
                                amount = value;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Enter product name",
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                amount++;
                                textController.text = amount.toString();
                              });
                            },
                            icon: Icon(Icons.exposure_plus_1),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height:10.0),
                    Text(
                      "Category",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$category",
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showPicker(context, (String cat) {
                          setState(() {
                            category = cat;
                          });
                        });
                      },
                      child: Text("Choose a Category"),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    TextButton.icon(
                      icon: Icon(
                        Icons.check_circle_outline,
                        color: Colors.green[400],
                        size: 50,
                      ),
                      label: Text(""),
                      onPressed: () {
                        Navigator.of(context).pop();
                        //call expiry scan function
                        readExpiry(itemName, category, amount);
                      },
                    ),
                    TextButton.icon(
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                        size: 50,
                      ),
                      label: Text(""),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            );
          }
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

  Future<Null> readExpiry(String productName, String category, int quantity) async {
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
        expiryItems.add(ExpiryItemData(expiryDate: 3, product: productName, quantity: quantity));
      });
    } on Exception {
      texts.add( OcrText('Failed to recognize text'));
    }
  }

  showPicker(BuildContext context, Callback callback) {
    const PickerData2 = '''
[
    [
        "Vegetables",
        "Fruit",
        "Dairy",
        "Sauces",
        "Bread",
        "Meat",
        "Home Cooked meals"
    ]
]
    ''';
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: JsonDecoder().convert(PickerData2),
          isArray: true,
        ),
        hideHeader: true,
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        cancel: TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: Text("Cancel")),
        onConfirm: (Picker picker, List value) {
          callback(picker.getSelectedValues()[0]);
        }
    ).showDialog(context);
  }
}
