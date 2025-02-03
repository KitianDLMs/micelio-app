import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/environment/environment.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/providers/noti_service.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {

  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  set serverStatus(ServerStatus status) {
    this._serverStatus = status;
  }

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  void connect() async {
    this._socket = IO.io( Environment.socketUrl , {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {
        'id': userSession.id
      }
    });

    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
  }

  void disconnect() {
    this._socket.disconnect();
  }
}