
import 'package:flutter/material.dart';

import '../models/sync_history_model.dart';
import '../models/sync_queue_model.dart';
import '../data/sync_data.dart';

class SyncProvider extends ChangeNotifier {

  bool _isLoading = false;
  bool _isSyncing = false;
  bool _isOnline = true;

  List<SyncQueueModel> _waitingQueue = [];
  List<SyncHistoryModel> _lastSync = [];

  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;
  bool get isOnline => _isOnline;

  List<SyncQueueModel> get waitingQueue => _waitingQueue;
  List<SyncHistoryModel> get lastSync => _lastSync;

  int get totalWaiting => _waitingQueue.fold<int>(0, (sum, item) => sum + item.count);

  SyncProvider() {
    loadSyncData();
  }

  Future<void> loadSyncData() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));

    _waitingQueue = SyncData.getWaitingQueue();
    _lastSync = SyncData.getLastSync();

    _isLoading = false;
    notifyListeners();
  }

  void setConnectionStatus(bool status) {
    _isOnline = status;
    notifyListeners();
  }

  Future<bool> synchronizeNow() async {
    if (!_isOnline || _waitingQueue.isEmpty) return false;

    _isSyncing = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 3));

    _isSyncing = false;
    _waitingQueue.clear();

    notifyListeners();
    return true;
  }
}