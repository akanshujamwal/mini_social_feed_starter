import '../entities/post.dart';
import '../repositories/post_repository.dart';

class ToggleLike {
  final PostRepository repo;
  ToggleLike(this.repo);

  Future<Post> call(int postId) {
    return repo.toggleLike(postId);
  }
}
