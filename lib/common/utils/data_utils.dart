import 'package:baemin/common/const/data.dart';

class DataUtils{
  static pathToUrl(String value){   //무조건 static이어야만 적용이 된다.
    return 'http://$ip$value';
  }
}