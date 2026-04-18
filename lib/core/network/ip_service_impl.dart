import 'dart:io';
import 'ip_service.dart';

class IpServiceImpl implements IpService {
  @override
  Future<String> getLocalIp() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );

      for (final interface in interfaces) {
        for (final address in interface.addresses) {
          return address.address;
        }
      }

      return "0.0.0.0";
    } catch (_) {
      return "0.0.0.0";
    }
  }

  @override
  Future<List<String>> getAllLocalIps() async {
    final result = <String>[];

    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
    );

    for (final interface in interfaces) {
      for (final address in interface.addresses) {
        result.add(address.address);
      }
    }

    return result;
  }
}
