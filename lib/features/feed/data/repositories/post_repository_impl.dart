import '../datasources/post_local_data_source.dart';
import '../datasources/post_remote_data_source.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;
  final PostLocalDataSource local;
  PostRepositoryImpl({required this.remote, required this.local});

  @override
  Future<List<Post>> getPosts({required int page, required int limit}) async {
    // try network, fall back to cache
    try {
      final models = await remote.fetchPosts(page: page, limit: limit);
      final entities = models.map((e) => e.toEntity()).toList();
      await local.savePosts(entities);
      return entities;
    } catch (_) {
      return local.getCachedPosts();
    }
  }

  @override
  Future<List<Post>> refresh({required int limit}) async {
    final models = await remote.fetchPosts(page: 1, limit: limit);
    final entities = models.map((e) => e.toEntity()).toList();
    await local.savePosts(entities);
    return entities;
  }

  @override
  Future<Post> toggleLike(int postId) async {
    // Optimistic: update local immediately. In a real app we'd also POST/PATCH.
    await local.toggleLikeLocal(postId);
    final updated = local.getCachedPosts().firstWhere((p) => p.id == postId);
    return updated;
  }
}
