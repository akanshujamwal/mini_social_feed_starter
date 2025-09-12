import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPostsPaginated {
  final PostRepository repo;
  GetPostsPaginated(this.repo);

  Future<List<Post>> call({required int page, int limit = 10}) {
    return repo.getPosts(page: page, limit: limit);
  }
}
