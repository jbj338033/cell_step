import 'package:flutter/material.dart';
import '../models/point.dart';
import 'dart:math' as math;

class GameProvider extends ChangeNotifier {
  int _score = 0;
  int _level = 1;
  double _experience = 0;
  List<GamePoint> _points = [];

  // 현재 플레이어 위치
  double _playerLat = 0;
  double _playerLng = 0;
  double _collectRadius = 50; // 수집 가능 반경 (미터)

  // Getters
  int get score => _score;
  int get level => _level;
  double get experience => _experience;
  List<GamePoint> get points => _points;

  // 경험치 계산
  double get experienceProgress {
    double maxExp = _calculateMaxExperience();
    return _experience / maxExp;
  }

  double _calculateMaxExperience() {
    return 100 * math.pow(1.5, _level - 1).toDouble();
  }

  // 플레이어 위치 업데이트
  void updatePlayerPosition(double lat, double lng) {
    _playerLat = lat;
    _playerLng = lng;

    // 플레이어 반경 내의 포인트 수집
    _collectNearbyPoints();
    notifyListeners();
  }

  // 플레이어 근처의 포인트 수집
  void _collectNearbyPoints() {
    final toRemove = <GamePoint>[];

    for (final point in _points) {
      double distance = _calculateDistance(
          _playerLat, _playerLng, point.latitude, point.longitude);

      if (distance <= _collectRadius) {
        _score += point.value;
        _addExperience(point.value.toDouble());
        toRemove.add(point);
      }
    }

    _points.removeWhere((point) => toRemove.contains(point));
  }

  // Haversine 공식을 사용한 거리 계산 (미터 단위)
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // 지구 반지름 (미터)

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }

  // 포인트 생성
  void generatePoints(double centerLat, double centerLng, double radius) {
    final random = math.Random();
    _points.clear();

    for (int i = 0; i < 20; i++) {
      // 랜덤 위치 생성
      double randomRadius = radius * math.sqrt(random.nextDouble());
      double theta = random.nextDouble() * 2 * math.pi;

      double lat = centerLat + (randomRadius * math.cos(theta)) / 111111;
      double lng = centerLng +
          (randomRadius * math.sin(theta)) /
              (111111 * math.cos(centerLat * math.pi / 180));

      // 포인트 타입 결정
      PointType type = _determinePointType(random);

      _points.add(GamePoint(
        id: 'point_${DateTime.now().millisecondsSinceEpoch}_$i',
        latitude: lat,
        longitude: lng,
        value: _calculatePointValue(type),
        type: type,
      ));
    }
    notifyListeners();
  }

  PointType _determinePointType(math.Random random) {
    double chance = random.nextDouble();
    if (chance < 0.6) return PointType.normal;
    if (chance < 0.85) return PointType.rare;
    if (chance < 0.95) return PointType.epic;
    return PointType.legendary;
  }

  int _calculatePointValue(PointType type) {
    switch (type) {
      case PointType.normal:
        return 10;
      case PointType.rare:
        return 25;
      case PointType.epic:
        return 50;
      case PointType.legendary:
        return 100;
    }
  }

  // 수동으로 포인트 수집
  void collectPoint(GamePoint point) {
    if (_points.contains(point)) {
      _score += point.value;
      _addExperience(point.value.toDouble());
      _points.remove(point);
      notifyListeners();
    }
  }

  // 경험치 추가
  void _addExperience(double exp) {
    _experience += exp;
    double maxExp = _calculateMaxExperience();

    while (_experience >= maxExp) {
      _experience -= maxExp;
      _level++;
      maxExp = _calculateMaxExperience();
    }
  }
}
