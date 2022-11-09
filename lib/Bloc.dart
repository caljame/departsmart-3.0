import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/Pages.dart';

import 'models/Alert.dart';
import 'models/AlertList.dart';
import 'models/CommandData.dart';
import 'models/Document.dart';
import 'models/Prescription.dart';
import 'models/PrescriptionAlert.dart';
import 'models/PrescriptionList.dart';
import 'models/Trip.dart';
import 'models/TripDestination.dart';
import 'models/TripList.dart';
import 'services/DateService.dart';
import 'services/MessagesService.dart';
import 'services/PagesService.dart';
import 'widgets/controls/DateRangeWidget.dart';

class Bloc extends InheritedWidget {
  int _page = 0;
  TripList? _tripList;
  PrescriptionList? _prescriptionList;
  BehaviorSubject<bool> _pleaseWaitSubject = BehaviorSubject<bool>();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final _commandSubject = BehaviorSubject<CommandData>();
  BehaviorSubject<int>? _pageSubject;
  BehaviorSubject<List<Document>>? _pageDocumentsSubject;
  BehaviorSubject<TripList>? _tripListSubject;
  BehaviorSubject<PrescriptionList>? _prescriptionListSubject;
  BehaviorSubject<AlertList>? _alertListSubject;

  SharedPreferences? _prefs;

  Bloc({super.key, required super.child}) {
    _pageSubject = BehaviorSubject<int>();
    _pageDocumentsSubject = BehaviorSubject<List<Document>>();
    _tripListSubject = BehaviorSubject<TripList>();
    setup();
  }
  void setup() {
    _prescriptionListSubject = BehaviorSubject<PrescriptionList>();
    _alertListSubject = BehaviorSubject<AlertList>();
  }

