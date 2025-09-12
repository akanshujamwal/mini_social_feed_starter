
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
