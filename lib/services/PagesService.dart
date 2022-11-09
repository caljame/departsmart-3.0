import '../constants/Pages.dart';

class PagesService {
  static String getPageName(int page) {
    switch (page) {
      case PAGE_HOME:
        return "Home";
      case PAGE_PRESCRIPTIONS:
        return "Prescription Alerts";
      case PAGE_TRIPS:
        return "Trips";
      case PAGE_SAFETY:
        return "Safety";
      case PAGE_SECURITY:
        return "Security";
      case PAGE_EMERGENCIES:
        return "Emergencies";
      case PAGE_HEALTH:
        return "Health";
      case PAGE_TOOLS:
        return "Tools";
      case PAGE_ABOUT:
        return "About";
      case PAGE_PRIVACY_POLICY:
        return "Privacy Policy";
      default:
        return "";
    }
  }
}
