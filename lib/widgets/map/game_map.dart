import 'package:cell_step/models/point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../constants/colors.dart';
import 'point_marker.dart';

class GameMapWidget extends StatelessWidget {
  const GameMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: const LatLng(37.5665, 126.9780),
        initialZoom: 17,
        maxZoom: 18,
        minZoom: 15,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        // 커스텀 지도 타일
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
          tileBuilder: (context, child, tile) {
            return ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0.3,
                0,
                0,
                0,
                0,
                0,
                0.3,
                0,
                0,
                0,
                0,
                0,
                0.5,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ]),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                ),
                child: child,
              ),
            );
          },
        ),

        // 게임 포인트 레이어
        Consumer<GameProvider>(
          builder: (context, gameProvider, _) {
            return CustomPointLayer(
              points: gameProvider.points,
              onPointTap: (point) {
                gameProvider.collectPoint(point);
              },
            );
          },
        ),

        // 플레이어 위치 레이어
        CircleLayer(
          circles: [
            CircleMarker(
              point: const LatLng(37.5665, 126.9780), // 현재 위치로 업데이트 필요
              radius: 10,
              useRadiusInMeter: true,
              color: AppColors.primary.withOpacity(0.3),
              borderColor: AppColors.primary,
              borderStrokeWidth: 2,
            ),
          ],
        ),
      ],
    );
  }
}

class CustomPointLayer extends StatelessWidget {
  final List<GamePoint> points;
  final Function(GamePoint) onPointTap;

  const CustomPointLayer({
    super.key,
    required this.points,
    required this.onPointTap,
  });

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: points.map((point) {
        return Marker(
          point: LatLng(point.latitude, point.longitude),
          width: point.size * 2,
          height: point.size * 2,
          child: GestureDetector(
            onTap: () => onPointTap(point),
            child: PointMarkerWidget(point: point),
          ),
        );
      }).toList(),
    );
  }
}
