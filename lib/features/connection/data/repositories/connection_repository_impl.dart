import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/connection_repository.dart';
import '../datasources/connection_socket_datasource.dart';

class ConnectionRepositoryImpl implements ConnectionRepository {
  final ConnectionSocketDatasource datasource;

  ConnectionRepositoryImpl(this.datasource);

  @override
  Future<void> connect(String ip) {
    return datasource.connect(ip);
  }

  @override
  Future<void> disconnect() {
    return datasource.disconnect();
  }

  @override
  Stream<bool> observeConnection() {
    return datasource.observeConnection();
  }
}

final connectionRepositoryProvider = Provider(
  (ref) => ConnectionRepositoryImpl(ref.read(connectionDatasourceProvider)),
);
