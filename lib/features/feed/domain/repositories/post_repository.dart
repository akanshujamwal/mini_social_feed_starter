import '../entities/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts({required int page, required int limit});
  Future<List<Post>> refresh({required int limit});
  Future<Post> toggleLike(int postId);
}
