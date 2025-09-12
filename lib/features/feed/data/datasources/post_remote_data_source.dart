
import 'package:dio/dio.dart';
import 'package:mini_social_feed_starter/core/network/dio_client.dart';
import 'package:mini_social_feed_starter/features/feed/data/models/post_model.dart';

class PostRemoteDataSource {
  final Dio _dio = DioClient.dio;

  Future<List<PostModel>> fetchPosts({
    required int page,
    required int limit,
  }) async {
    final start = (page - 1) * limit;
    final postsRes = await _dio.get(
      '/posts',
      queryParameters: {'_start': start, '_limit': limit},
    );
    final usersRes = await _dio.get('/users');
    final users = {
      for (final u in (usersRes.data as List))
        u['id'] as int: u as Map<String, dynamic>,
    };

    final models = <PostModel>[];
    for (final p in (postsRes.data as List)) {
      final user = users[(p['userId'] as int)]!;
      models.add(
        PostModel.fromJsonPlaceholder(p as Map<String, dynamic>, user),
      );
    }
    return models;
  }

  // NEW: fetch all posts for a single userId
  Future<List<PostModel>> fetchPostsByUser(int userId) async {
    final postsRes = await _dio.get(
      '/posts',
      queryParameters: {'userId': userId},
    );
    final userRes = await _dio.get('/users/$userId');
    final user = userRes.data as Map<String, dynamic>;

    final models = <PostModel>[];
    for (final p in (postsRes.data as List)) {
      models.add(
        PostModel.fromJsonPlaceholder(p as Map<String, dynamic>, user),
      );
    }
    return models;
  }
}
