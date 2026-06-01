import 'package:pc_remote/core/localization/app_strings.dart';

class ViStrings extends AppStrings {
  @override
  String get appName => 'Remote PC';
  @override
  String get touchpad => 'Touchpad';
  @override
  String get keyboard => 'Ban phim';
  @override
  String get fileTransfer => 'Gui file';
  @override
  String get clipboard => 'Clipboard';
  @override
  String get mediaControl => 'Dieu khien media';
  @override
  String get disconnect => 'Ngat ket noi';
  @override
  String get settings => 'Cai dat';
  @override
  String get save => 'Luu';
  @override
  String get cancel => 'Huy';
  @override
  String get language => 'Ngon ngu';
  @override
  String get english => 'Tieng Anh';
  @override
  String get vietnamese => 'Tieng Viet';
  @override
  String get mouseSensitivity => 'Do nhay chuot';
  @override
  String get mouseSensitivityDescription =>
      'Dieu chinh toc do con tro PC khi re tren touchpad.';
  @override
  String get scrollSensitivity => 'Do nhay cuon';
  @override
  String get scrollSensitivityDescription =>
      'Dieu chinh toc do cuon bang hai ngon tren PC.';
  @override
  String get autoConnect => 'Tu dong ket noi';
  @override
  String get autoConnectDescription =>
      'Tu ket noi lai PC gan nhat khi mo ung dung.';
  @override
  String get reset => 'Dat lai';
  @override
  String get connection => 'Ket noi';
  @override
  String get connectedDevice => 'Thiet bi dang ket noi';
  @override
  String get disconnected => 'Da ngat ket noi';
  @override
  String disconnectedMessage(int count) {
    return count == 0 ? noClientConnected : 'Da ngat $count thiet bi.';
  }

  @override
  String get noClientConnected => 'Khong co thiet bi nao dang ket noi.';
}
