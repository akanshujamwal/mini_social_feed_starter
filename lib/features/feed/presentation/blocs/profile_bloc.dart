
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_social_feed_starter/features/feed/data/datasources/post_local_data_source.dart';
import 'package:mini_social_feed_starter/features/feed/data/datasources/post_remote_data_source.dart';
import 'package:mini_social_feed_starter/features/feed/data/datasources/user_remote_data_source.dart';
import 'package:mini_social_feed_starter/features/feed/domain/entities/post.dart';
import 'package:mini_social_feed_starter/features/feed/presentation/blocs/profile_event.dart';
import 'package:mini_social_feed_starter/features/feed/presentation/blocs/profile_state.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRemoteDataSource users;
  final PostRemoteDataSource postsRemote;
  final PostLocalDataSource postsLocal;

  ProfileBloc({
    required this.users,
    required this.postsRemote,
    required this.postsLocal,
  }) : super(const ProfileState()) {
    on<ProfileStarted>(_onStarted);
  }

  // Keep only media posts on profile
  List<Post> _onlyMedia(List<Post> posts) =>
      posts.where((p) => p.mediaUrl != null && p.mediaType != null).toList();

  Future<void> _onStarted(ProfileStarted e, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = await users.fetchUser(e.userId);

      // Fetch posts for this user using the same mapping we use in the feed
      final raw = await postsRemote.fetchPostsByUser(user.id);
      final entities = raw.map((m) => m.toEntity()).toList();
      final filtered = _onlyMedia(entities);

      // Cache locally for offline
      await postsLocal.savePosts(filtered);

      emit(
        state.copyWith(
          status: ProfileStatus.success,
          user: user,
          posts: filtered,
        ),
      );
    } catch (_) {
      // Fallback to local cache (filter by userId)
      final cached = postsLocal
          .getCachedPosts()
          .where((p) => p.userId == e.userId)
          .toList();
      if (cached.isEmpty) {
        emit(state.copyWith(status: ProfileStatus.failure));
      } else {
        emit(
          state.copyWith(
            status: ProfileStatus.success,
            user: state.user, // unknown without network, but UI can handle null
            posts: _onlyMedia(cached),
          ),
        );
      }
    }
  }
}
