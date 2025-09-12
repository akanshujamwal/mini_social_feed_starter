import 'package:dio/dio.dart';
import 'package:mini_social_feed_starter/core/network/dio_client.dart';
import 'package:mini_social_feed_starter/features/feed/domain/entities/user.dart';
class UserRemoteDataSource {
  final Dio _dio = DioClient.dio;

  Future<User> fetchUser(int userId) async {
    final res = await _dio.get('/users/$userId');
    final u = res.data as Map<String, dynamic>;
    // CORS/Android friendly avatar using picsum
    return User(
      id: u['id'] as int,
      name: u['name'] as String,
      username: u['username'] as String,
      email: u['email'] as String,
      website: (u['website'] ?? '').toString(),
      avatarUrl: 'https://picsum.photos/seed/avatar-${u['id']}/200/200',
    );
  }
}
