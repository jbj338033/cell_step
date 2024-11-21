import 'player.dart';
import 'point.dart';

class GameState {
  Player player;
  List<GamePoint> points;
  List<PowerUp> activeBuffs;
  GameSettings settings;
  DateTime lastUpdate;

  GameState({
    required this.player,
    List<GamePoint>? points,
    List<PowerUp>? activeBuffs,
    GameSettings? settings,
  })  : points = points ?? [],
        activeBuffs = activeBuffs ?? [],
        settings = settings ?? GameSettings(),
        lastUpdate = DateTime.now();

  void update() {
    final now = DateTime.now();
    now.difference(lastUpdate);

    // 버프 시간 업데이트
    activeBuffs.removeWhere((buff) => buff.isExpired(now));

    // 포인트 재생성
    if (points.length < settings.maxPoints) {
      _generateNewPoints();
    }

    lastUpdate = now;
  }

  void _generateNewPoints() {
    // 실제 구현에서는 플레이어 위치 기반으로 생성
    // 여기서는 더미 데이터로 구현
  }

  void addBuff(PowerUp buff) {
    activeBuffs.add(buff);
  }

  double getStatWithBuffs(String statName) {
    double baseValue = 1.0;
    for (var buff in activeBuffs) {
      if (buff.stats.containsKey(statName)) {
        baseValue *= buff.stats[statName]!;
      }
    }
    return baseValue;
  }

  Map<String, dynamic> toMap() {
    return {
      'player': player.toMap(),
      'points': points.map((p) => p.toMap()).toList(),
      'activeBuffs': activeBuffs.map((b) => b.toMap()).toList(),
      'settings': settings.toMap(),
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  factory GameState.fromMap(Map<String, dynamic> map) {
    return GameState(
      player: Player.fromMap(map['player']),
      points: (map['points'] as List).map((p) => GamePoint.fromMap(p)).toList(),
      activeBuffs:
          (map['activeBuffs'] as List).map((b) => PowerUp.fromMap(b)).toList(),
      settings: GameSettings.fromMap(map['settings']),
    );
  }
}

class PowerUp {
  final String id;
  final String name;
  final Map<String, double> stats;
  final Duration duration;
  final DateTime startTime;

  PowerUp({
    required this.id,
    required this.name,
    required this.stats,
    required this.duration,
    DateTime? startTime,
  }) : startTime = startTime ?? DateTime.now();

  bool isExpired(DateTime now) {
    return now.difference(startTime) >= duration;
  }

  double getRemainingTime(DateTime now) {
    final diff = duration - now.difference(startTime);
    return diff.inMilliseconds / 1000;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'stats': stats,
      'duration': duration.inMilliseconds,
      'startTime': startTime.toIso8601String(),
    };
  }

  factory PowerUp.fromMap(Map<String, dynamic> map) {
    return PowerUp(
      id: map['id'],
      name: map['name'],
      stats: Map<String, double>.from(map['stats']),
      duration: Duration(milliseconds: map['duration']),
      startTime: DateTime.parse(map['startTime']),
    );
  }
}

class GameSettings {
  int maxPoints;
  double pointSpawnRadius;
  double collectRadius;
  int pointRespawnTime;

  GameSettings({
    this.maxPoints = 50,
    this.pointSpawnRadius = 100,
    this.collectRadius = 5,
    this.pointRespawnTime = 30,
  });

  Map<String, dynamic> toMap() {
    return {
      'maxPoints': maxPoints,
      'pointSpawnRadius': pointSpawnRadius,
      'collectRadius': collectRadius,
      'pointRespawnTime': pointRespawnTime,
    };
  }

  factory GameSettings.fromMap(Map<String, dynamic> map) {
    return GameSettings(
      maxPoints: map['maxPoints'],
      pointSpawnRadius: map['pointSpawnRadius'],
      collectRadius: map['collectRadius'],
      pointRespawnTime: map['pointRespawnTime'],
    );
  }
}
