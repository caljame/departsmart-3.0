import '../constants/Countries.dart';

class CountriesService {
  static List<String> getSuggestions(String query) {
    List<String> matches = List.from(COUNTRIES.map((country) => country.name));
    matches.retainWhere((s) => s.toLowerCase().startsWith(query.toLowerCase()));
    return matches;
  }

  static String getCountryCode(String country) {
    if ((country == null) || (country.isEmpty)) {
      return "";
    }
    String countryLc = country.toLowerCase();
    return COUNTRIES
        .firstWhere((c) => ((c.name.toLowerCase() == countryLc) ||
            (c.aka != null &&
                c.aka.isNotEmpty &&
                c.aka.toLowerCase() == countryLc)))
        .code;
  }
}
