import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:convert';

typedef void Callback(String itemName, String category, int amount);
typedef void Callback2(String category);

Future<void> confirmBarcode(String itemName, BuildContext context, Callback callback) {
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
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: AlertDialog(
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
                      SizedBox(height:10.0),
                      TextFormField(
                        initialValue: itemName,
                        onChanged: (String name) async {
                          itemName = name;
                        },
                        decoration: InputDecoration(
                          //Placeholder text
                          hintText: "Enter product name",
                          //Background colour = true
                          filled: true,
                          //Background colour
                          fillColor: Colors.grey[300],
                          contentPadding: EdgeInsets.only(left:16.0),
                          //Border when not focused
                          enabledBorder: OutlineInputBorder(
                            //Border colour
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          //Border when focused
                          focusedBorder: OutlineInputBorder(
                            //Border colour
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
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
                              textAlign: TextAlign.center,
                              onChanged: (String name) async {
                                int value = int.tryParse(name);
                                if(value != null) {
                                  amount = value;
                                }
                              },
                              decoration: InputDecoration(
                                //Placeholder text
                                hintText: "X",
                                //Background colour = true
                                filled: true,
                                //Background colour
                                fillColor: Colors.grey[300],
                                contentPadding: EdgeInsets.all(0.0),
                                //Border when not focused
                                enabledBorder: OutlineInputBorder(
                                  //Border colour
                                    borderSide: BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(10.0)),
                                //Border when focused
                                focusedBorder: OutlineInputBorder(
                                  //Border colour
                                  borderSide: BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Category:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            "$category",
                            textAlign: TextAlign.center,
                          ),
                        ],
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
                        style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          elevation: 0,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          )
                        )
                      ),
                      SizedBox(height:15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                              size: 50,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.check_circle_outline,
                              color: Colors.green[400],
                              size: 50,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              //call expiry scan function
                              callback(itemName, category, amount);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
      );
    },
  );
}

void showPicker(BuildContext context, Callback2 callback) {
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

DateTime checkIfExpiry(String data) {
  List<String> strings = data.split(" ");
  String date = "";
  for(int i = 0; i < strings.length; i++) {
    if(strings[i].length <= 4 && strings[i].length >= 2) {
      try {
        if(double.parse(strings[i]) != null) {
          date = strings[i]+"-"+date;
          print("Word length: ${strings[i].length}, the string: ${strings[i]}");
        }
      }catch(e) {
        print("error: $e");
      }
    }
  }
  //date+=01
  if(date != "") {
    date = date.substring(0,date.length-1)+"-01";
  }
  try {
    DateTime dte = DateTime.parse(date);
    print("the date ${DateTime.parse(date)}");
    return dte;
  }catch(e) {
    print(e);
  }
  return null;
}