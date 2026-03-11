import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel.freezed.dart';
part 'channel.g.dart';

@freezed
abstract class Channel with _$Channel {
  const factory Channel({
    required String id,
    required String name,
    String? description,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'channel_type') @Default('public') String channelType,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'is_archived') @Default(false) bool isArchived,
    @JsonKey(name: 'member_count') @Default(0) int memberCount,
    @JsonKey(name: 'archived_at') DateTime? archivedAt,
    @JsonKey(name: 'archived_by') String? archivedBy,
  }) = _Channel;

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);
}
