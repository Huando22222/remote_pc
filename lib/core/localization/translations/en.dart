import 'package:pc_remote/core/localization/app_strings.dart';

class EnStrings extends AppStrings {
  @override
  String get appName => 'Remote PC';
  @override
  String get touchpad => 'Touchpad';
  @override
  String get keyboard => 'Keyboard';
  @override
  String get fileTransfer => 'Send file';
  @override
  String get clipboard => 'Clipboard';
  @override
  String get mediaControl => 'Media control';
  @override
  String get disconnect => 'Disconnect';
  @override
  String get settings => 'Settings';
  @override
  String get save => 'Save';
  @override
  String get cancel => 'Cancel';
  @override
  String get language => 'Language';
  @override
  String get english => 'English';
  @override
  String get vietnamese => 'Vietnamese';
  @override
  String get mouseSensitivity => 'Mouse sensitivity';
  @override
  String get mouseSensitivityDescription =>
      'Controls how fast the PC cursor moves from touchpad gestures.';
  @override
  String get scrollSensitivity => 'Scroll sensitivity';
  @override
  String get scrollSensitivityDescription =>
      'Controls how fast two-finger scrolling moves on the PC.';
  @override
  String get autoConnect => 'Auto connect';
  @override
  String get autoConnectDescription =>
      'Reconnect automatically to the last PC when the app opens.';
  @override
  String get desktopAppDownload => 'Desktop app';
  @override
  String get desktopAppDownloadDescription =>
      'Download the Remote PC Server app for your computer.';
  @override
  String get openDownloadLink => 'Open download link';
  @override
  String get reset => 'Reset';
  @override
  String get connection => 'Connection';
  @override
  String get connectedDevice => 'Connected device';
  @override
  String get disconnected => 'Disconnected';
  @override
  String disconnectedMessage(int count) {
    return count == 0 ? noClientConnected : 'Disconnected $count device(s).';
  }

  @override
  String get noClientConnected => 'No devices were connected.';
}
