import 'package:flutter/material.dart';

class Player {
  final String id;
  final String name;
  int level;
  int experience;
  int points;
  Stats stats;
  List<Achievement> achievements;
  Inventory inventory;

  Player({
    required this.id,
    required this.name,
    this.level = 1,
    this.experience = 0,
    this.points = 0,
    Stats? stats,
    List<Achievement>? achievements,
    Inventory? inventory,
  })  : stats = stats ?? Stats(),
        achievements = achievements ?? [],
        inventory = inventory ?? Inventory();

  double get experienceProgress {
    return experience / requiredExperience;
  }

  int get requiredExperience {
    return (100 * (1.5 * (level - 1))).toInt();
  }

  void addExperience(int amount) {
    experience += amount;
    while (experience >= requiredExperience) {
      experience -= requiredExperience;
      level++;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'experience': experience,
      'points': points,
      'stats': stats.toMap(),
      'achievements': achievements.map((a) => a.toMap()).toList(),
      'inventory': inventory.toMap(),
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'],
      name: map['name'],
      level: map['level'],
      experience: map['experience'],
      points: map['points'],
      stats: Stats.fromMap(map['stats']),
      achievements: (map['achievements'] as List)
          .map((a) => Achievement.fromMap(a))
          .toList(),
      inventory: Inventory.fromMap(map['inventory']),
    );
  }
}

class Stats {
  double speed;
  double power;
  double range;
  double defense;

  Stats({
    this.speed = 1.0,
    this.power = 1.0,
    this.range = 1.0,
    this.defense = 1.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'speed': speed,
      'power': power,
      'range': range,
      'defense': defense,
    };
  }

  factory Stats.fromMap(Map<String, dynamic> map) {
    return Stats(
      speed: map['speed'],
      power: map['power'],
      range: map['range'],
      defense: map['defense'],
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int requiredValue;
  int currentValue;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requiredValue,
    this.currentValue = 0,
  });

  double get progress => currentValue / requiredValue;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconCode': icon.codePoint,
      'requiredValue': requiredValue,
      'currentValue': currentValue,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      icon: IconData(map['iconCode'], fontFamily: 'MaterialIcons'),
      requiredValue: map['requiredValue'],
      currentValue: map['currentValue'],
    );
  }
}

class Inventory {
  List<InventoryItem> items;
  int maxSlots;

  Inventory({
    List<InventoryItem>? items,
    this.maxSlots = 20,
  }) : items = items ?? [];

  bool addItem(InventoryItem item) {
    if (items.length < maxSlots) {
      items.add(item);
      return true;
    }
    return false;
  }

  bool removeItem(String itemId) {
    final index = items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      items.removeAt(index);
      return true;
    }
    return false;
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'maxSlots': maxSlots,
    };
  }

  factory Inventory.fromMap(Map<String, dynamic> map) {
    return Inventory(
      items: (map['items'] as List)
          .map((item) => InventoryItem.fromMap(item))
          .toList(),
      maxSlots: map['maxSlots'],
    );
  }
}

class InventoryItem {
  final String id;
  final String name;
  final String description;
  final ItemType type;
  final ItemRarity rarity;
  final int level;
  final Map<String, double> stats;

  InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.rarity,
    this.level = 1,
    Map<String, double>? stats,
  }) : stats = stats ?? {};

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString(),
      'rarity': rarity.toString(),
      'level': level,
      'stats': stats,
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      type: ItemType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => ItemType.consumable,
      ),
      rarity: ItemRarity.values.firstWhere(
        (e) => e.toString() == map['rarity'],
        orElse: () => ItemRarity.common,
      ),
      level: map['level'],
      stats: Map<String, double>.from(map['stats']),
    );
  }
}

enum ItemType { consumable, equipment, powerup, special }

enum ItemRarity { common, rare, epic, legendary }
