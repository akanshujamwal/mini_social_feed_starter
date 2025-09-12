import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/toggle_like.dart';

part 'post_interaction_event.dart';
part 'post_interaction_state.dart';

class PostInteractionBloc extends Bloc<PostInteractionEvent, PostInteractionState> {
  final ToggleLike toggleLikeUsecase;

  PostInteractionBloc({required this.toggleLikeUsecase}) : super(const PostInteractionState()) {
    on<PostLikeToggled>(_onLikeToggled);
  }

  Future<void> _onLikeToggled(PostLikeToggled event, Emitter<PostInteractionState> emit) async {
    emit(state.copyWith(status: InteractionStatus.processing));
    final updated = await toggleLikeUsecase(event.postId);
    emit(state.copyWith(status: InteractionStatus.success, updatedPost: updated));
  }
}
