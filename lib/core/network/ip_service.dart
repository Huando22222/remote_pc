abstract class IpService {
  Future<String> getLocalIp();
  Future<List<String>> getAllLocalIps();
}

// import 'dart:io';

// class IpService {
//   Future<String> getLocalIp() async {
//     final interfaces = await NetworkInterface.list(
//       type: InternetAddressType.IPv4,
//       includeLoopback: false,
//     );

//     for (final interface in interfaces) {
//       for (final address in interface.addresses) {
//         if (address.type == InternetAddressType.IPv4) {
//           return address.address;
//         }
//       }
//     }

//     return "0.0.0.0";
//   }
// }
