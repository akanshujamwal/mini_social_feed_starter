part of 'post_interaction_bloc.dart';

enum InteractionStatus { idle, processing, success, failure }

class PostInteractionState extends Equatable {
  final InteractionStatus status;
  final Post? updatedPost;

  const PostInteractionState({this.status = InteractionStatus.idle, this.updatedPost});

  PostInteractionState copyWith({InteractionStatus? status, Post? updatedPost}) {
    return PostInteractionState(status: status ?? this.status, updatedPost: updatedPost ?? this.updatedPost);
  }

  @override
  List<Object?> get props => [status, updatedPost];
}
