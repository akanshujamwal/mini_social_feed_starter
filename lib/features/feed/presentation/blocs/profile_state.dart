

import 'package:equatable/equatable.dart';
import 'package:mini_social_feed_starter/features/feed/domain/entities/post.dart';
import 'package:mini_social_feed_starter/features/feed/domain/entities/user.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final User? user;
  final List<Post> posts;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.posts = const [],
  });

  ProfileState copyWith({
    ProfileStatus? status,
    User? user,
    List<Post>? posts,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      posts: posts ?? this.posts,
    );
  }

  @override
  List<Object?> get props => [status, user, posts];
}
