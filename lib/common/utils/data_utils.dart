import 'dart:convert';

import 'package:baemin/common/const/data.dart';

class DataUtils{
  static String pathToUrl(String value){   //무조건 static이어야만 적용이 된다.
    return 'http://$ip$value';
  }

  static List<String> listPathsToUrls(List paths){
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain){
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String edcoded = stringToBase64.encode(plain);

    return edcoded;
  }
}