// import 'dart:math';
// import '../../domain/entities/post.dart';

// class PostModel {
//   final int id;
//   final int userId;
//   final String userName;
//   final String userAvatarUrl;
//   final String text;
//   final DateTime createdAt;
//   final String? mediaUrl;
//   final MediaType? mediaType;
//   final int likeCount;
//   final bool isLiked;
//   final int commentCount;

//   PostModel({
//     required this.id,
//     required this.userId,
//     required this.userName,
//     required this.userAvatarUrl,
//     required this.text,
//     required this.createdAt,
//     this.mediaUrl,
//     this.mediaType,
//     this.likeCount = 0,
//     this.isLiked = false,
//     this.commentCount = 0,
//   });

//   factory PostModel.fromJsonPlaceholder(Map<String, dynamic> post, Map<String, dynamic> user, {int? seed}) {
//     final random = Random(seed ?? post['id'] as int);
//     final hasMedia = random.nextBool();
//     final isVideo = random.nextInt(4) == 0; // ~25% videos
//     final mediaUrl = isVideo
//         ? 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4'
//         : 'https://picsum.photos/id/${(post['id'] as int) % 1000}/800/1000';
//     return PostModel(
//       id: post['id'] as int,
//       userId: user['id'] as int,
//       userName: user['name'] as String,
//       userAvatarUrl: 'https://i.pravatar.cc/150?img=${user['id']}',
//       text: (post['body'] as String).toString().replaceAll('\n', ' ').substring(0, ((post['body'] as String).length).clamp(0, 200)),
//       createdAt: DateTime.now().subtract(Duration(hours: (post['id'] as int) % 72)),
//       mediaUrl: hasMedia ? mediaUrl : null,
//       mediaType: hasMedia ? (isVideo ? MediaType.video : MediaType.image) : null,
//       likeCount: random.nextInt(2000),
//       isLiked: false,
//       commentCount: random.nextInt(300),
//     );
//   }

//   Post toEntity() => Post(
//     id: id,
//     userId: userId,
//     userName: userName,
//     userAvatarUrl: userAvatarUrl,
//     text: text,
//     createdAt: createdAt,
//     mediaUrl: mediaUrl,
//     mediaType: mediaType,
//     likeCount: likeCount,
//     isLiked: isLiked,
//     commentCount: commentCount,
//   );
// }
import 'dart:math';

import 'package:mini_social_feed_starter/features/feed/domain/entities/post.dart';

class PostModel {
  final int id;
  final int userId;
  final String userName;
  final String userAvatarUrl;
  final String text;
  final DateTime createdAt;
  final String? mediaUrl;
  final MediaType? mediaType;
  final int likeCount;
  final bool isLiked;
  final int commentCount;

  PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required this.text,
    required this.createdAt,
    this.mediaUrl,
    this.mediaType,
    this.likeCount = 0,
    this.isLiked = false,
    this.commentCount = 0,
  });

  factory PostModel.fromJsonPlaceholder(
    Map<String, dynamic> post,
    Map<String, dynamic> user, {
    int? seed,
  }) {
    final rnd = Random(seed ?? post['id'] as int);

    // Increase media presence so you can test: 80% have media, 30% of those are videos
    final hasMedia = rnd.nextInt(10) < 8;
    final isVideo = rnd.nextInt(10) < 3;

    // CORS-friendly image & avatar (Picsum) and H.264 MP4 with CORS (Google GCS)
    final imageUrl = 'https://picsum.photos/seed/post-${post['id']}/800/1000';
    final videoUrl =
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

    return PostModel(
      id: post['id'] as int,
      userId: user['id'] as int,
      userName: user['name'] as String,
      userAvatarUrl: 'https://picsum.photos/seed/avatar-${user['id']}/100/100',
      text: (post['body'] as String)
          .toString()
          .replaceAll('\\n', ' ')
          .substring(0, ((post['body'] as String).length).clamp(0, 200)),
      createdAt: DateTime.now().subtract(
        Duration(hours: (post['id'] as int) % 72),
      ),
      mediaUrl: hasMedia ? (isVideo ? videoUrl : imageUrl) : null,
      mediaType: hasMedia
          ? (isVideo ? MediaType.video : MediaType.image)
          : null,
      likeCount: rnd.nextInt(2000),
      isLiked: false,
      commentCount: rnd.nextInt(300),
    );
  }

  Post toEntity() => Post(
    id: id,
    userId: userId,
    userName: userName,
    userAvatarUrl: userAvatarUrl,
    text: text,
    createdAt: createdAt,
    mediaUrl: mediaUrl,
    mediaType: mediaType,
    likeCount: likeCount,
    isLiked: isLiked,
    commentCount: commentCount,
  );
}
