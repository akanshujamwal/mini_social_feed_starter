
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_social_feed_starter/features/feed/domain/entities/post.dart';
import 'package:mini_social_feed_starter/features/feed/domain/usecases/get_posts_paginated.dart';
import 'package:mini_social_feed_starter/features/feed/domain/usecases/refresh_posts.dart';
part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetPostsPaginated getPosts;
  final RefreshPosts refreshPosts;

  int _page = 1;
  final int _limit = 10;
  bool _isFetching = false;
  bool _hasMore = true;

  FeedBloc({required this.getPosts, required this.refreshPosts})
    : super(const FeedState()) {
    on<FeedStarted>(_onStarted);
    on<FeedLoadMore>(_onLoadMore);
    on<FeedRefreshed>(_onRefreshed);
    on<FeedPostPatched>(_onPostPatched);
  }

  List<Post> _onlyMedia(List<Post> posts) =>
      posts.where((p) => p.mediaUrl != null && p.mediaType != null).toList();

  Future<void> _onStarted(FeedStarted event, Emitter<FeedState> emit) async {
    emit(state.copyWith(status: FeedStatus.loading));
    final raw = await getPosts(page: 1, limit: _limit);
    final filtered = _onlyMedia(raw);
    _page = 1;
    _hasMore = raw.isNotEmpty; // key: use RAW page result, not filtered length
    emit(
      state.copyWith(
        status: FeedStatus.success,
        posts: filtered,
        hasMore: _hasMore,
      ),
    );
  }

  Future<void> _onLoadMore(FeedLoadMore event, Emitter<FeedState> emit) async {
    if (_isFetching || !_hasMore) return;
    _isFetching = true;
    emit(state.copyWith(loadingMore: true));

    final nextPage = _page + 1;
    final raw = await getPosts(page: nextPage, limit: _limit);
    final filtered = _onlyMedia(raw);

    _page = nextPage;
    _hasMore = raw.isNotEmpty; // stop only when server sends 0 items

    emit(
      state.copyWith(
        posts: List.of(state.posts)..addAll(filtered),
        hasMore: _hasMore,
        loadingMore: false,
      ),
    );

    _isFetching = false;
  }

  Future<void> _onRefreshed(
    FeedRefreshed event,
    Emitter<FeedState> emit,
  ) async {
    final raw = await refreshPosts(limit: _limit);
    final filtered = _onlyMedia(raw);
    _page = 1;
    _hasMore = raw.isNotEmpty;
    emit(
      state.copyWith(
        status: FeedStatus.success,
        posts: filtered,
        hasMore: _hasMore,
        loadingMore: false,
      ),
    );
  }

  void _onPostPatched(FeedPostPatched event, Emitter<FeedState> emit) {
    if (event.post.mediaUrl == null || event.post.mediaType == null) {
      final remaining = state.posts
          .where((p) => p.id != event.post.id)
          .toList();
      emit(state.copyWith(posts: remaining));
      return;
    }
    final idx = state.posts.indexWhere((p) => p.id == event.post.id);
    if (idx == -1) return;
    final updated = List<Post>.from(state.posts);
    updated[idx] = event.post;
    emit(state.copyWith(posts: updated));
  }
}
