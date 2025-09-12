import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_social_feed_starter/features/feed/data/datasources/post_local_data_source.dart';
import 'package:mini_social_feed_starter/features/feed/data/datasources/post_remote_data_source.dart';
import 'package:mini_social_feed_starter/features/feed/data/datasources/user_remote_data_source.dart';
import 'package:mini_social_feed_starter/features/feed/data/repositories/post_repository_impl.dart';
import 'package:mini_social_feed_starter/features/feed/domain/usecases/toggle_like.dart';
import 'package:mini_social_feed_starter/features/feed/presentation/blocs/post_interaction_bloc.dart';
import 'package:mini_social_feed_starter/features/feed/presentation/blocs/profile_bloc.dart';
import 'package:mini_social_feed_starter/features/feed/presentation/blocs/profile_event.dart';
import 'package:mini_social_feed_starter/features/feed/presentation/blocs/profile_state.dart';
import 'package:mini_social_feed_starter/features/feed/presentation/widgets/post_card.dart';

class ProfilePage extends StatelessWidget {
  final int userId;
  const ProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // datasources + repo for like toggles on this page
    final local = PostLocalDataSource();
    final remote = PostRemoteDataSource();
    final users = UserRemoteDataSource();
    final repo = PostRepositoryImpl(remote: remote, local: local);

    return MultiBlocProvider(
      providers: [
        // Profile loader
        BlocProvider(
          create: (_) => ProfileBloc(
            users: users,
            postsRemote: remote,
            postsLocal: local..init(),
          )..add(ProfileStarted(userId)),
        ),
        // Provide PostInteractionBloc so PostCard's _LikeButton can read it
        BlocProvider(
          create: (_) =>
              PostInteractionBloc(toggleLikeUsecase: ToggleLike(repo)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.status == ProfileStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ProfileStatus.failure) {
              return const Center(child: Text('Failed to load profile'));
            }

            final user = state?.user;
            final posts = state.posts;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundImage: NetworkImage(
                            user?.avatarUrl ??
                                'https://picsum.photos/seed/avatar-$userId/200/200',
                          ),
                          onBackgroundImageError: (_, __) {},
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? 'User #$userId',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text('@${user?.username ?? 'user$userId'}'),
                              if ((user?.email ?? '').isNotEmpty)
                                Text(
                                  user!.email,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              if ((user?.website ?? '').isNotEmpty)
                                Text(
                                  user!.website,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      'Posts',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                if (posts.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('No media posts yet')),
                  )
                else
                  SliverList.separated(
                    itemCount: posts.length,
                    separatorBuilder: (_, __) => const SizedBox.shrink(),
                    itemBuilder: (context, i) => PostCard(post: posts[i]),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
