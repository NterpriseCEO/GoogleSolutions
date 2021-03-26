import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef void Callback(String itemName, String category, int amount, bool canceled);
typedef void Callback2(String category);

//fireabase init
FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> confirmBarcode(String itemName, BuildContext context, Callback callback) {
  int amount = 1; //Amount of items to add to inventory
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
            //The alert dialog
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
                      //When user types in input
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
                    //Item quantity
                    Text(
                      "Quantity",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //The increment and decrement ui
                    //Used to change the item quantity
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
                    //The category picker
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
                        //Shows the category picker
                        showPicker(context, (String cat) {
                          setState(() {
                            category = cat;
                          });
                        });
                      },
                      child: Text("Choose a Category"),
                      //Styling the yellowy orange button
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
                        //The x and tick button
                        IconButton(
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                            size: 50,
                          ),
                          onPressed: () {
                            callback(itemName, category, amount, true);
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
                            //send data to firebase
                            Navigator.of(context).pop();
                            //call expiry scan function
                            callback(itemName, category, amount, false);
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
        "Misc"
    ]
]
    ''';
  //The category picker
  Picker(
    adapter: PickerDataAdapter<String>(
      pickerdata: JsonDecoder().convert(PickerData2),
      isArray: true,
    ),
    hideHeader: true,
    title: Text("Please Select"),
    selectedTextStyle: TextStyle(color: Colors.blue),
    cancel: TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text("Cancel")
    ),
    onConfirm: (Picker picker, List value) {
      callback(picker.getSelectedValues()[0]);
    }
  ).showDialog(context);
}

DateTime checkIfExpiry(String data) {
  //Splits the string by line
  LineSplitter ls = new LineSplitter();
  List<String> strings = ls.convert(data);
  data = "";
  //Creates a single line string
  for(String str in strings) {
    data+=str+" ";
  }
  int length = 0;
  //splits the string at each space
  strings = data.split(" ");
  String date = "";
  for(int i = 0; i < strings.length; i++) {
    //Checks if string is 2 characters or 4 characters long
    if(strings[i].length <= 4 && strings[i].length >= 2) {
      length++;
      //check if both parts of the expiry date have been gotten already
      if(length != 3) {
        //Tries parsing the string to a number
        if(int.tryParse(strings[i]) != null) {
          date = strings[i]+"-"+date;
          print("Word length: ${strings[i].length}, the string: ${strings[i]}");
        }
      }
    }
  }
  //date+=01
  //Changes date to proper format
  if(date != "") {
    date = date.substring(0,date.length-1)+"-01";
  }
  //Parses the date
  try {
    DateTime dte = DateTime.parse(date);
    print("the date ${DateTime.parse(date)}");
    return dte;
  }catch(e) {
    print(e);
  }
  //Return null if no date found
  return null;
}