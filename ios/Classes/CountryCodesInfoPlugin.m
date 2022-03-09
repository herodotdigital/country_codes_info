#import "CountryCodesInfoPlugin.h"
#if __has_include(<country_codes_info/country_codes_info-Swift.h>)
#import <country_codes_info/country_codes_info-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "country_codes_info-Swift.h"
#endif

@implementation CountryCodesInfoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCountryCodesInfoPlugin registerWithRegistrar:registrar];
}
@end
