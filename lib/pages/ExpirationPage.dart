import "package:flutter/material.dart";
import "package:best_before_app/pages/components/ExpiryList.dart";

class ExpirationPage extends StatefulWidget {
  @override
  _ExpirationPageState createState() => _ExpirationPageState();
}

class _ExpirationPageState extends State<ExpirationPage> {
  TextEditingController _controller;
  String search;


  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: Column(
        children: <Widget>[
          //The title of the page
          Expanded(
            flex: 1,
            child: Text(
              "Expiration",
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              //The search field
              child: TextField(
                controller: _controller,
                //Change the search variable when typing
                onChanged: (String val) async {
                  setState(() {
                    search = val;
                  });
                },
                //The input styling
                decoration: InputDecoration(
                  //Placeholder text
                  hintText: "Search",
                  //The magnifying glass icon
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  //The clear search icon
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      //Clear search on click
                      setState(() {
                        search = "";
                      });
                    },
                  ),
                  //Background colour = true
                  filled: true,
                  //Background colour
                  fillColor: Colors.grey[300],
                  contentPadding: EdgeInsets.all(0.0),
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
            ),
          ),
          //The list of expirable items
          Expanded(
            flex: 7,
            child: Container(
              //Width of page
              width: MediaQuery.of(context).size.width,
              child: ExpiryList(search: search),
            ),
          ),
        ],
      ),
    );
  }
}
