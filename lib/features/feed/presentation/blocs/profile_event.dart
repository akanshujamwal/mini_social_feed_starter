
import 'package:equatable/equatable.dart';
abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileStarted extends ProfileEvent {
  final int userId;
  ProfileStarted(this.userId);

  @override
  List<Object?> get props => [userId];
}
