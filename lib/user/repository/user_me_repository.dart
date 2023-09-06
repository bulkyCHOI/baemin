import 'package:baemin/common/const/data.dart';
import 'package:baemin/common/dio/dio.dart';
import 'package:baemin/user/model/user_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';
import 'package:riverpod/riverpod.dart';

part 'user_me_repository.g.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return UserMeRepository(dio, baseUrl: 'http://$ip/user/me');
  },
);

// httpL//$ip/user/me
@RestApi()
abstract class UserMeRepository {
  factory UserMeRepository(Dio dio, {String baseUrl}) = _UserMeRepository;

  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> getMe();
}
