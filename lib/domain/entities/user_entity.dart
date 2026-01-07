import 'package:equatable/equatable.dart';

/// User entity - represents the core business object
/// This is the pure domain representation, independent of data sources
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.createdAt,
    this.isActive = true,
  });

  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final DateTime? createdAt;
  final bool isActive;

  /// Create a copy with modified fields
  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
    bool? isActive,
  }) => UserEntity(
    id: id ?? this.id,
    email: email ?? this.email,
    name: name ?? this.name,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    createdAt: createdAt ?? this.createdAt,
    isActive: isActive ?? this.isActive,
  );

  @override
  List<Object?> get props => [id, email, name, avatarUrl, createdAt, isActive];
}
