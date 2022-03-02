A Flutter package to get country information in various standards. Data was gathered from [http://www.statoids.com/wab.html](http://www.statoids.com/wab.html)

## Features
* [x] Names, ISO 3166-1 alpha-2. alpha-3, numeric, ITU, GEC, IOC, FIFA, DS, WMO, GAUL, MARC and dial country codes
* [x] Country independence status based on the CIA World Factbook
* [x] Adding own countries


## Usage
There are two main ways to use this package.

### 1. Default by using device region
This will allow you to fetch the region of the underlying platform and display the data accordingly. Very handy if you use along with the `DialCodeFormatter` to provide integration with dial codes formatter, on phone `TextFormField`s in a `Form`, for example.

Assuming an **en-US** region based revice.
```
await CountryCodes.init(); // Optionally, you may provide a `Locale` to get countrie's localizadName

final Locale deviceLocale = CountryCodes.getDeviceLocale();
print(deviceLocale.languageCode); // Displays en
print(deviceLocale.countryCode); // Displays US

final Country details = CountryCodes.detailsForLocale();
print(details.name); // Displays the extended name, for example United States.
print(details.localizedName); // Displays the extended name based on device's language (or other, if provided on init)
print(details.a2); // Displays alpha2Code, for example US.
print(details.a3); // Displays alpha3Code, for example USA.
print(details.dial); // Displays the dial code, for example 1.
print(details.fifa); // Displays FIFA code, for example USA.
print(details.numeric); // Displays numeric code, for example 840.
print(details.gec); // Displays GEC code, for example US.
print(details.itu); // Displays ITU code, for example USA.
print(details.ioc); // Displays IOC code, for example USA.
print(details.ds); // Displays DS code, for example USA.
print(details.wmo); // Displays WMO code, for example US.
print(details.gaul); // Displays GAUL code, for example 259.
print(details.marc); // Displays MARC code, for example xxu.
```
### 2. Use a custom `Locale`
This will use the provided `Locale`, which may not be related to the device's region but instead to the app supported languages.

For example, if your device is on US region but the app only supports PT, you'll get the following:
```
final Country details = CountryCodes.detailsForLocale(Localization.localeOf(context));

print(details.name); // Displays the extended name, for example Portugal.
print(details.a2); // Displays alpha2Code, for example PT.
print(details.a3); // Displays alpha3Code, for example PRT.
print(details.dial); // Displays the dial code, for example 620.
print(details.fifa); // Displays FIFA code, for example POR.
print(details.numeric); // Displays numeric code, for example 840.
print(details.gec); // Displays GEC code, for example PO.
print(details.itu); // Displays ITU code, for example POR.
print(details.ioc); // Displays IOC code, for example POR.
print(details.ds); // Displays DS code, for example P.
print(details.wmo); // Displays WMO code, for example PO.
print(details.gaul); // Displays GAUL code, for example 199.
print(details.marc); // Displays MARC code, for example po.
```

## Credit

A special thank you to miguelruivo.com for his [country_codes](https://pub.dev/packages/country_codes) package. This package have awesome translate solution. And thanks to ersel for JS module [Country Code Info](https://github.com/ersel/country-code-info). This package almost every country for this module.