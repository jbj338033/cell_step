import 'dart:math' as math;
import 'package:latlong2/latlong.dart';

class MapUtils {
  // 두 지점 사이의 거리 계산 (미터 단위)
  static double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // 지구 반지름 (미터)

    double lat1 = point1.latitude * math.pi / 180;
    double lat2 = point2.latitude * math.pi / 180;
    double lon1 = point1.longitude * math.pi / 180;
    double lon2 = point2.longitude * math.pi / 180;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  // 중심점으로부터 반경 내의 랜덤한 위치 생성
  static LatLng generateRandomLocation(LatLng center, double radiusInMeters) {
    double radius = radiusInMeters / 111320; // 미터를 위도/경도로 대략적 변환

    double u = math.Random().nextDouble();
    double v = math.Random().nextDouble();

    double w = radius * math.sqrt(u);
    double t = 2 * math.pi * v;

    double x = w * math.cos(t);
    double y = w * math.sin(t);

    double newLat = center.latitude + y;
    // 경도 보정 (위도에 따라 경도 간격이 달라짐)
    double newLng =
        center.longitude + x / math.cos(center.latitude * math.pi / 180);

    return LatLng(newLat, newLng);
  }

  // 여러 개의 랜덤 위치 생성
  static List<LatLng> generateRandomLocations(
    LatLng center,
    double radiusInMeters,
    int count,
  ) {
    List<LatLng> locations = [];
    for (int i = 0; i < count; i++) {
      locations.add(generateRandomLocation(center, radiusInMeters));
    }
    return locations;
  }

  // 포인트가 범위 내에 있는지 확인
  static bool isPointInRange(
      LatLng point, LatLng center, double radiusInMeters) {
    return calculateDistance(point, center) <= radiusInMeters;
  }

  // 지도 영역 계산
  static LatLngBounds calculateBounds(List<LatLng> points) {
    if (points.isEmpty) {
      throw Exception('Points list cannot be empty');
    }

    double minLat = points[0].latitude;
    double maxLat = points[0].latitude;
    double minLng = points[0].longitude;
    double maxLng = points[0].longitude;

    for (var point in points) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    return LatLngBounds(
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    );
  }

  // 지도 줌 레벨 계산
  static double calculateZoomLevel(
    double screenWidth,
    double screenHeight,
    LatLngBounds bounds,
  ) {
    const int tileSize = 256;

    double latRad = bounds.center.latitude * math.pi / 180;

    double latDiff = bounds.northEast.latitude - bounds.southWest.latitude;
    double lngDiff = bounds.northEast.longitude - bounds.southWest.longitude;

    double maxLatDiff = lngDiff * math.cos(latRad);

    double latZoom =
        math.log(screenHeight * 360 / (latDiff * tileSize)) / math.ln2;
    double lngZoom =
        math.log(screenWidth * 360 / (maxLatDiff * tileSize)) / math.ln2;

    return math.min(latZoom, lngZoom);
  }

  // 포인트 클러스터링
  static List<PointCluster> clusterPoints(
    List<LatLng> points,
    double clusterRadius,
  ) {
    List<PointCluster> clusters = [];
    List<LatLng> unclusteredPoints = List.from(points);

    while (unclusteredPoints.isNotEmpty) {
      LatLng point = unclusteredPoints.first;
      List<LatLng> clusterPoints = [];

      unclusteredPoints.removeWhere((p) {
        if (calculateDistance(point, p) <= clusterRadius) {
          clusterPoints.add(p);
          return true;
        }
        return false;
      });

      if (clusterPoints.isNotEmpty) {
        clusters.add(PointCluster(
          center: _calculateClusterCenter(clusterPoints),
          points: clusterPoints,
        ));
      }
    }

    return clusters;
  }

  static LatLng _calculateClusterCenter(List<LatLng> points) {
    double sumLat = 0;
    double sumLng = 0;

    for (var point in points) {
      sumLat += point.latitude;
      sumLng += point.longitude;
    }

    return LatLng(
      sumLat / points.length,
      sumLng / points.length,
    );
  }
}

class PointCluster {
  final LatLng center;
  final List<LatLng> points;

  PointCluster({
    required this.center,
    required this.points,
  });

  int get size => points.length;
}

class LatLngBounds {
  final LatLng southWest;
  final LatLng northEast;

  LatLngBounds(this.southWest, this.northEast);

  LatLng get center => LatLng(
        (southWest.latitude + northEast.latitude) / 2,
        (southWest.longitude + northEast.longitude) / 2,
      );

  bool contains(LatLng point) {
    return point.latitude >= southWest.latitude &&
        point.latitude <= northEast.latitude &&
        point.longitude >= southWest.longitude &&
        point.longitude <= northEast.longitude;
  }
}
