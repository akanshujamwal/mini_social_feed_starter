import 'package:hive/hive.dart';
import '../../domain/entities/post.dart';

class PostLocalDataSource {
  static const postsBoxName = 'postsBox';

  Future<void> init() async {
    await Hive.openBox<Map>(postsBoxName);
  }

  Future<void> savePosts(List<Post> posts) async {
    final box = Hive.box<Map>(postsBoxName);
    for (final p in posts) {
      box.put(p.id, {
        'id': p.id,
        'userId': p.userId,
        'userName': p.userName,
        'userAvatarUrl': p.userAvatarUrl,
        'text': p.text,
        'createdAt': p.createdAt.toIso8601String(),
        'mediaUrl': p.mediaUrl,
        'mediaType': p.mediaType?.name,
        'likeCount': p.likeCount,
        'isLiked': p.isLiked,
        'commentCount': p.commentCount,
      });
    }
  }

  List<Post> getCachedPosts() {
    if (!Hive.isBoxOpen(postsBoxName)) return [];
    final box = Hive.box<Map>(postsBoxName);
    return box.values.map((m) {
      return Post(
        id: m['id'] as int,
        userId: m['userId'] as int,
        userName: m['userName'] as String,
        userAvatarUrl: m['userAvatarUrl'] as String,
        text: m['text'] as String,
        createdAt: DateTime.parse(m['createdAt'] as String),
        mediaUrl: m['mediaUrl'] as String?,
        mediaType: (m['mediaType'] as String?) == null ? null : (m['mediaType'] == 'video' ? MediaType.video : MediaType.image),
        likeCount: m['likeCount'] as int,
        isLiked: m['isLiked'] as bool,
        commentCount: m['commentCount'] as int,
      );
    }).toList();
  }

  Future<void> toggleLikeLocal(int postId) async {
    final box = Hive.box<Map>(postsBoxName);
    final m = Map<String, dynamic>.from(box.get(postId) as Map);
    final isLiked = (m['isLiked'] as bool);
    final likeCount = (m['likeCount'] as int) + (isLiked ? -1 : 1);
    m['isLiked'] = !isLiked;
    m['likeCount'] = likeCount;
    await box.put(postId, m);
  }
}
