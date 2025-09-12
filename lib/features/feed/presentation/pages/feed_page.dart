// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import '../../data/datasources/post_local_data_source.dart';
// import '../../data/datasources/post_remote_data_source.dart';
// import '../../data/repositories/post_repository_impl.dart';
// import '../../domain/usecases/get_posts_paginated.dart';
// import '../../domain/usecases/refresh_posts.dart';
// import '../../domain/usecases/toggle_like.dart';
// import '../blocs/feed_bloc.dart';
// import '../blocs/post_interaction_bloc.dart';
// import '../widgets/post_card.dart';

// class FeedPage extends StatefulWidget {
//   const FeedPage({super.key});

//   @override
//   State<FeedPage> createState() => _FeedPageState();
// }

// class _FeedPageState extends State<FeedPage> {
//   final _scrollController = ScrollController();
//   late final FeedBloc _feedBloc;
//   late final PostInteractionBloc _interactionBloc;
//   final _local = PostLocalDataSource();

//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }

//   Future<void> _init() async {
//     await _local.init();
//     final repo = PostRepositoryImpl(remote: PostRemoteDataSource(), local: _local);
//     _feedBloc = FeedBloc(getPosts: GetPostsPaginated(repo), refreshPosts: RefreshPosts(repo))..add(FeedStarted());
//     _interactionBloc = PostInteractionBloc(toggleLikeUsecase: ToggleLike(repo));
//     _scrollController.addListener(_onScroll);
//     setState(() {});
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 300) {
//       _feedBloc.add(FeedLoadMore());
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _feedBloc.close();
//     _interactionBloc.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!Hive.isBoxOpen(PostLocalDataSource.postsBoxName)) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(value: _feedBloc),
//         BlocProvider.value(value: _interactionBloc),
//       ],
//       child: Scaffold(
//         appBar: AppBar(title: const Text('Mini Social Feed')),
//         body: RefreshIndicator(
//           onRefresh: () async => _feedBloc.add(FeedRefreshed()),
//           child: BlocBuilder<FeedBloc, FeedState>(
//             builder: (context, state) {
//               if (state.status == FeedStatus.loading) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (state.status == FeedStatus.failure) {
//                 return const Center(child: Text('Something went wrong'));
//               }
//               final posts = state.posts;
//               return ListView.builder(
//                 controller: _scrollController,
//                 itemCount: posts.length + (state.loadingMore ? 1 : 0),
//                 itemBuilder: (context, index) {
//                   if (index >= posts.length) {
//                     return const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       child: Center(child: CircularProgressIndicator()),
//                     );
//                   }
//                   final p = posts[index];
//                   return PostCard(post: p);
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_social_feed_starter/core/theme/theme_cubit.dart';
import 'package:mini_social_feed_starter/features/feed/data/datasources/post_local_data_source.dart';
import 'package:mini_social_feed_starter/features/feed/data/datasources/post_remote_data_source.dart';
import 'package:mini_social_feed_starter/features/feed/data/repositories/post_repository_impl.dart';
import 'package:mini_social_feed_starter/features/feed/domain/usecases/get_posts_paginated.dart';
import 'package:mini_social_feed_starter/features/feed/domain/usecases/refresh_posts.dart';
import 'package:mini_social_feed_starter/features/feed/domain/usecases/toggle_like.dart';
import 'package:mini_social_feed_starter/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:mini_social_feed_starter/features/feed/presentation/blocs/post_interaction_bloc.dart';
import 'package:mini_social_feed_starter/features/feed/presentation/widgets/post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late final FeedBloc _feedBloc;
  late final PostInteractionBloc _interactionBloc;
  final _local = PostLocalDataSource();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _local.init();
    final repo = PostRepositoryImpl(
      remote: PostRemoteDataSource(),
      local: _local,
    );
    _feedBloc = FeedBloc(
      getPosts: GetPostsPaginated(repo),
      refreshPosts: RefreshPosts(repo),
    )..add(FeedStarted());
    _interactionBloc = PostInteractionBloc(toggleLikeUsecase: ToggleLike(repo));
    setState(() {});
  }

  @override
  void dispose() {
    _feedBloc.close();
    _interactionBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen(PostLocalDataSource.postsBoxName)) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _feedBloc),
        BlocProvider.value(value: _interactionBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mini Social Feed'),
          actions: [
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                final isDark = mode == ThemeMode.dark;
                return IconButton(
                  tooltip: isDark ? 'Switch to Light' : 'Switch to Dark',
                  icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                  onPressed: () => context.read<ThemeCubit>().toggle(),
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async => _feedBloc.add(FeedRefreshed()),
          child: BlocBuilder<FeedBloc, FeedState>(
            builder: (context, state) {
              if (state.status == FeedStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == FeedStatus.failure) {
                return const Center(child: Text('Something went wrong'));
              }

              final items = state.posts;
              if (items.isEmpty) {
                return const Center(child: Text('No posts'));
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n is ScrollUpdateNotification) {
                    final metrics = n.metrics;
                    // if less than 200px of content remains below viewport, load more
                    if (metrics.extentAfter < 200 &&
                        state.hasMore &&
                        !state.loadingMore) {
                      _feedBloc.add(FeedLoadMore());
                    }
                  }
                  return false;
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: items.length + (state.loadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= items.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final p = items[index];
                    return PostCard(post: p);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
