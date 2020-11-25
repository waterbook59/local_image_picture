import 'dart:async';
import 'dart:io'; // 追加
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';//basename使うために追加
import 'package:shared_preferences/shared_preferences.dart';


class FileController {
  // ドキュメントのパスを取得
  static Future get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // 画像をドキュメントへ保存する。
  // 引数にはカメラ撮影時にreturnされるFileオブジェクトを持たせる。
  static Future saveLocalImage(File image) async {
    final path = await localPath;
    final imagePath = '$path/image.png';
    File imageFile = File(imagePath);
    // カメラで撮影した画像は撮影時用の一時的フォルダパスに保存されるため、
    // その画像をドキュメントへ保存し直す。
    var savedFile = await imageFile.writeAsBytes(await image.readAsBytes());
    // もしくは
    // var savedFile = await image.copy(imagePath);
    // でもOK

    return savedFile;
  }

  static Future<void> saveOriginalNameImage(File image) async {
    final path = await localPath; //directory.path
    ///file名(image.png)のところは、var fileName =basename(file.path)として、末尾だけを使ってファイル名付けられる
    ///import 'package:path/path.dart';必須
    ///例：file = File("/dir1/dir2/file.ext")=>basename(file)=>file.extだけ抽出できる
    ///File imageFile = await image.copy($path/$fileName);としても良いかも
    ///参照：https://python5.com/q/obnkujjk
    ///参照：https://stackoverflow.com/questions/50439949/flutter-get-the-filename-of-a-file
    final String fileName = basename(image.path);
    final String imagePath = '$path/$fileName';
    final File localImage = await image.copy(imagePath);
    /// localImageをlocalImage.pathとしてDBにString保存(今回はsharedPreferences)
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('test_image', localImage.path);

  }


}