part of 'post_interaction_bloc.dart';

abstract class PostInteractionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostLikeToggled extends PostInteractionEvent {
  final int postId;
  PostLikeToggled(this.postId);
}
