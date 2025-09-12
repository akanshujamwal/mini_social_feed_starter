import 'package:equatable/equatable.dart';

enum MediaType { image, video }

class Post extends Equatable {
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

  const Post({
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

  Post copyWith({
    int? likeCount,
    bool? isLiked,
  }) => Post(
    id: id,
    userId: userId,
    userName: userName,
    userAvatarUrl: userAvatarUrl,
    text: text,
    createdAt: createdAt,
    mediaUrl: mediaUrl,
    mediaType: mediaType,
    likeCount: likeCount ?? this.likeCount,
    isLiked: isLiked ?? this.isLiked,
    commentCount: commentCount,
  );

  @override
  List<Object?> get props => [id, userId, userName, userAvatarUrl, text, createdAt, mediaUrl, mediaType, likeCount, isLiked, commentCount];
}
