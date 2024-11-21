import 'package:flutter/material.dart';
import '../constants/colors.dart';

class GamePoint {
  final String id;
  final double latitude;
  final double longitude;
  final int value;
  final Color color;
  final PointType type;
  final double size;

  GamePoint({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.value,
    required this.type,
    Color? color,
    double? size,
  })  : color = color ?? _getDefaultColor(type),
        size = size ?? _getDefaultSize(type);

  static Color _getDefaultColor(PointType type) {
    switch (type) {
      case PointType.normal:
        return AppColors.neonGreen;
      case PointType.rare:
        return AppColors.neonBlue;
      case PointType.epic:
        return AppColors.neonPurple;
      case PointType.legendary:
        return AppColors.neonPink;
    }
  }

  static double _getDefaultSize(PointType type) {
    switch (type) {
      case PointType.normal:
        return 20;
      case PointType.rare:
        return 25;
      case PointType.epic:
        return 30;
      case PointType.legendary:
        return 40;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'value': value,
      'type': type.toString(),
    };
  }

  factory GamePoint.fromMap(Map<String, dynamic> map) {
    return GamePoint(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      value: map['value'],
      type: PointType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => PointType.normal,
      ),
    );
  }

  GamePoint copyWith({
    String? id,
    double? latitude,
    double? longitude,
    int? value,
    PointType? type,
    Color? color,
    double? size,
  }) {
    return GamePoint(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      value: value ?? this.value,
      type: type ?? this.type,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }
}

enum PointType {
  normal,
  rare,
  epic,
  legendary,
}
