import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

extension StringExtension on String {
  /// capitalize first letter
  String get capitalizeFirstLetter {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Parse [time] to `TimeOfDay`.
  static TimeOfDay toTimeOfDay(String time) {
    List<String> values = time.split(':');
    return TimeOfDay(
      hour: int.parse(values[0]),
      minute: int.parse(values[1]),
    );
  }
}

extension StringNullableExtension on String? {
  /// return `true` if `String` is null
  bool get isNull => this == null;

  /// return `true` if `String` is not null
  bool get isNotNull => this != null;

  /// return `true` if `String` is null or empty, after trimming String
  bool get isNullOrEmpty => (this ?? '').trim().isEmpty;

  /// return `true` if `String` is not null or empty, after trimming String
  bool get isNotNullOrEmpty => (this ?? '').trim().isNotEmpty;

  /// return a `CachedNetworkImageProvider?` from `String`.
  CachedNetworkImageProvider? get toImageProvider =>
      isNotNullOrEmpty ? CachedNetworkImageProvider(this!) : null;
}
