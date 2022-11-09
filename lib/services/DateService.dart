import 'package:intl/intl.dart';


import '../constants/Dates.dart';
import '../widgets/controls/DateRangeWidget.dart';


class DateService {
  static bool isBeforeNow(String dateString) {
    DateTime now = DateTime.now();
    DateTime date = parseDateTime(dateString);
    return date.isBefore(now);
  }

  static bool isAfterNow(String dateString) {
    DateTime now = DateTime.now();
    DateTime date = parseDateTime(dateString);
    return date.isAfter(now);
  }

  static bool isToday(String dateString) {
    DateTime now = DateTime.now();
    DateTime date = parseDateTime(dateString);
    return ((now.year == date.year) &&
        (now.month == date.month) &&
        (now.day == date.day));
  }

  static bool overAWeekOld(String dateString) {
    DateTime now = DateTime.now();
    DateTime date = parse(dateString);
    return (date.isBefore(now)) && (date.difference(now).inHours > 7);
  }

  static String dateStamp() {
    return DATE_FORMAT.format(DateTime.now());
  }

  static DateTime parse(String dt) {
    return DATE_FORMAT.parse(dt);
  }

  static DateTime parseBeginning(String str) {
    return beginningOfDate(parse(str));
  }

  static String format(DateTime dt) {
    return DATE_FORMAT.format(dt);
  }

  static DateTime parseDateTime(String dt) {
    return DATE_TIME_FORMAT.parse(dt);
  }

  static DateTime parseBeginningDateTime(String str) {
    return beginningOfDate(parseDateTime(str));
  }

  static String formatDateTime(DateTime dt) {
    return DATE_TIME_FORMAT.format(dt);
  }

  static DateTime addDay(DateTime dt) {
    return beginningOfDate(dt.add(Duration(hours: 25))); // weird
  }

  static DateTime addDays(DateTime dt, int days) {
    DateTime dt2 = beginningOfDate(dt);
    for (int i = 0; i < days; i++) {
      dt2 = addDay(dt2);
    }
    return dt2;
  }

  static DateRange createCalendarDateRange(DateRange dateRange) {
    DateTime startDt = dateRange.start;
    while (startDt.weekday != 7) {
      // while not Sunday
      startDt = startDt.subtract(Duration(days: 1));
    }
    DateTime endDt = dateRange.end;
    while (endDt.weekday != 7) {
      // while not Sunday
      endDt = endDt.add(Duration(days: 1));
    }
    return DateRange(startDt, endDt);
  }

//  static DateRange createPrescriptionCalendarDateRange(DateRange dateRange) {
//    DateRange calendarDateRange = createCalendarDateRange(dateRange);
//    return DateRange(calendarDateRange.start.subtract(Duration(days: 7)),
//        calendarDateRange.end.add(Duration(days: 7)));
//  }

  static DateRange createDateRangeFromDateStrings(
      String dateString1, dateString2) {
    DateTime dt1 = parseBeginning(dateString1);
    DateTime dt2 = parseBeginning(dateString2);
    return dt1.isBefore(dt2) ? DateRange(dt1, dt2) : DateRange(dt2, dt1);
  }

  static bool isDateOutsideDateRange(DateTime dt, DateRange dateRange) {
    DateTime dt2 = beginningOfDate(dt);
    DateTime start2 = beginningOfDate(dateRange.start);
    DateTime end2 = beginningOfDate(dateRange.end);
    return dt2.isBefore(start2) || dt2.isAfter(end2);
  }

  static DateTime beginningOfToday() {
    DateTime now = DateTime.now();
    return beginningOfDate(now);
  }

  static DateTime beginningOfTodayMinusDays(int days) {
    DateTime dt = DateTime.now().subtract(Duration(days: days));
    return beginningOfDate(dt);
  }

  static DateTime beginningOfTodayPlusDays(int days) {
    DateTime dt = DateTime.now().add(Duration(days: days));
    return beginningOfDate(dt);
  }

  static String beginningOfTodayPlusDaysAsString(int days) {
    DateTime dt = DateTime.now().add(Duration(days: days));
    return DATE_FORMAT.format(beginningOfDate(dt));
  }

  static DateTime beginningOfFiveYearsTime() {
    DateTime dt = DateTime.now().add(Duration(days: 365 * 5));
    return beginningOfDate(dt);
  }

  static DateTime beginningOfDayFromDateString(String dateString) {
    return beginningOfDate(DATE_FORMAT.parse(dateString));
  }

  static DateTime beginningOfDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static String getTimezoneName() {
    return DateTime.now().timeZoneName;
  }

  static String getTimezoneOffset() {
    return DateTime.now().timeZoneOffset.toString();
  }

//  static String getTimezoneOffsetReadable() {
//    return makeTimeZoneOffsetReadable(getTimezoneOffset());
//  }

//  static String makeTimeZoneOffsetReadable(String timezoneOffset) {
//    if (timezoneOffset == null) {
//      return "";
//    } else if (timezoneOffset.isEmpty) {
//      return "";
//    } else {
//      int idx = timezoneOffset.lastIndexOf(".");
//      return timezoneOffset.substring(0, idx);
//    }
//  }

  static bool equals(DateTime dt1, DateTime dt2) {
    return beginningOfDate(dt1).isAtSameMomentAs(beginningOfDate(dt2));
  }

  static DateTime parseDateAndTimeZone(
      String dateString, String timeZoneOffset) {

    DateTime dt = dateString.contains(":") ? parseDateTime(dateString) : parse(dateString);
    int firstColon = timeZoneOffset.indexOf(":");
    int secondColon = timeZoneOffset.indexOf(":", firstColon + 1);

    String offsetHours =
        timeZoneOffset.substring(0, firstColon);
    String offsetMinutes =
        timeZoneOffset.substring(firstColon + 1, secondColon);

    int offsetHoursInt = int.parse(offsetHours);
    int offsetMinutesInt = int.parse(offsetMinutes);

    NumberFormat formatter = NumberFormat("00");

    String result =
        "${dt.year}-${formatter.format(dt.month)}-${formatter.format(dt.day)}T${formatter.format(dt.hour)}:${formatter.format(dt.minute)}:00${formatter.format(offsetHoursInt)}${formatter.format(offsetMinutesInt)}";

    return DateTime.parse(result);
  }
}
