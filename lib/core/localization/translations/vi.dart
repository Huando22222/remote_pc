import 'package:pc_remote/core/localization/app_strings.dart';

class ViStrings extends AppStrings {
  @override
  String get appName => 'Remote PC';
  @override
  String get touchpad => 'Touchpad';
  @override
  String get keyboard => 'Bàn phím';
  @override
  String get fileTransfer => 'Gửi file';
  @override
  String get clipboard => 'Clipboard';
  @override
  String get mediaControl => 'Điều khiển media';
  @override
  String get disconnect => 'Ngắt kết nối';
  @override
  String get settings => 'Cài đặt';
  @override
  String get save => 'Lưu';
  @override
  String get cancel => 'Hủy';
  @override
  String get language => 'Ngôn ngữ';
  @override
  String get english => 'Tiếng Anh';
  @override
  String get vietnamese => 'Tiếng Việt';
  @override
  String get mouseSensitivity => 'Độ nhạy chuột';
  @override
  String get mouseSensitivityDescription =>
      'Điều chỉnh tốc độ con trỏ PC khi rê trên touchpad.';
  @override
  String get reset => 'Đặt lại';
  @override
  String get connection => 'Kết nối';
  @override
  String get connectedDevice => 'Thiết bị đang kết nối';
  @override
  String get disconnected => 'Đã ngắt kết nối';
  @override
  String disconnectedMessage(int count) {
    return count == 0 ? noClientConnected : 'Đã ngắt $count thiết bị.';
  }

  @override
  String get noClientConnected => 'Không có thiết bị nào đang kết nối.';
}
