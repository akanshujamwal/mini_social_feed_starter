
// part of 'feed_bloc.dart';

// abstract class FeedEvent extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class FeedStarted extends FeedEvent {}

// class FeedLoadMore extends FeedEvent {}

// class FeedRefreshed extends FeedEvent {}

// /// New: replace a single post in the current list (e.g., after like toggle)
// class FeedPostPatched extends FeedEvent {
//   final Post post;
//   FeedPostPatched(this.post);

//   @override
//   List<Object?> get props => [post];
// }
part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeedStarted extends FeedEvent {}

class FeedLoadMore extends FeedEvent {}

class FeedRefreshed extends FeedEvent {}

class FeedPostPatched extends FeedEvent {
  final Post post;
  FeedPostPatched(this.post);
  @override
  List<Object?> get props => [post];
}
