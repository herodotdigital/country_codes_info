import 'dart:ui';

import 'package:flutter/services.dart';

import 'countries.dart';

class CountryCodes {
  static const MethodChannel _channel = MethodChannel('country_codes_info');
  static Locale? _deviceLocale;
  static late Map<String, String> _localizedCountryNames;

  static List<Country> get allCountries => Countries.countries;

  static String? _resolveLocale(Locale? locale) {
    locale ??= _deviceLocale;
    assert(locale != null && locale.countryCode != null, '''
         Locale and country code cannot be null. If you are using an iOS simulator, please, make sure you go to region settings and select any country (even if it's already selected) because otherwise your country might be null.
         If you didn't provide one, please make sure you call init before using Country Details
        ''');
    return locale!.countryCode;
  }

  /// Inits the underlying plugin channel and fetch current's device locale to be ready
  /// to use synchronously when required.
  ///
  /// If you never plan to provide a `locale` directly, you must call and await this
  /// by calling `await CountryCodes.init();` before accessing any other method.
  ///
  /// Optionally, you may want to provide your [appLocale] to access localized
  /// country name (eg. if your app is in English, display Italy instead of Italia).
  ///
  /// Example:
  /// ```dart
  /// CountryCodes.init(Localizations.localeOf(context))
  /// ```
  /// This will default to device's language if none is provided.
  static Future<bool> init({Locale? appLocale}) async {
    final List<dynamic>? locale = List<dynamic>.from(
        await (_channel.invokeMethod('getLocale', appLocale?.toLanguageTag())));
    if (locale != null) {
      _deviceLocale = Locale(locale[0], locale[1]);
      _localizedCountryNames = Map.from(locale[2]);
    }
    return _deviceLocale != null;
  }

  /// Returns the current device's `Locale`
  /// Eg. `Locale('en','US')`
  static Locale? getDeviceLocale() {
    assert(_deviceLocale != null,
        'Please, make sure you call await init() before calling getDeviceLocale()');
    return _deviceLocale;
  }

  /// A list of dial codes for every country
  static List<String?> dialNumbers() {
    return allCountries.map((country) => country.dial).toList();
  }

  /// A list of numeric codes for every country
  static List<String?> numbers() {
    return allCountries.map((country) => country.num).toList();
  }

  /// A list of alpha 2 codes for every country
  static List<String?> allAlpha2() {
    return allCountries.map((country) => country.a2).toList();
  }

  /// A list of alpha 3 codes for every country
  static List<String?> allAlpha3() {
    return allCountries.map((country) => country.a3).toList();
  }

  /// A list of ITU codes for every country
  static List<String?> allITU() {
    return allCountries.map((country) => country.itu).toList();
  }

  /// A list of GEC codes for every country
  static List<String?> allGEC() {
    return allCountries.map((country) => country.gec).toList();
  }

  /// A list of IOC codes for every country
  static List<String?> allIOC() {
    return allCountries.map((country) => country.ioc).toList();
  }

  /// A list of FIFA codes for every country
  static List<String?> allFIFA() {
    return allCountries.map((country) => country.fifa).toList();
  }

  /// A list of DS codes for every country
  static List<String?> allDS() {
    return allCountries.map((country) => country.ds).toList();
  }

  /// A list of WMO codes for every country
  static List<String?> allWMO() {
    return allCountries.map((country) => country.wmo).toList();
  }

  /// A list of GAUL codes for every country
  static List<String?> allGAUL() {
    return allCountries.map((country) => country.gaul).toList();
  }

  /// A list of MARC codes for every country
  static List<String?> allMARC() {
    return allCountries.map((country) => country.marc).toList();
  }

  /// A list of country data for every country
  static List<Country?> countries() {
    return allCountries;
  }

  /// Returns the `CountryDetails` for the given [locale]. If not provided,
  /// the device's locale will be used instead.
  /// Have in mind that this is different than specifying `supportedLocale`s
  /// on your app.
  /// Exposed properties are the `name`, 'a2', 'a3', 'num', 'itu', 'gec', 'ioc', 'fifa', 'ds', 'wmo', 'gaul', 'marc', 'dial' and 'independent'
  ///
  /// Example:
  /// ```dart
  /// "name": "United States",
  /// "alpha2Code": "US",
  /// "dial_code": "+1",
  /// ```
  static Country detailsFromLocale({Locale? locale}) {
    String? code = _resolveLocale(locale);
    Country? country =
        allCountries.firstWhereSafe((country) => country.a2 == code);
    return Country.withLocalization(
        country!, _localizedCountryNames[country.a2]);
  }