  static Bloc of(BuildContext context) {
    final Bloc result =
        context.dependOnInheritedWidgetOfExactType<Bloc>() as Bloc;
    assert(result != null, 'No Bloc found in context');

    return result;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      this.child != oldWidget;

  initializePrefs() async {
    if (_prefs == null) {
      SharedPreferences.getInstance()
          .then((prefs) => _prefs = prefs)
          .then((prefs) => _load());
    }
  }

  _load() {
    // Load trip list from json stored in preferences.
    {
      var tripListJson = _prefs?.getString("tripList");
      if ((tripListJson == null) || (tripListJson.isEmpty)) {
        this._tripList = TripList.empty();
      } else {
        Map<String, dynamic> dynamicObject = json.decode(tripListJson);
        this._tripList = TripList.fromJson(dynamicObject);
      }
      this._tripListSubject?.add(this._tripList!);
    }

    // Load prescription list from json stored in preferences.
    {
      var prescriptionListJson = _prefs?.getString("prescriptionList");
      if ((prescriptionListJson == null) || (prescriptionListJson.isEmpty)) {
        this._prescriptionList = PrescriptionList.empty();
      } else {
        Map<String, dynamic> dynamicObject = json.decode(prescriptionListJson);
        this._prescriptionList = PrescriptionList.fromJson(dynamicObject);
      }
      this._prescriptionListSubject?.add(this._prescriptionList!);
    }
  }

  _save() async {
    // Save trip list to json stored in preferences.
    var tripListJson = json.encode(this._tripList?.toJson());
    _prefs?.setString("tripList", tripListJson);

    // Save trip list to json stored in preferences.
    var prescriptionListJson = json.encode(this._prescriptionList?.toJson());
    _prefs?.setString("prescriptionList", prescriptionListJson);
  }

  set view(int page) {
    _page = page;
    _pageSubject?.add(page);
    _pageDocumentsSubject?.add(getDocumentsForPage(page));
  }

  List<Document> getDocumentsForPage(int page) {
    switch (page) {
      case PAGE_SAFETY:
        {
          return [
            Document.webpage("Travel Health Notices",
                "https://wwwnc.cdc.gov/travel/notices"),
            Document.html(
                "Exercise Safely", "media/safety/ExerciseSafely.html"),
            Document.html("Drive Safely", "media/safety/DriveSafely.html"),
            Document.subpage(
                "Environmental Hazards", PAGE_ENVIRONMENTAL_HAZARDS),
            Document.html("Food and Water Safety",
                "media/safety/FoodAndWaterSafety.html"),
          ];
        }

      case PAGE_SECURITY:
        {
          return [
            Document.subpage("Personal Security", PAGE_PERSONAL_SECURITY),
            Document.webpage("Smart Traveler Program",
                "https://step.state.gov/STEPMobile/Default.aspx"),
            Document.webpage("State Dept Travel Advisories",
                "https://travel.state.gov/content/travel/en/traveladvisories/traveladvisories.html"),
            Document.html("Counterintelligence for Travelers",
                "media/security/CounterIntelligenceForTravellers.html"),
            Document.pdf("Active Shooter Guide",
                "media/security/DHSActiveShooterGuide.pdf"),
            Document.html("Securing Electronic Devices",
                "media/security/SecuringElectronicDevices.html"),
          ];
        }

      case PAGE_EMERGENCIES:
        {
          return [
            Document.html("MedEvac Procedures",
                "media/emergencies/MedEvacProcedures.html"),
            Document.pdf("See It, Say It", "media/emergencies/SeeItSayIt.pdf"),
            Document.subpage("Reporting Incidents", PAGE_REPORTING_INCIDENTS),
            Document.subpage("Tactical Medicine Information",
                PAGE_TACTICAL_MEDICINE_INFORMATION),
            Document.subpage("Automobile Accidents", PAGE_AUTOMOBILE_ACCIDENTS),
          ];
        }

      case PAGE_HEALTH:
        {
          return [
            Document.webpage(
                "CDC Travelers' Health", "https://wwwnc.cdc.gov/travel"),
            Document.html(
                "OHC Travel Support", "media/health/ohcTravelSupport.html"),
            Document.html("Health Care Coverage",
                "media/health/HealthCareCoverageForOverseasDeployments.html"),
            Document.subpage("Mental Health", PAGE_MENTAL_HEALTH),
            Document.subpage("Travel Conditions, Illnesses and Diseases",
                PAGE_TRAVEL_CONDITIONS_ILLNESSES_AND_DISEASES),
          ];
        }

      case PAGE_TOOLS:
        {
          // Tools
          return [
            Document.html("Workers' Compensation",
                "media/tools/WorkersCompensation.html"),
            Document.subpage("COVID-19", PAGE_COVID_19),
            Document.subpage(
                "NIOSH Sound Level Meter", PAGE_NIOSH_SOUND_LEVEL_METER),
            Document.subpage("Travel Forms", PAGE_TRAVEL_FORMS),
            Document.downloadablePdf(
                "Injury, Illness and Near-Miss Report Form",
                "media/emergencies/reportingIncidents/304.pdf"),
          ];
        }

      case PAGE_TRAVEL_FORMS:
        {
          return [
            Document.downloadablePdf("Compensatory Time Off for Travel",
                "media/tools/travelForms/CompensatoryTimeOffForTravel.pdf"),
            Document.downloadablePdf("Travel Expenses Worksheet",
                "media/tools/travelForms/TravelExpenseWorksheet.pdf"),
          ];
        }

      case PAGE_COVID_19:
        {
          return [
            Document.pdf(
                "PPE Donning Video", "media/tools/covid19/pfe_donning.mp4"),
            Document.pdf(
                "PPE Doffing Video", "media/tools/covid19/pfe_doffing.mp4"),
            Document.webpage("COVID-19 CDC website",
                "https://www.cdc.gov/coronavirus/2019-ncov/index.html"),
          ];
        }

      case PAGE_TRAVEL_PROCEDURES:
        {
          return [
            Document.pdf("ConcurGov Guides",
                "media/tools/travelProcedures/ConcurGovGuides.pdf"),
            Document.pdf(
                "EOC Travel", "media/tools/travelProcedures/EOCTravel.pdf"),
            Document.pdf("Epi-Aid Travel",
                "media/tools/travelProcedures/EpiAidTravel.pdf"),
            Document.pdf("International Travel",
                "media/tools/travelProcedures/InternationalTravel.pdf"),
            Document.pdf("Reimbursement Checklist",
                "media/tools/travelProcedures/ReimbursementChecklist.pdf"),
            Document.pdf("Workers' Compensation",
                "media/tools/travelProcedures/WorkersCompensation.pdf"),
          ];
        }

      case PAGE_PERSONAL_SECURITY:
        {
          return [
            Document.html("Personal Responsibilities",
                "media/security/PersonalResponsibilities.html"),
            Document.html("Travel Tips", "media/security/TravelTips.html"),
            Document.html("Hotel Security",
                "media/security/hotelSecurity/HotelSecurity.html"),
          ];
        }
      case PAGE_ENVIRONMENTAL_HAZARDS:
        {
          return [
            Document.html("Air Quality Index",
                "media/safety/environmentalHazards/AirQualityIndex.html"),
            Document.html("Recreational Water Warnings",
                "media/safety/environmentalHazards/RecreationalWaterWarnings.html"),
            Document.html("Sun Protection",
                "media/safety/environmentalHazards/SunProtection.html"),
            Document.html("Tick Protection and Removal",
                "media/safety/environmentalHazards/TickProtectionAndRemoval.html"),
          ];
        }

      case PAGE_NIOSH_SOUND_LEVEL_METER:
        {
          return [
            Document.html("NIOSH Sound Level Meter App",
                "media/tools/nioshSoundLevelMeter/NIOSHSoundLevelMeterApp.html"),
            Document.html("How to Interpret the Results",
                "media/tools/nioshSoundLevelMeter/SoundLevelMeterHowTo.html"),
          ];
        }

      case PAGE_REPORTING_INCIDENTS:
        {
          return [
            Document.email(
                "Reporting Security incidents", "globalsecurity@cdc.gov"),
            Document.phone("Reporting Security incidents", "(404)639-5000"),
          ];
        }

      case PAGE_TACTICAL_MEDICINE_INFORMATION:
        {
          return [
            Document.html("March Mnemonic",
                "media/emergencies/tacticalMedicineRefresherInformation/MarchMnemonic.html"),
            Document.subpage("Videos", PAGE_VIDEOS),
          ];
        }

      case PAGE_VIDEOS:
        {
          return [
            Document.video("Emergency Bandage",
                "media/emergencies/tacticalMedicineRefresherInformation/EmergencyBandage.mp4"),
            Document.video("Make Shift Chest Seal",
                "media/emergencies/tacticalMedicineRefresherInformation/MakeShiftChestSeal.mp4"),
            Document.video("Tourniquet",
                "media/emergencies/tacticalMedicineRefresherInformation/Tourniquet.mp4"),
          ];
        }

      case PAGE_AUTOMOBILE_ACCIDENTS:
        {
          return [
            Document.html("When to Report",
                "media/emergencies/automobileAccidents/WhenToReport.html"),
            Document.downloadablePdf("Report Form",
                "media/emergencies/automobileAccidents/MotorVehicleAccidentReport.pdf"),
          ];
        }

      case PAGE_TRAVEL_KIT_MEDICATION_LIST:
        {
          return [
            Document.html("Acetaminophen (Tylenol)",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/AcetaminophenTylenol.html"),
            Document.html("Antibacterial Ointment or Cream",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/AntibacterialOintmentorCream.html"),
            Document.html("Antifungal Ointment or Cream",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/AntifungalOintmentorCream.html"),
            Document.html("Ciprofloxacin (Cipro)",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/CiprofloxacinCipro.html"),
            Document.html("Dimenhydrinate (Dramamine)",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/DimenhydrinateDramamine.html"),
            Document.html("Diphenhydramine (Benadryl)",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/DiphenhydramineBenadryl.html"),
            Document.html("Docusate (Colace)",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/DocusateColace.html"),
            Document.html("Hand Gel",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/HandGel.html"),
            Document.html("Iodine Water Purification Tablets",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/IodineWaterPurificationTablets.html"),
            Document.html("Loperamide (Imodium)",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/LoperamideImodium.html"),
            Document.html("Metronidazole (Flagyl)",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/MetronidazoleFlagyl.html"),
            Document.html("Mintox (Antacid with Simethicone)",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/MintoxAntacidwithSimethicone.html"),
            Document.html("Oral Hydration Salts",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/OralHydrationSalts.html"),
            Document.html("Pepto - Bismol (Bismuth Subsalicylate)",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/PeptoBismolBismuthSubsalicylate.html"),
            Document.html("Povidine - Iodine Antiseptic Solution",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/PovidineIodineAntisepticSolution.html"),
            Document.html("Sunscreen",
                "media/health/travelRelatedOHCServices/travelKit/travelKitMedicationList/Sunscreen.html")
          ];
        }

      case PAGE_MENTAL_HEALTH:
        {
          return [
            Document.html("Leaving your TDY Location",
                "media/health/mentalHealth/LeavingYourTDYLocation.html"),
            Document.html("Stress and Culture Shock",
                "media/health/mentalHealth/StressAndCultureShock.html"),
          ];
        }

      case PAGE_TRAVEL_CONDITIONS_ILLNESSES_AND_DISEASES:
        {
          return [
            Document.subpage("Infectious", PAGE_INFECTIOUS),
            Document.subpage("Non-infectious", PAGE_NON_INFECTIOUS),
          ];
        }

      case PAGE_INFECTIOUS:
        {
          return [
            Document.html("Chikungunya",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/Chikungunya.html"),
            Document.html("Cryptosporidiosis",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/Cryptosporidiosis.html"),
            Document.html("Dengue Fever",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/DengueFever.html"),
            Document.html("Giardiasis",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/Giardiasis.html"),
            Document.html("Hepatitis A",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/HepatitisA.html"),
            Document.html("Hepatitis B",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/HepatitisB.html"),
            Document.html("HIV",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/HIV.html"),
            Document.html("Influenza",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/Influenza.html"),
            Document.html("Japanese Encephalitis",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/JapaneseEncephalitis.html"),
            Document.html("Malaria",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/Malaria.html"),
            Document.html("Rabies",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/Rabies.html"),
            Document.html("Respiratory Tract Infections",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/RespiratoryTractInfections.html"),
            Document.html("Schistosomiasis",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/Schistosomiasis.html"),
            Document.html("Sexually Transmitted Diseases STDs",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/SexuallyTransmittedDiseasesSTDs.html"),
            Document.html("Skin Infections",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/SkinInfections.html"),
            Document.html("Travelers Diarrhea",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/TravelersDiarrhea.html"),
            Document.html("Tuberculosis TB",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/TuberculosisTB.html"),
            Document.html("Typhoid Fever",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/TyphoidFever.html"),
            Document.html("Yellow Fever",
                "media/health/travelConditionsIllnessesAndDiseases/infectious/YellowFever.html"),
          ];
        }

      case PAGE_NON_INFECTIOUS:
        {
          return [
            Document.html("Altitude Illness",
                "media/health/travelConditionsIllnessesAndDiseases/nonInfectious/AltitudeIllness.html"),
            Document.html("Bed Bugs",
                "media/health/travelConditionsIllnessesAndDiseases/nonInfectious/BedBugs.html"),
            Document.html("Deep Vein Thrombosis DVT",
                "media/health/travelConditionsIllnessesAndDiseases/nonInfectious/DeepVeinThrombosisDVT.html"),
            Document.subpage("Heat Illness", PAGE_HEAT_ILLNESS),
            Document.html("Jet Lag",
                "media/health/travelConditionsIllnessesAndDiseases/nonInfectious/JetLag.html"),
            Document.html("Motion Sickness",
                "media/health/travelConditionsIllnessesAndDiseases/nonInfectious/MotionSickness.html"),
          ];
        }

      case PAGE_HEAT_ILLNESS:
        {
          return [
            Document.pdf("Are You Properly Hydrated",
                "media/health/travelConditionsIllnessesAndDiseases/nonInfectious/heatIllness/AreYouProperlyHydrated.pdf"),
            Document.html("Heat Illness Info",
                "media/health/travelConditionsIllnessesAndDiseases/nonInfectious/heatIllness/HeatIllnessInfo.html"),
            Document.html("NIOSH Heat Safety Tool Screen",
                "media/health/travelConditionsIllnessesAndDiseases/nonInfectious/heatIllness/NIOSHHeatSafetyToolScreen.html"),
            Document.pdf("Prevent Heat Illness",
                "media/health/travelConditionsIllnessesAndDiseases/nonInfectious/heatIllness/PreventHeatIllness.pdf")
          ];
        }

      case 999:
        {
          return [
            /*
            Document("", "", "", 0),
            Document("", "", "", 0),
            */
          ];
        }

      default:
        {
          return ([]);
        }
        break;
    }
  }

  void schedule(
      int id, String title, String body, DateTime alertDateTime) async {
    debugPrint("Notification: ${id} ${title} {$body} ${alertDateTime}");
    String sound = '';
    String soundFile = sound.replaceAll('.mp3', '');
    final notificationSound =
        sound == '' ? null : RawResourceAndroidNotificationSound(soundFile);

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', // channel Id
        'your channel id', // channel Name
        playSound: true,
        sound: notificationSound);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.schedule(
        id, title, body, alertDateTime, platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }

  showMessage(String message) {
    _pleaseWaitSubject.add(false);
    _commandSubject.add(CommandData.constructMessage(message));
    _commandSubject.add(CommandData.clearMessage());
  }

  void _checkAlerts() {
    if (_prefs != null) {
      // Get the completed alerts.
      var completedAlertsJson = _prefs?.getString("completedAlerts");
      AlertList completedAlerts;
      if ((completedAlertsJson == null) || (completedAlertsJson.isEmpty)) {
        completedAlerts = AlertList.empty();
      } else {
        Map<String, dynamic> dynamicObject = json.decode(completedAlertsJson);
        completedAlerts = AlertList.fromJson(dynamicObject);
      }

      // Clean old alerts.
      for (int i = completedAlerts.alerts!.length! - 1; i >= 0; i--) {
        if (DateService.overAWeekOld(
            completedAlerts!.alerts![i]!.createdDate!)) {
          completedAlerts.alerts?.removeAt(i);
        }
      }
      var alertListJson = json.encode(completedAlerts.toJson());
      _prefs?.setString("completedAlerts", alertListJson);

      DateTime now = DateTime.now();
      List<Alert> alerts = [];

      // Check for arrival alerts.
      for (Trip? trip in _tripList!.trips) {
        for (TripDestination? destination in trip!.destinations!) {
          var destinationDate = DateService.parse(destination!.date!);
          Duration difference = now.difference(destinationDate);
          if (difference.inDays.abs() < 1) {
            Alert newAlert = Alert.arrival(
                trip.timeZoneName!,
                trip.timeZoneOffset!,
                trip.countries,
                "${trip.departureDate} - ${trip.returnDate}",
                destination!.country!,
                destination.date);
            if (!completedAlerts.alerts!.contains(newAlert)) {
              alerts.add(newAlert);
            }
          }
        }
      }

      // Check for the last prescription alert for each trip.
      for (Prescription? prescription
          in this._prescriptionList!.prescriptions!) {
        for (int i = prescription!.alerts.length! - 1; i >= 0; i--) {
          PrescriptionAlert? prescriptionAlert = prescription.alerts[i];
          if ((DateService.isToday(prescriptionAlert!.datetime!)) &&
              (DateService.isBeforeNow(prescriptionAlert!.datetime!))) {
            Alert newAlert = Alert.prescriptionPast(
                prescription!.timeZoneName!,
                prescription.timeZoneOffset!,
                prescription.name!,
                prescriptionAlert.datetime!);
            if (!completedAlerts.alerts!.contains!(newAlert)) {
              alerts.add(newAlert);
            }
            break;
          }
        }
      }

      // Check for the next future prescription alerts for each trip.
      for (Prescription prescription
          in this._prescriptionList!.prescriptions!) {
        for (PrescriptionAlert prescriptionAlert in prescription.alerts) {
          if ((DateService.isToday(prescriptionAlert.datetime!)) &&
              (DateService.isAfterNow(prescriptionAlert.datetime!))) {
            Alert newAlert = Alert.prescriptionFuture(
                prescription.timeZoneName!,
                prescription.timeZoneOffset!,
                prescription.name!,
                prescriptionAlert.datetime!);
            if (!completedAlerts.alerts!.contains!(newAlert)) {
              alerts.add(newAlert);
            }
            break;
          }
        }
      }

      _alertListSubject?.add(new AlertList.from(alerts));
    }
  }

  void _checkNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    final DateTime now = DateTime.now();
    int id = 0;

    // Arrival Notifications
    for (Trip? trip in this._tripList!.trips) {
      for (TripDestination? destination in trip!.destinations) {
        DateTime? destinationDateTime = DateService.parseDateAndTimeZone(
                destination!.date, trip!.timeZoneOffset!)
            .add(Duration(hours: 18, minutes: 3));
        if (destinationDateTime.isAfter(now)) {
          var title = MessagesService.getArrivalTitle(destination.country);
          var body =
              MessagesService.getArrivalSubtitle(trip.countries, trip.dates);
          ++id;
          schedule(id, title, body, destinationDateTime);
        }
      }
    }

    // Prescription Notifications
    for (Prescription? prescription in this._prescriptionList!.prescriptions) {
      for (PrescriptionAlert? alert in prescription!.alerts) {
        DateTime? alertDateTime = DateService.parseDateAndTimeZone(
            alert!.datetime!, prescription!.timeZoneOffset!);
        if (alertDateTime!.isAfter(now)) {
          var title = MessagesService.getPrescriptionMessage(
              false,
              prescription!.name!,
              alert!.datetime!,
              prescription!.timeZoneName!);
          var body = MessagesService.getPrescriptionSubtitle();
          ++id;
          schedule(id, title, body, alertDateTime);
        }
      }
    }
  }

  addTrip(Trip item) {
    _tripList ??= TripList.empty();
    _tripList?.trips.add(item);
    _tripListSubject?.add(_tripList!);
    _save();
    _checkNotifications();
    _checkAlerts();
  }

  updateTrip(Trip from, Trip to) {
    int? index = _tripList?.trips.indexOf(from);
    Trip itemToUpdate = _tripList!.trips[index!];
    itemToUpdate.departureDate = to.departureDate;
    itemToUpdate.destinations = to.destinations;
    itemToUpdate.returnDate = to.returnDate;
    itemToUpdate.notes = to.notes;
    _tripListSubject?.add(_tripList!);
    _save();
    _checkNotifications();
    _checkAlerts();
  }

  deleteTrip(Trip item) {
    var index = _tripList?.trips.indexOf(item);
    if (index! >= 0) {
      _tripList?.trips.removeAt(index);
    }
    _tripListSubject?.add(_tripList!);
    _save();
    _checkNotifications();
    _checkAlerts();
  }

  addPrescription(Prescription item) {
    _prescriptionList ??= PrescriptionList.empty();
    _prescriptionList?.prescriptions.add(item);
    _prescriptionListSubject?.add(_prescriptionList!);
    _save();
    _checkNotifications();
    _checkAlerts();
  }

  void deleteAllTripsAndPrescriptions() {
    _tripList = TripList.empty();
    _prescriptionList = PrescriptionList.empty();
    _prefs?.setString("completedAlerts", "");
    _save();
    _checkNotifications();
    _checkAlerts();
  }

  updatePrescription(Prescription from, Prescription to) {
    int index = _prescriptionList!.prescriptions.indexOf(from);
    Prescription? itemToUpdate = _prescriptionList!.prescriptions[index];
    itemToUpdate.name = to.name;
    itemToUpdate.timeZoneName = to.timeZoneName;
    itemToUpdate.timeZoneOffset = to.timeZoneOffset;
    itemToUpdate.alerts = to.alerts;
    _prescriptionListSubject?.add(_prescriptionList!);
    _save();
    _checkNotifications();
    _checkAlerts();
  }

  deletePrescription(Prescription item) {
    var index = _prescriptionList?.prescriptions.indexOf(item);
    if (index! >= 0) {
      _prescriptionList?.prescriptions.removeAt(index);
    }
    _prescriptionListSubject?.add(_prescriptionList!);
    _save();
    _checkNotifications();
    _checkAlerts();
  }

  void checkAlertsExternal() {
    _checkAlerts();
  }

  void onCompleteAlert(Alert alert) {
    // Get the completed alerts.
    var completedAlertsJson = _prefs?.getString("completedAlerts");
    AlertList completedAlerts;
    if ((completedAlertsJson == null) || (completedAlertsJson.isEmpty)) {
      completedAlerts = AlertList.empty();
    } else {
      Map<String, dynamic> dynamicObject = json.decode(completedAlertsJson);
      completedAlerts = AlertList.fromJson(dynamicObject);
    }

    // Add the checked alert as a completed alert so it disappears.
    if (!completedAlerts.alerts!.contains(alert)) {
      completedAlerts.alerts?.add(alert);
      var alertListJson = json.encode(completedAlerts.toJson());
      _prefs?.setString("completedAlerts", alertListJson);
    }

//    if (alert.alertType == AlertType.arrival) {
//      _sendArrivalEmail(alert.destinationName);
//    }

    _checkAlerts();
  }

//  void _sendArrivalEmail(String country) async {
//    String mailTo =
//        "mailto:eocreport@cdc.gov?subject=I have arrived in ${country}";
//    if (await canLaunch(mailTo)) {
//      await launch(mailTo);
//    } else {
//      throw 'Could not launch ${mailTo}';
//    }
//  }

  Trip? calculateTripForAgendaDate(DateTime agendaDate) {
    Trip? nullTrip = null;
    if (this._tripList != null) {
      for (Trip? trip in this._tripList!.trips) {
        DateRange dateRange =
            DateRange.fromStrings(trip!.departureDate, trip.returnDate);

        if (!DateService.isDateOutsideDateRange(agendaDate, dateRange)) {
          return trip;
        }
      }
    }
    return nullTrip;
  }

  get pageName {
    return PagesService.getPageName(_page);
  }

  get tripCount {
    if ((_tripList != null)) {
      return _tripList?.trips.length;
    } else {
      return 0;
    }
  }

/* Geters and Setters */
  Stream<bool>? get pleaseWaitStateStream => _pleaseWaitSubject.stream;
  Stream<List<Document>>? get pageDocumentsStream =>
      _pageDocumentsSubject!.stream;
  Stream<int>? get pageStateStream => _pageSubject!.stream;
  Stream<CommandData>? get commandStateStream => _commandSubject.stream;
  Stream<TripList>? get tripListStream => _tripListSubject?.stream;
  Stream<PrescriptionList>? get prescriptionListStream =>
      _prescriptionListSubject?.stream;
  Stream<AlertList>? get alertListStream => _alertListSubject?.stream;
}
