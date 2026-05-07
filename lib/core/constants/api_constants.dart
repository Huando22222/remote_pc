class ApiConstants {
  ApiConstants._();
  static const String baseUrl = 'https://api.ltc365.com';
  static const String login = '/api/UserApp/authenticate';
  static const String refreshToken = '/api/UserApp/refresh-token';
  static const String checkToken = '/api/UserApp/check-token';
  static const String register = '/api/UserApp/register';
  static const String registerLTC = '/api/UserApp/register-gtltc';
  static const String profile = '/api/PERMISSION/search-user-has-permission';
  // MARK: DASHBOARD
  static const String dashboard = '/api/LTC/Dashboard';
  // MARK: SERVICE
  static const String searchService = '/api/LTC/Service/get-list-service';
  static const String getPackage = '/api/LTC/Package/get-list-package';
  static const String getPackageDetail = '/api/LTC/Package/get-package-details';
  static const String getClinicSpecialty =
      '/api/LTC/Specialty/clinic-specialties';
  // MARK: DOCTOR
  static const String getListDoctor = '/api/LTC/Doctor/get-list-doctor';
}
