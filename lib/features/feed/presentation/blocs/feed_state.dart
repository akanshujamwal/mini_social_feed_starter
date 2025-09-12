// part of 'feed_bloc.dart';

// enum FeedStatus { initial, loading, success, failure }

// class FeedState extends Equatable {
//   final FeedStatus status;
//   final List<Post> posts;
//   final bool loadingMore;
//   final bool hasMore;

//   const FeedState({
//     this.status = FeedStatus.initial,
//     this.posts = const [],
//     this.loadingMore = false,
//     this.hasMore = true,
//   });

//   FeedState copyWith({
//     FeedStatus? status,
//     List<Post>? posts,
//     bool? loadingMore,
//     bool? hasMore,
//   }) {
//     return FeedState(
//       status: status ?? this.status,
//       posts: posts ?? this.posts,
//       loadingMore: loadingMore ?? this.loadingMore,
//       hasMore: hasMore ?? this.hasMore,
//     );
//   }

//   @override
//   List<Object?> get props => [status, posts, loadingMore, hasMore];
// }
part of 'feed_bloc.dart';

enum FeedStatus { initial, loading, success, failure }

class FeedState extends Equatable {
  final FeedStatus status;
  final List<Post> posts;
  final bool loadingMore;
  final bool hasMore;

  const FeedState({
    this.status = FeedStatus.initial,
    this.posts = const [],
    this.loadingMore = false,
    this.hasMore = true,
  });

  FeedState copyWith({
    FeedStatus? status,
    List<Post>? posts,
    bool? loadingMore,
    bool? hasMore,
  }) {
    return FeedState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      loadingMore: loadingMore ?? this.loadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [status, posts, loadingMore, hasMore];
}