  static Country? detailsFromAlpha({String? alpha2, String? alpha3}) {
    if (alpha2 == null && alpha3 == null) return null;
    Country? country = allCountries.firstWhereSafe(
        (country) => country.a2 == alpha2 || country.a3 == alpha3);
    return Country.withLocalization(
        country!, _localizedCountryNames[country.a2]);
  }

  /// Returns the ISO 3166-1 `alpha2Code` for the given [locale].
  /// If not provided, device's locale will be used instead.
  /// You can read more about ISO 3166-1 codes [here](https://en.wikipedia.org/wiki/ISO_3166-1)
  ///
  /// Example: (`US`, `PT`, etc.)
  static String? alpha2Code({Locale? locale}) {
    return _resolveLocale(locale);
  }

  /// Returns the ISO 3166-1 `alpha3code` for the given [locale].
  /// If not provided, device's locale will be used instead.
  /// You can read more about ISO 3166-1 codes [here](https://en.wikipedia.org/wiki/ISO_3166-1)
  ///
  /// Example: (`USA`, `PRT`, etc.)
  static String? alpha3Code({Locale? locale}) {
    String? code = _resolveLocale(locale);
    Country? country =
        allCountries.firstWhereSafe((country) => country.a2 == code);
    return country?.a3;
  }

  /// Returns the `dialCode` for the given [locale] or device's locale, if not provided.
  ///
  /// Example: (`1`, `351`, etc.)
  static String? dialCodeFromLocale({Locale? locale}) {
    String? code = _resolveLocale(locale);
    Country? country =
        allCountries.firstWhereSafe((country) => country.a2 == code);
    return country?.dial;
  }

  static String? dialCodeFromAlpha({String? alpha2, String? alpha3}) {
    if (alpha2 == null && alpha3 == null) return null;
    Country? country = allCountries.firstWhereSafe((country) =>
        country.a2 == (alpha2 ?? '') || country.a3 == (alpha3 ?? ''));
    return country?.dial;
  }

  /// Returns the extended `name` for the given [locale] or if not provided, device's locale or from alpha code.
  ///
  /// Example: (`United States`, `Portugal`, etc.)
  static String? nameFromLocale({Locale? locale}) {
    String? code = _resolveLocale(locale);
    Country? country =
        allCountries.firstWhereSafe((country) => country.a2 == code);
    return country?.name;
  }

  static String? nameFromAlpha({String? alpha2, String? alpha3}) {
    if (alpha2 == null && alpha3 == null) return null;
    Country? country = allCountries.firstWhereSafe((country) =>
        country.a2 == (alpha2 ?? '') || country.a3 == (alpha3 ?? ''));
    return country?.name;
  }

  /// Returns the 'fifa' code for the given [locale] or if not provided, device's locale or from alpha code.
  ///
  /// Example: (`USA`, `POR`, etc.)
  static String? fifaFromLocale({Locale? locale}) {
    String? code = _resolveLocale(locale);
    Country? country =
        allCountries.firstWhereSafe((country) => country.a2 == code);
    return country?.fifa;
  }

  static String? fifaFromAlpha({String? alpha2, String? alpha3}) {
    if (alpha2 == null && alpha3 == null) return null;
    Country? country = allCountries.firstWhereSafe((country) =>
        country.a2 == (alpha2 ?? '') || country.a3 == (alpha3 ?? ''));
    return country?.fifa;
  }

  /// Returns the numeric code for the given [locale] or if not provided, device's locale or from alpha code.
  ///
  /// Example: (`840`, `620`, etc.)
  static String? numericFromLocale({Locale? locale}) {
    String? code = _resolveLocale(locale);
    Country? country =
        allCountries.firstWhereSafe((country) => country.a2 == code);
    return country?.num;
  }

  static String? numericFromAlpha({String? alpha2, String? alpha3}) {
    if (alpha2 == null && alpha3 == null) return null;
    Country? country = allCountries.firstWhereSafe((country) =>
        country.a2 == (alpha2 ?? '') || country.a3 == (alpha3 ?? ''));
    return country?.num;
  }

  /// Returns the GEC code for the given [locale] or if not provided, device's locale or from alpha code.
  ///
  /// Example: (`US`, `PO`, etc.)
  static String? gecFromLocale({Locale? locale}) {
    String? code = _resolveLocale(locale);
    Country? country =
        allCountries.firstWhereSafe((country) => country.a2 == code);
    return country?.gec;
  }

  static String? gecFromAlpha({String? alpha2, String? alpha3}) {
    if (alpha2 == null && alpha3 == null) return null;
    Country? country = allCountries.firstWhereSafe((country) =>
        country.a2 == (alpha2 ?? '') || country.a3 == (alpha3 ?? ''));
    return country?.gec;
  }

