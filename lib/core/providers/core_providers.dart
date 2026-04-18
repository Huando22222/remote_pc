import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/ip_service_impl.dart';

final ipServiceProvider = Provider((ref) => IpServiceImpl());

final localIpProvider = FutureProvider((ref) {
  return ref.read(ipServiceProvider).getLocalIp();
});
