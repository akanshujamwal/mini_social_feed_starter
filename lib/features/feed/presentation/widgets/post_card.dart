
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_social_feed_starter/features/feed/domain/entities/post.dart';
import 'package:mini_social_feed_starter/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:mini_social_feed_starter/features/feed/presentation/blocs/post_interaction_bloc.dart';
import 'package:mini_social_feed_starter/features/feed/presentation/widgets/post_media.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final t = timeago.format(post.createdAt);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.go('/profile/${post.userId}'),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(post.userAvatarUrl),
                    onBackgroundImageError: (_, __) {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.go('/profile/${post.userId}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(t, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(post.text),
            if (post.mediaUrl != null) ...[
              const SizedBox(height: 8),
              PostMedia(mediaUrl: post.mediaUrl!, type: post.mediaType!),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                _LikeButton(
                  postId: post.id,
                  isLiked: post.isLiked,
                  likeCount: post.likeCount,
                ),
                const SizedBox(width: 12),
                _CommentButton(count: post.commentCount),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LikeButton extends StatelessWidget {
  final int postId;
  final bool isLiked;
  final int likeCount;
  const _LikeButton({
    required this.postId,
    required this.isLiked,
    required this.likeCount,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostInteractionBloc, PostInteractionState>(
      listener: (context, state) {
        // When we receive an updated Post from the interaction bloc, patch it into FeedBloc
        if (state.status == InteractionStatus.success &&
            state.updatedPost != null) {
          context.read<FeedBloc>().add(FeedPostPatched(state.updatedPost!));
        }
      },
      builder: (context, state) {
        // Display the most recent values if the interaction updated THIS post
        var displayLiked = isLiked;
        var displayLikes = likeCount;

        if (state.status == InteractionStatus.success &&
            state.updatedPost?.id == postId) {
          displayLiked = state.updatedPost!.isLiked;
          displayLikes = state.updatedPost!.likeCount;
        }

        final icon = displayLiked ? Icons.favorite : Icons.favorite_border;
        return InkWell(
          onTap: () =>
              context.read<PostInteractionBloc>().add(PostLikeToggled(postId)),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 6),
              Text(displayLikes.toString()),
            ],
          ),
        );
      },
    );
  }
}

class _CommentButton extends StatelessWidget {
  final int count;
  const _CommentButton({required this.count});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => DraggableScrollableSheet(
            expand: false,
            builder: (context, scrollController) {
              return ListView.builder(
                controller: scrollController,
                itemCount: 10,
                itemBuilder: (context, i) => ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text('User ${i + 1}'),
                  subtitle: const Text('Nice post! (mocked)'),
                ),
              );
            },
          ),
        );
      },
      child: Row(
        children: [
          const Icon(Icons.mode_comment_outlined),
          const SizedBox(width: 6),
          Text(count.toString()),
        ],
      ),
    );
  }
}
