import '../entities/post.dart';
import '../repositories/post_repository.dart';

class RefreshPosts {
  final PostRepository repo;
  RefreshPosts(this.repo);

  Future<List<Post>> call({int limit = 10}) {
    return repo.refresh(limit: limit);
  }
}
