import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/ip_service_impl.dart';
import '../../domain/usecases/get_local_ip_usecase.dart';

final getLocalIpUseCaseProvider = Provider<GetLocalIpUseCase>((ref) {
  return GetLocalIpUseCase(IpServiceImpl());
});

final localIpProvider = FutureProvider<String>((ref) {
  return ref.read(getLocalIpUseCaseProvider).call();
});
