import 'package:flutter/material.dart';
import '../models/player.dart';

enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
  error
}

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  Player? _currentPlayer;
  String? _error;
  bool _isGuest = false;

  // Getters
  AuthStatus get status => _status;
  Player? get currentPlayer => _currentPlayer;
  String? get error => _error;
  bool get isGuest => _isGuest;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // 게스트 로그인
  Future<bool> signInAsGuest() async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();

      // 게스트 플레이어 생성
      _currentPlayer = Player(
        id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Guest Player',
      );

      _isGuest = true;
      _status = AuthStatus.authenticated;
      _error = null;
      notifyListeners();

      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 이메일/비밀번호 로그인
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();

      // TODO: 실제 백엔드 연동 시 구현
      await Future.delayed(const Duration(seconds: 1)); // 테스트용 딜레이

      if (email == 'test@example.com' && password == 'password') {
        _currentPlayer = Player(
          id: 'user_123',
          name: 'Test User',
        );

        _isGuest = false;
        _status = AuthStatus.authenticated;
        _error = null;
        notifyListeners();

        return true;
      } else {
        throw Exception('Invalid email or password');
      }
    } catch (e) {
      _status = AuthStatus.error;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 회원가입
  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();

      // TODO: 실제 백엔드 연동 시 구현
      await Future.delayed(const Duration(seconds: 1)); // 테스트용 딜레이

      _currentPlayer = Player(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: username,
      );

      _isGuest = false;
      _status = AuthStatus.authenticated;
      _error = null;
      notifyListeners();

      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      _status = AuthStatus.unauthenticated;
      _currentPlayer = null;
      _isGuest = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // 비밀번호 재설정
  Future<bool> resetPassword(String email) async {
    try {
      // TODO: 실제 백엔드 연동 시 구현
      await Future.delayed(const Duration(seconds: 1)); // 테스트용 딜레이

      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 프로필 업데이트
  Future<bool> updateProfile({
    String? username,
    String? email,
    String? photoUrl,
  }) async {
    try {
      if (_currentPlayer == null) {
        throw Exception('No authenticated user');
      }

      // TODO: 실제 백엔드 연동 시 구현
      await Future.delayed(const Duration(seconds: 1)); // 테스트용 딜레이

      // 현재는 이름만 업데이트
      _currentPlayer = Player(
        id: _currentPlayer!.id,
        name: username ?? _currentPlayer!.name,
      );

      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 게스트 계정을 정식 계정으로 변환
  Future<bool> convertGuestToRegular({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      if (!_isGuest) {
        throw Exception('Current user is not a guest');
      }

      // TODO: 실제 백엔드 연동 시 구현
      await Future.delayed(const Duration(seconds: 1)); // 테스트용 딜레이

      // 게스트 데이터를 보존하면서 계정 업그레이드
      _currentPlayer = Player(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: username,
        level: _currentPlayer?.level ?? 1,
        experience: _currentPlayer?.experience ?? 0,
        points: _currentPlayer?.points ?? 0,
      );

      _isGuest = false;
      _status = AuthStatus.authenticated;
      _error = null;
      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 세션 복구
  Future<bool> restoreSession() async {
    try {
      // TODO: 실제 세션 복구 로직 구현
      await Future.delayed(const Duration(seconds: 1)); // 테스트용 딜레이

      // 테스트를 위해 항상 실패하도록 설정
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _status = AuthStatus.error;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 에러 초기화
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // 상태 초기화
  void reset() {
    _status = AuthStatus.initial;
    _currentPlayer = null;
    _isGuest = false;
    _error = null;
    notifyListeners();
  }
}
