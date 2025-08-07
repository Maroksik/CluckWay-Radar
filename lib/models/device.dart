import '../utils/distance_zone_helper.dart';

class Device {
  final String id;
  final String name;
  final int rssi;
  final double distance;
  final DistanceZone zone;
  final RssiStrength strength;
  final DateTime lastSeen;
  final bool isConnected;
  final bool notifyWhenClose;
  final String? serialNumber;
  final String? deviceType;

  Device({
    required this.id,
    required this.name,
    required this.rssi,
    required this.distance,
    required this.zone,
    required this.strength,
    required this.lastSeen,
    required this.isConnected,
    required this.notifyWhenClose,
    this.serialNumber,
    this.deviceType,
  });

  factory Device.fromDiscoveredDevice({
    required String id,
    required String name,
    required int rssi,
  }) {
    final distance = DistanceZoneHelper.rssiToMeters(rssi);
    final zone = DistanceZoneHelper.rssiToZone(rssi);
    final strength = DistanceZoneHelper.rssiToStrength(rssi);
    
    return Device(
      id: id,
      name: name.isNotEmpty ? name : 'Unknown Device',
      rssi: rssi,
      distance: distance,
      zone: zone,
      strength: strength,
      lastSeen: DateTime.now(),
      isConnected: false,
      notifyWhenClose: false,
      serialNumber: null,
      deviceType: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'rssi': rssi,
      'distance': distance,
      'zone': zone.index,
      'strength': strength.index,
      'lastSeen': lastSeen.millisecondsSinceEpoch,
      'isConnected': isConnected,
      'notifyWhenClose': notifyWhenClose,
      'serialNumber': serialNumber,
      'deviceType': deviceType,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'],
      name: map['name'],
      rssi: map['rssi'],
      distance: map['distance']?.toDouble() ?? 0.0,
      zone: DistanceZone.values[map['zone']],
      strength: RssiStrength.values[map['strength']],
      lastSeen: DateTime.fromMillisecondsSinceEpoch(map['lastSeen'] ?? DateTime.now().millisecondsSinceEpoch),
      isConnected: map['isConnected'],
      notifyWhenClose: map['notifyWhenClose'],
      serialNumber: map['serialNumber'],
      deviceType: map['deviceType'],
    );
  }

  Device copyWith({
    String? id,
    String? name,
    int? rssi,
    double? distance,
    DistanceZone? zone,
    RssiStrength? strength,
    DateTime? lastSeen,
    bool? isConnected,
    bool? notifyWhenClose,
    String? serialNumber,
    String? deviceType,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      rssi: rssi ?? this.rssi,
      distance: distance ?? this.distance,
      zone: zone ?? this.zone,
      strength: strength ?? this.strength,
      lastSeen: lastSeen ?? this.lastSeen,
      isConnected: isConnected ?? this.isConnected,
      notifyWhenClose: notifyWhenClose ?? this.notifyWhenClose,
      serialNumber: serialNumber ?? this.serialNumber,
      deviceType: deviceType ?? this.deviceType,
    );
  }
} 