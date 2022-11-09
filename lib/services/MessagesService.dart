import 'dart:io';

class MessagesService {
  static String getArrivalTitle(String country) {
    if (Platform.isAndroid) {
      return "Register with SAFE program in ${country}.";
    } else {
      return "Verify you have been registered with the Safety and Accountability for Everyone (SAFE) program in ${country}.";
    }
  }

  static String getArrivalSubtitle(String countries, String tripDates) {
    if (Platform.isAndroid) {
      return "Follow up with a safe arrival email.";
    } else {
      return "Follow up with an email to your local point of contact(s), supervisor(s), and travel preparer, informing them of your safe arrival.";
    }
  }

  static String getPrescriptionMessage(
      bool next, String prescriptionName, String date, String timeZoneName) {
    if (Platform.isAndroid) {
      return next
          ? "Take next ${prescriptionName} ${date} ${timeZoneName}."
          : "Take ${prescriptionName} ${date} ${timeZoneName}.";
    } else {
      return (next ? "Next " : "") +
          "${prescriptionName} should be taken ${date} ${timeZoneName}.";
    }
  }

  static String getPrescriptionSubtitle() {
    return "Prescription Alert";
  }
}
