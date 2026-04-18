import '../../../../core/network/ip_service.dart';

class GetLocalIpUseCase {
  final IpService service;

  GetLocalIpUseCase(this.service);

  Future<String> call() {
    return service.getLocalIp();
  }
}