  /// Returns the ITU code for the given [locale] or if not provided, device's locale or from alpha code.
  ///
  /// Example: (`USA`, `POR`, etc.)
  static String? ituFromLocale({Locale? locale}) {
    String? code = _resolveLocale(locale);
    Country? country =
        allCountries.firstWhereSafe((country) => country.a2 == code);
    return country?.itu;
  }

  static String? ituFromAlpha({String? alpha2, String? alpha3}) {
    if (alpha2 == null && alpha3 == null) return null;
    Country? country = allCountries.firstWhereSafe((country) =>
        country.a2 == (alpha2 ?? '') || country.a3 == (alpha3 ?? ''));
    return country?.itu;
  }

  /// Returns the IOC code for the given [locale] or if not provided, device's locale or from alpha code.
  ///
  /// Example: (`USA`, `POR`, etc.)
  static String? iocFromLocale({Locale? locale}) {
    String? code = _resolveLocale(locale);
    Country? country =
        allCountries.firstWhereSafe((country) => country.a2 == code);
    return country?.ioc;
  }

  static String? iocFromAlpha({String? alpha2, String? alpha3}) {
    if (alpha2 == null && alpha3 == null) return null;
    Country? country = allCountries.firstWhereSafe((country) =>
        country.a2 == (alpha2 ?? '') || country.a3 == (alpha3 ?? ''));
    return country?.ioc;
  }

  /// Returns the DS code for the given [locale] or if not provided, device's locale or from alpha code.
  ///
  /// Example: (`USA`, `P`, etc.)
  static String? dsFromLocale({Locale? locale}) {
    String? code = _resolveLocale(locale);
    Country? country =
        allCountries.firstWhereSafe((country) => country.a2 == code);
    return country?.ds;
  }

  static String? dsFromAlpha({String? alpha2, String? alpha3}) {
    if (alpha2 == null && alpha3 == null) return null;
    Country? country = allCountries.firstWhereSafe((country) =>
        country.a2 == (alpha2 ?? '') || country.a3 == (alpha3 ?? ''));
    return country?.ds;
  }

  /// Returns the WMO code for the given [locale] or if not provided, device's locale or from alpha code.
  ///
  /// Example: (`US`, `PO`, etc.)
  static String? wmoFromLocale({Locale? locale}) {
    String? code = _resolveLocale(locale);
    Country? country =
        allCountries.firstWhereSafe((country) => country.a2 == code);
    return country?.wmo;
  }

  static String? wmoFromAlpha({String? alpha2, String? alpha3}) {
    if (alpha2 == null && alpha3 == null) return null;
    Country? country = allCountries.firstWhereSafe((country) =>
        country.a2 == (alpha2 ?? '') || country.a3 == (alpha3 ?? ''));
    return country?.wmo;
  }

  /// Returns the GAUL code for the given [locale] or if not provided, device's locale or from alpha code.
  ///
  /// Example: (`259`, `199`, etc.)
  static String? gaulFromLocale({Locale? locale}) {
    String? code = _resolveLocale(locale);
    Country? country =
        allCountries.firstWhereSafe((country) => country.a2 == code);
    return country?.gaul;
  }

  static String? gaulFromAlpha({String? alpha2, String? alpha3}) {
    if (alpha2 == null && alpha3 == null) return null;
    Country? country = allCountries.firstWhereSafe((country) =>
        country.a2 == (alpha2 ?? '') || country.a3 == (alpha3 ?? ''));
    return country?.gaul;
  }

  /// Returns the MARC code for the given [locale] or if not provided, device's locale or from alpha code.
  ///
  /// Example: (`xxu`, `po`, etc.)
  static String? marcFromLocale({Locale? locale}) {
    String? code = _resolveLocale(locale);
    Country? country =
        allCountries.firstWhereSafe((country) => country.a2 == code);
    return country?.marc;
  }

  static String? marcFromAlpha({String? alpha2, String? alpha3}) {
    if (alpha2 == null && alpha3 == null) return null;
    Country? country = allCountries.firstWhereSafe((country) =>
        country.a2 == (alpha2 ?? '') || country.a3 == (alpha3 ?? ''));
    return country?.marc;
  }

  /// Adds given [country] to [Countries.countries] for further usage
  static void addCountries({required List<Country> newCountries}) =>
      allCountries.addAll(newCountries);
}

extension SafeList<Element> on List<Element> {
  Element? firstWhereSafe(bool Function(Element) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}
