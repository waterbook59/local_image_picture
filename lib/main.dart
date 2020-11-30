import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localimagepictureapp/utils/constants.dart';
import 'package:localimagepictureapp/file_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import  'package:keyboard_actions/keyboard_actions.dart';
import 'package:localimagepictureapp/scaffold_test.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
//      ScaffoldTest(),
      MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  File _image;
  final picker = ImagePicker();
  File savedLocalFile;
  File baseNameLocalFile;
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _localFileKey = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();
  final FocusNode _nodeText6 = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText1,
          toolbarButtons: [
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('完了'),
                ),
              );
            }
          ]
        ),
        KeyboardActionsItem(focusNode: _nodeText2, toolbarButtons: [
              (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close),
              ),
            );
          }
        ]),
//        KeyboardActionsItem(
//          focusNode: _nodeText3,
//          onTapAction: () {
//            ShowDialog(
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
        KeyboardActionsItem(
          focusNode: _nodeText4,
          displayActionBar: false,
        ),
        KeyboardActionsItem(
          focusNode: _nodeText5,
          toolbarButtons: [
            //button 1
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "CLOSE",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
            //button 2
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "DONE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _nodeText6,
          footerBuilder: (_) => PreferredSize(
              child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('Custom Footer'),
                  )),
              preferredSize: Size.fromHeight(40)),
        ),
      ],
    );
  }


  ///保存条件を渡しておく(画像読取時に振り分けるため)
  RecordStatus recordStatus = RecordStatus.camera;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('画像をローカルで管理'),
      ),
      body:  KeyboardActions(
      config: _buildConfig(context),
      child:

      SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                'カメラ起動/ギャラリー起動',
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    child: Icon(Icons.camera_enhance),
                    onPressed: () => getImageFromCamera(context),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    child: Icon(Icons.folder),
                    onPressed: () => getImageFromGallery(context),
                  ),
                ],
              ),

              ///カメラ画像は撮影時用の一時的フォルダパスに保存されている(たぶんキャッシュ保存の状態)
              ///保存時・読み取り時にenumで条件設定

              SizedBox(height: 15),

              ///撮った写真(ギャラリーの画像も？)キャッシュの画像表示
              Center(
                child: Container(
                  width: 300,
                  child: _image == null
                      ? Center(child: Text('No image selected.'))
                      : Image.file(_image),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                '登録名',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(controller: _textEditingController),
              ),
              SizedBox(
                height: 10,
              ),

              ///引数にはカメラ撮影時にreturnされるFileオブジェクトを持たせて、その画像をドキュメントへ保存し直す。
              RaisedButton(
                child: Text('画像を保存'),
                color: Colors.orangeAccent,
                onPressed: () => saveLocalImage(
                    context, _image, recordStatus, _textEditingController),
              ),
              SizedBox(
                height: 30,
              ),
          ///keyboard_actionsのテスト
//              KeyboardActions(
//                config: _buildConfig(context),
//                child:
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
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
                        TextField(
                          keyboardType: TextInputType.text,
                          focusNode: _nodeText2,
                          decoration: InputDecoration(
                            hintText: "Input Text with Custom Done Button",
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          focusNode: _nodeText3,
                          decoration: InputDecoration(
                            hintText: "Input Number with Custom Action",
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          focusNode: _nodeText4,
                          decoration: InputDecoration(
                            hintText: "Input Text without Done button",
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          focusNode: _nodeText5,
                          decoration: InputDecoration(
                            hintText: "Input Number with Toolbar Buttons",
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          focusNode: _nodeText6,
                          decoration: InputDecoration(
                            hintText: "Input Number with Custom Footer",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
//              ),

              SizedBox(
                height: 50,
              ),
              ///DBから呼び出し
              const Text(
                '呼び出すキーを入力',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(controller: _localFileKey),
              ),
              ///ドキュメント画像取得
              RaisedButton(
                child: Text('画像を取得'),
                color: Colors.lightBlue,
                onPressed: () => getLocalImage(context, recordStatus,_localFileKey),
              ),

              ///imageFile.writeAsBytes使う方法でのドキュメントディレクトリの画像表示
              (savedLocalFile == null)
                  ? Icon(Icons.no_sim)
                  : Image.memory(
                      savedLocalFile.readAsBytesSync(),
                      height: 100.0,
                      width: 100.0,
                    ),
              SizedBox(
                height: 10,
              ),

              ///image.copy=>DBへパス保存の方法でのドキュメントディレクトリの画像表示
              (baseNameLocalFile == null)
                  ? Icon(Icons.no_sim)
                  : Image.file(
                      baseNameLocalFile,
                      height: 150,
                      width: 150,
                    ),
            ],
          ),
        ),
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ///カメラ起動しキャッシュへ画像保存
  Future<void> getImageFromCamera(BuildContext context) async {
    print('カメラ起動！');
//    final imagePicker= ImagePicker();
    final cameraImageFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      recordStatus = RecordStatus.camera;
      _image = File(cameraImageFile.path);
    });
  }

  ///ギャラリーから選択しキャッシュへ画像保存
  Future<void> getImageFromGallery(BuildContext context) async {
    final galleryPickedFile =
        await picker.getImage(source: ImageSource.gallery);

    setState(() {
      recordStatus = RecordStatus.gallery;
      _image = File(galleryPickedFile.path);
    });
  }

  ///キャッシュの画像をローカルドキュメント保存
  //todo 保存ボタン押した時に_imageがnullの時のバリデーション
  Future<void> saveLocalImage(
      BuildContext context,
      File _image,
      RecordStatus recordStatus,
      TextEditingController _textEditingController) async {
    ///imageFile.writeAsBytes使う方法(一つしか保存できない??)
//    var saveFile = await FileController.saveLocalImage(_image);
//    setState(() {
//      savedLocalFile =saveFile;
//    });
    ///image.copy=>DBへパス保存の方法
    final prefs = await SharedPreferences.getInstance();
    await FileController.saveOriginalNameImage(_image,_textEditingController);
    print('画像をローカルへコピーし、パスをDBへ保存');
  }

  ///SharedPreferencesに保存したパスを読み取り
  Future<void> getLocalImage(
      BuildContext context, RecordStatus recordStatus, TextEditingController _localFileKey) async {
    //enumで記録形式を指定
    print('ドキュメントディレクトリから画像を取得');

    final prefs = await SharedPreferences.getInstance();
    baseNameLocalFile = File(prefs.getString( _localFileKey.text as String));
    setState(() {});
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
}
