import 'package:baemin/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  // 1) 요청을 보낼때
  // 요청이 보내질때마다
  // 만약에 요청의 Header에 accessToken: trun라는 값이 있다면
  // 실제 storage에서 토큰을 가져와 authorization: bearer $token으로 헤더를 변경한다.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      //헤더 삭제하고
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      //헤더 삭제하고
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }
    super.onRequest(options, handler);
  }
// 2) 응받을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }
// #) 에러가 났을때
@override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을때(status code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급되면
    // 다시 새로운 토큰을 요청한다.
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if(refreshToken == null){
      return handler.reject(err); //에러를 돌려준다.
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == 'auth/token';
    if(isStatus401 && isPathRefresh){
      final dio = Dio();

      try{
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          )
        );

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        //토큰 변경하기
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });
        
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        //요청 재전송송
       final response = await dio.fetch(options);
       return handler.resolve(response);

      }on DioError catch(e){
        return handler.reject(e); //에러를 돌려준다.
      }
    }
    return super.onError(err, handler);
  }
}
