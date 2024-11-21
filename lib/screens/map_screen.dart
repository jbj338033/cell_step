import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../constants/colors.dart';
import '../providers/game_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapController = MapController();
  Position? currentPosition;
  StreamSubscription<Position>? positionStream;
  bool isTrackingEnabled = false;
  bool hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  Future<void> _checkAndRequestLocationPermission() async {
    bool permissionGranted = await _handleLocationPermission();
    setState(() {
      hasLocationPermission = permissionGranted;
    });

    if (permissionGranted) {
      _initializeLocation();
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return false;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('위치 서비스 필요'),
          content: const Text('이 앱은 정확한 위치 정보가 필요합니다.\n'
              '위치 서비스를 활성화해주세요.'),
          actions: <Widget>[
            TextButton(
              child: const Text('설정으로 이동'),
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
              },
            ),
          ],
        ),
      );
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return false;

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('위치 권한 필요'),
            content: const Text('이 앱은 게임 플레이를 위해\n'
                '정확한 위치 정보가 반드시 필요합니다.\n'
                '위치 권한을 허용해주세요.'),
            actions: <Widget>[
              TextButton(
                child: const Text('권한 요청'),
                onPressed: () {
                  Navigator.pop(context);
                  _checkAndRequestLocationPermission();
                },
              ),
            ],
          ),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return false;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('위치 권한 필요'),
          content: const Text('이 앱은 게임 플레이를 위해\n'
              '정확한 위치 정보가 반드시 필요합니다.\n'
              '설정에서 위치 권한을 허용해주세요.'),
          actions: <Widget>[
            TextButton(
              child: const Text('설정으로 이동'),
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openAppSettings();
              },
            ),
          ],
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _initializeLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ),
      );

      if (!mounted) return;

      setState(() {
        currentPosition = position;
      });

      // 초기 포인트 생성
      final gameProvider = context.read<GameProvider>();
      gameProvider.generatePoints(
        position.latitude,
        position.longitude,
        200,
      );

      // 지도 이동
      mapController.move(
        LatLng(position.latitude, position.longitude),
        17,
      );

      // 위치 추적 시작
      _startLocationTracking();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('위치를 가져오는데 실패했습니다: $e'),
      ));
    }
  }

  void _startLocationTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
      timeLimit: Duration(seconds: 5),
    );

    positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        if (!mounted) return;

        setState(() {
          currentPosition = position;
          if (isTrackingEnabled) {
            mapController.move(
              LatLng(position.latitude, position.longitude),
              mapController.camera.zoom,
            );
          }
        });

        // 게임 로직 업데이트
        final gameProvider = context.read<GameProvider>();
        gameProvider.updatePlayerPosition(
            position.latitude, position.longitude);
      },
      onError: (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('위치 추적 중 오류가 발생했습니다: $error'),
        ));
      },
    );
  }

  void _toggleTracking() {
    setState(() {
      isTrackingEnabled = !isTrackingEnabled;
      if (isTrackingEnabled && currentPosition != null) {
        mapController.move(
          LatLng(currentPosition!.latitude, currentPosition!.longitude),
          mapController.camera.zoom,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!hasLocationPermission) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1a1a1a), Color(0xFF0a0a0a)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_off,
                  size: 64,
                  color: Colors.white54,
                ),
                const SizedBox(height: 16),
                const Text(
                  '위치 권한이 필요합니다',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '이 앱은 게임 플레이를 위해\n정확한 위치 정보가 필요합니다',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _checkAndRequestLocationPermission,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonBlue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('권한 설정하기'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: currentPosition != null
                  ? LatLng(
                      currentPosition!.latitude, currentPosition!.longitude)
                  : const LatLng(37.5665, 126.9780),
              initialZoom: 17,
              interactionOptions: const InteractionOptions(
                enableScrollWheel: true,
                enableMultiFingerGestureRace: true,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              if (currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        currentPosition!.latitude,
                        currentPosition!.longitude,
                      ),
                      width: 80,
                      height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: const Duration(seconds: 2),
                            builder: (context, double value, child) {
                              return Container(
                                width: 60 * (1 + value * 0.3),
                                height: 60 * (1 + value * 0.3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.neonBlue
                                        .withOpacity(0.5 * (1 - value)),
                                    width: 2,
                                  ),
                                ),
                              );
                            },
                            onEnd: () => setState(() {}),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.neonBlue,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.neonBlue.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // 게임 HUD
          // 게임 HUD
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Consumer<GameProvider>(
                builder: (context, gameProvider, _) => Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 80,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white24,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.neonBlue,
                                    AppColors.neonBlue.withOpacity(0.7),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.neonBlue.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly, // center에서 변경
                                    mainAxisSize: MainAxisSize.min, // max에서 변경
                                    children: [
                                      // 이름
                                      const Text(
                                        'Player Name',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13, // 14에서 축소
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                      // 레벨과 점수
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4, // 6에서 축소
                                              vertical: 1, // 2에서 축소
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.neonYellow
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: AppColors.neonYellow
                                                    .withOpacity(0.5),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              'Lv.${gameProvider.level}',
                                              style: const TextStyle(
                                                color: AppColors.neonYellow,
                                                fontSize: 11, // 12에서 축소
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6), // 8에서 축소
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4, // 6에서 축소
                                              vertical: 1, // 2에서 축소
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.neonGreen
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: AppColors.neonGreen
                                                    .withOpacity(0.5),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.catching_pokemon,
                                                  color: AppColors.neonGreen,
                                                  size: 11, // 12에서 축소
                                                ),
                                                const SizedBox(
                                                    width: 3), // 4에서 축소
                                                Text(
                                                  '${gameProvider.score}',
                                                  style: const TextStyle(
                                                    color: AppColors.neonGreen,
                                                    fontSize: 11, // 12에서 축소
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      // 경험치 바
                                      Stack(
                                        children: [
                                          Container(
                                            height: 3, // 4에서 축소
                                            decoration: BoxDecoration(
                                              color: Colors.black45,
                                              borderRadius:
                                                  BorderRadius.circular(1.5),
                                            ),
                                          ),
                                          FractionallySizedBox(
                                            widthFactor:
                                                gameProvider.experienceProgress,
                                            child: Container(
                                              height: 3, // 4에서 축소
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColors.neonBlue,
                                                    AppColors.neonBlue
                                                        .withOpacity(0.7),
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(1.5),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.neonBlue
                                                        .withOpacity(0.5),
                                                    blurRadius: 4,
                                                    spreadRadius: 0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white24,
                          width: 1,
                        ),
                      ),
                      child: StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          return Text(
                            TimeOfDay.now().format(context),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 게임 컨트롤
          Positioned(
            bottom: 16 + MediaQuery.of(context).padding.bottom,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildFloatingGameButton(
                  icon: Icons.radar,
                  color: AppColors.neonPurple,
                  onPressed: () {},
                  cooldown: 30,
                  isActive: true,
                ),
                const SizedBox(height: 12),
                _buildFloatingGameButton(
                  icon: Icons.speed,
                  color: AppColors.neonGreen,
                  onPressed: () {},
                  cooldown: 60,
                  isActive: false,
                ),
                const SizedBox(height: 12),
                _buildFloatingGameButton(
                  icon: isTrackingEnabled
                      ? Icons.location_disabled
                      : Icons.my_location,
                  color: isTrackingEnabled
                      ? AppColors.neonRed
                      : AppColors.neonBlue,
                  onPressed: _toggleTracking,
                  showCooldown: false,
                  isActive: true,
                ),
              ],
            ),
          ),

          // 좌표 정보 (개발용)
          if (currentPosition != null)
            Positioned(
              bottom: 16 + MediaQuery.of(context).padding.bottom,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white24,
                    width: 1,
                  ),
                ),
                child: Text(
                  '${currentPosition!.latitude.toStringAsFixed(6)},\n${currentPosition!.longitude.toStringAsFixed(6)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontFamily: 'Monospace',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingGameButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    int? cooldown,
    bool showCooldown = true,
    bool isActive = true,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (showCooldown && cooldown != null)
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              value: 0.7,
              strokeWidth: 3,
              backgroundColor: Colors.white12,
              color: color.withOpacity(0.5),
            ),
          ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.black87 : Colors.black45,
            border: Border.all(
              color: isActive ? color : Colors.white24,
              width: 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isActive ? onPressed : null,
              borderRadius: BorderRadius.circular(24),
              child: Icon(
                icon,
                color: isActive ? color : Colors.white24,
                size: 24,
              ),
            ),
          ),
        ),
        if (showCooldown && cooldown != null)
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white24,
                  width: 1,
                ),
              ),
              child: Text(
                '${cooldown}s',
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
