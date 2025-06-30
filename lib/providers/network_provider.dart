import 'dart:math';

import 'package:flutter/material.dart';

class NetworkProvider extends ChangeNotifier {
  bool _isConnected = false;
  String? _connectionError;
  Map<String, dynamic> _roomData = {};

  bool get isConnected => _isConnected;
  String? get connectionError => _connectionError;
  Map<String, dynamic> get roomData => _roomData;

  // Simulate network connection for demo
  Future<bool> connectToRoom(String roomId) async {
    try {
      _connectionError = null;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      // Simulate random connection success/failure
      if (Random().nextBool()) {
        _isConnected = true;
        _roomData = {'roomId': roomId, 'players': [], 'status': 'waiting'};
        notifyListeners();
        return true;
      } else {
        _connectionError = 'Room not found or connection failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _connectionError = 'Network error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<String?> createRoom() async {
    try {
      _connectionError = null;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      // Generate room ID
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      Random random = Random();
      String roomId = String.fromCharCodes(Iterable.generate(
          6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));

      _isConnected = true;
      _roomData = {'roomId': roomId, 'players': [], 'status': 'waiting'};
      notifyListeners();
      return roomId;
    } catch (e) {
      _connectionError = 'Failed to create room: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  void disconnect() {
    _isConnected = false;
    _roomData.clear();
    _connectionError = null;
    notifyListeners();
  }

  // Simulate sending player data
  void sendPlayerData(Map<String, dynamic> playerData) {
    if (_isConnected) {
      // In a real app, this would send data to server
      print('Sending player data: $playerData');
    }
  }

  // Simulate receiving game updates
  void simulateGameUpdate(Map<String, dynamic> gameData) {
    _roomData.addAll(gameData);
    notifyListeners();
  }
}
