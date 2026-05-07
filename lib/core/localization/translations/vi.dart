import 'package:ltc/core/localization/app_strings.dart';

class ViStrings extends AppStrings {
  ViStrings();
  @override
  String get appName => 'LTC';
  @override
  String get appTagline => 'Giải pháp quản lý y tế';
  @override
  String get login => 'Đăng nhập';
  @override
  String get logout => 'Đăng xuất';
  @override
  String get username => 'Tài khoản';
  @override
  String get forgotPassword => 'Quên mật khẩu?';
  @override
  String get loginFailed => 'Đăng nhập thất bại';
  @override
  String get loginInstruction => 'Vui lòng nhập thông tin đăng nhập của bạn.';
  @override
  String get noAccountMessage => 'Chưa có tài khoản?';
  @override
  String get password => 'Mật khẩu';
  @override
  String get register => 'Đăng ký';
  @override
  String get cancel => 'Hủy';
  @override
  String get changeLanguage => 'Đổi ngôn ngữ';
  @override
  String get error => 'Đã xảy ra lỗi';
  @override
  String get loading => 'Đang tải...';
  @override
  String get save => 'Lưu';

  @override
  String get home => 'Trang chủ';
  @override
  String get document => 'Hồ sơ';
  @override
  String get health => 'Sức khỏe';
  @override
  String get profile => 'Tài khoản';

  @override
  String welcome(String name) => 'Xin chào, $name';
  @override
  String required(String field) => '$field không được để trống';

  @override
  String get doctors => 'Bác sĩ';
  @override
  String get features => 'Tính năng';
  @override
  String get medicalTopics => 'Y học gia đình';
  @override
  String get packages => 'Gói dịch vụ';
  @override
  String get testServices => 'Dịch vụ xét nghiệm';
  @override
  String get viewAll => 'Xem Tất Cả';
  @override
  String get explore => 'Tìm hiểu';
  @override
  String get account => 'Tài khoản';
  @override
  String get booking => 'Đặt hẹn';
  @override
  String get changePassword => 'Đổi mật khẩu';
  @override
  String get darkMode => 'Nền tối';
  @override
  String get language => 'Ngôn ngữ';
  @override
  String get languageName => 'Tiếng việt';
  @override
  String get notification => 'Thông báo';
  @override
  String get preferences => 'Tùy chọn';
  @override
  String get security => 'Bảo mật';
  @override
  String get setting => 'Cài đặt';
  @override
  String get contactSupport => 'Liên hệ trợ';
  @override
  String get editProfile => 'Sửa thông tin';
  @override
  String get privacyPolicy => 'Chính sách';
  @override
  String get support => 'Hỗ trợ';
  @override
  String get termOfUse => 'Điều khoản sử dụng';
  @override
  String get guestSubtitle => 'Xem hồ sơ, lịch sử khám và nhiều hơn nữa';
  @override
  String get loginToContinue => 'Đăng nhập để tiếp tục';
  @override
  String get serviceBooking => 'Đặt hẹn dịch vụ';
  @override
  String get specialtyBooking => 'Đặt hẹn chuyên khoa';
  @override
  String get consultation => 'Tư vấn';
  @override
  String get emergency => 'Khẩn cấp';
  @override
  String get labTest => 'Xét nghiệm';
  @override
  String get lookup => 'Tra cứu';
  @override
  String get medication => 'Thuốc';
  @override
  String get specialty => 'Chuyên khoa';
  @override
  String get all => 'Tất cả';
  @override
  String get service => 'Dịch vụ';
  @override
  String get package => 'Gói';
  @override
  String get packageBooking => 'Đặt hẹn gói';
  @override
  String get loginRequiredTitle => 'Đăng nhập để tiếp tục';

  @override
  String loginRequiredSubtitle(String? featureName) {
    if (featureName != null) {
      return 'Bạn cần đăng nhập để sử dụng tính năng "$featureName".';
    }
    return 'Đăng nhập để trải nghiệm đầy đủ các tính năng chăm sóc sức khoẻ của bạn.';
  }

  @override
  String get loginNow => 'Đăng nhập ngay';
  @override
  String get createAccount => 'Tạo tài khoản mới';
  @override
  String get skipContinue => 'Bỏ qua, tiếp tục xem';
  @override
  String get benefitBooking => 'Đặt lịch khám & theo dõi kết quả';
  @override
  String get benefitHealthRecord => 'Lưu trữ hồ sơ sức khoẻ cá nhân';
  @override
  String get benefitMore => 'Và nhiều tính năng khác nữa';
}
