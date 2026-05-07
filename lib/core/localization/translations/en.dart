import 'package:ltc/core/localization/app_strings.dart';

class EnStrings extends AppStrings {
  EnStrings();

  @override
  String get appName => 'LTC';
  @override
  String get appTagline => 'Healthcare Management Solution';

  @override
  String get login => 'Login';
  @override
  String get logout => 'Logout';
  @override
  String get username => 'Username';
  @override
  String get password => 'Password';
  @override
  String get loginFailed => 'Login failed';
  @override
  String get forgotPassword => 'Forgot Password?';
  @override
  String get loginInstruction => 'Please enter your credentials to log in.';
  @override
  String get noAccountMessage => 'Don\'t have an account?';
  @override
  String get register => 'Register';

  @override
  String get save => 'Save';
  @override
  String get cancel => 'Cancel';
  @override
  String get loading => 'Loading...';
  @override
  String get error => 'An error occurred';
  @override
  String get changeLanguage => 'Change language';

  @override
  String get home => 'Home';
  @override
  String get document => 'Documents';
  @override
  String get health => 'Health';
  @override
  String get profile => 'Profile';

  @override
  String welcome(String name) => 'Hello, $name';
  @override
  String required(String field) => '$field is required';

  @override
  String get doctors => 'Doctors';
  @override
  String get features => 'Features';
  @override
  String get medicalTopics => 'Medical Topics';
  @override
  String get packages => 'Packages';
  @override
  String get testServices => 'Test Services';
  @override
  String get viewAll => 'View All';
  @override
  String get explore => 'Explore';
  @override
  String get account => 'Account';
  @override
  String get booking => 'Booking';
  @override
  String get changePassword => 'ChangePassword';
  @override
  String get darkMode => 'DarkMode';
  @override
  String get language => 'Language';
  @override
  String get languageName => 'LanguageName';
  @override
  String get notification => 'Notification';
  @override
  String get preferences => 'Preferences';
  @override
  String get security => 'Security';
  @override
  String get setting => 'Setting';

  @override
  String get contactSupport => 'Contact support';
  @override
  String get editProfile => 'Edit profile';
  @override
  String get privacyPolicy => 'Privacy policy';
  @override
  String get support => 'Support';
  @override
  String get termOfUse => 'Term Of Use';
  @override
  String get guestSubtitle => 'View profile, medical history and more';
  @override
  String get loginToContinue => 'Sign in to continue';
  @override
  String get serviceBooking => 'Service booking';
  @override
  String get specialtyBooking => 'Specialty booking';
  @override
  String get consultation => 'Consultation';
  @override
  String get emergency => 'Emergency';
  @override
  String get labTest => 'Test';
  @override
  String get lookup => 'Lookup';
  @override
  String get medication => 'Med';
  @override
  String get specialty => 'Specialty';
  @override
  String get all => 'All';
  @override
  String get service => 'Service';
  @override
  String get package => 'Package';
  @override
  String get packageBooking => 'Package booking';
  @override
  String get loginRequiredTitle => 'Login required';
  @override
  String loginRequiredSubtitle(String? featureName) {
    if (featureName != null) {
      return 'You need to log in to use "$featureName".';
    }
    return 'Log in to fully experience your healthcare features.';
  }

  @override
  String get loginNow => 'Login now';
  @override
  String get createAccount => 'Create account';
  @override
  String get skipContinue => 'Skip and continue';
  @override
  String get benefitBooking => 'Book appointments & track results';
  @override
  String get benefitHealthRecord => 'Store personal health records';
  @override
  String get benefitMore => 'And many feature more';
}
