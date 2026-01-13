import 'package:speckit_flutter_template/domain/entities/user_entity.dart';

/// User model - data layer representation with JSON serialization
/// Extends UserEntity to maintain compatibility with domain layer
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.avatarUrl,
    super.createdAt,
    super.isActive,
  });

  /// Create UserModel from JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    email: json['email'] as String,
    name: json['name'] as String,
    avatarUrl: json['avatar_url'] as String?,
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'] as String)
        : null,
    isActive: json['is_active'] as bool? ?? true,
  );

  /// Create UserModel from UserEntity
  factory UserModel.fromEntity(UserEntity entity) => UserModel(
    id: entity.id,
    email: entity.email,
    name: entity.name,
    avatarUrl: entity.avatarUrl,
    createdAt: entity.createdAt,
    isActive: entity.isActive,
  );

  /// Convert to JSON map
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'avatar_url': avatarUrl,
    'created_at': createdAt?.toIso8601String(),
    'is_active': isActive,
  };

  /// Convert to entity
  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    name: name,
    avatarUrl: avatarUrl,
    createdAt: createdAt,
    isActive: isActive,
  );
}
