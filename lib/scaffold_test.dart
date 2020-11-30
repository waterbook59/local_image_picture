import 'package:flutter/material.dart';
import  'package:keyboard_actions/keyboard_actions.dart';



class ScaffoldTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Keyboard Actions Sample"),
      ),
      body: Content(),
    );
  }
}



class Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final FocusNode _nodeText1 = FocusNode();


  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText1,
        ),
//        KeyboardActionsItem(focusNode: _nodeText2, toolbarButtons: [
//              (node) {
//            return GestureDetector(
//              onTap: () => node.unfocus(),
//              child: Padding(
//                padding: EdgeInsets.all(8.0),
//                child: Icon(Icons.close),
//              ),
//            );
//          }
//        ]),
//        KeyboardActionsItem(
//          focusNode: _nodeText3,
//          onTapAction: () {
//            showDialog(
//                context: context,
//                builder: (context) {
//                  return AlertDialog(
//                    content: Text("Custom Action"),
//                    actions: <Widget>[
//                      FlatButton(
//                        child: Text("OK"),
//                        onPressed: () => Navigator.of(context).pop(),
//                      )
//                    ],
//                  );
//                });
//          },
//        ),
//        KeyboardActionsItem(
//          focusNode: _nodeText4,
//          displayCloseWidget: false,
//        ),
//        KeyboardActionsItem(
//          focusNode: _nodeText5,
//          toolbarButtons: [
//            //button 1
//                (node) {
//              return GestureDetector(
//                onTap: () => node.unfocus(),
//                child: Container(
//                  color: Colors.white,
//                  padding: EdgeInsets.all(8.0),
//                  child: Text(
//                    "CLOSE",
//                    style: TextStyle(color: Colors.black),
//                  ),
//                ),
//              );
//            },
//            //button 2
//                (node) {
//              return GestureDetector(
//                onTap: () => node.unfocus(),
//                child: Container(
//                  color: Colors.black,
//                  padding: EdgeInsets.all(8.0),
//                  child: Text(
//                    "DONE",
//                    style: TextStyle(color: Colors.white),
//                  ),
//                ),
//              );
//            }
//          ],
//        ),
//        KeyboardActionsItem(
//          focusNode: _nodeText6,
//          footerBuilder: (_) => PreferredSize(
//              child: SizedBox(
//                  height: 40,
//                  child: Center(
//                    child: Text('Custom Footer'),
//                  )),
//              preferredSize: Size.fromHeight(40)),
//        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: _buildConfig(context),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                focusNode: _nodeText1,
                decoration: InputDecoration(
                  hintText: "Input Number",
                ),
              ),
//              TextField(
//                keyboardType: TextInputType.text,
//                focusNode: _nodeText2,
//                decoration: InputDecoration(
//                  hintText: "Input Text with Custom Done Button",
//                ),
//              ),
//              TextField(
//                keyboardType: TextInputType.number,
//                focusNode: _nodeText3,
//                decoration: InputDecoration(
//                  hintText: "Input Number with Custom Action",
//                ),
//              ),
//              TextField(
//                keyboardType: TextInputType.text,
//                focusNode: _nodeText4,
//                decoration: InputDecoration(
//                  hintText: "Input Text without Done button",
//                ),
//              ),
//              TextField(
//                keyboardType: TextInputType.number,
//                focusNode: _nodeText5,
//                decoration: InputDecoration(
//                  hintText: "Input Number with Toolbar Buttons",
//                ),
//              ),
//              TextField(
//                keyboardType: TextInputType.number,
//                focusNode: _nodeText6,
//                decoration: InputDecoration(
//                  hintText: "Input Number with Custom Footer",
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}


