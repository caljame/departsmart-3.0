import 'dart:ffi';

import '../constants/Embassies.dart';
import '../models/Embassy.dart';

class EmbassiesService {
  static List<String> getSuggestions(String query) {
    List<String> matches =
        List.from(EMBASSIES.map((embassy) => embassy.country));
    matches.retainWhere((s) => s.toLowerCase().startsWith(query.toLowerCase()));
    return matches;
  }

  static Embassy? getEmbassyForCountry(String country) {
    return EMBASSIES.firstWhere(
        (embassy) => embassy.country.toLowerCase() == country.toLowerCase(),
        orElse: () => Null as Embassy);
  }
}
