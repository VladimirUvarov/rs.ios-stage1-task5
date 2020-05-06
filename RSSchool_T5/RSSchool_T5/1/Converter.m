#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@implementation PNConverter

- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    NSDictionary *data = @{
        @"373": @[@"MD", @8],
        @"374": @[@"AM", @8],
        @"375": @[@"BY", @9],
        @"380": @[@"UA", @9],
        @"992": @[@"TJ", @9],
        @"993": @[@"TM", @8],
        @"994": @[@"AZ", @9],
        @"996": @[@"KG", @9],
        @"998": @[@"UZ", @9],
        @"7": @[@"RU", @10]
    };
    NSString * res = @"";
    int len = 9;
    NSString * cou = @"";
    NSMutableString * source = [string mutableCopy];
    if ([[source substringWithRange:NSMakeRange(0,1)] isEqualToString: @"+"]) {
        [source replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    for (int i = 0; i < data.count;i++ ) {
        NSString * prefix = data.allKeys[i];
        if ([source hasPrefix:prefix]) {
            cou = [data valueForKey:prefix][0];
            len = [[data valueForKey:prefix][1] intValue];
            res = [NSMutableString stringWithFormat:@"+%@", prefix];
            [source replaceCharactersInRange:NSMakeRange(0, [prefix length]) withString:@""];
            if (len == 8) {
                res = addS1 (source, res, 2);
                res = addS2(source, res, 3, @" ");
                res = addS2(source, res, 3, @"-");
            } else if (len == 9) {
                res = addS1 (source, res, 2);
                res = addS2(source, res, 3, @" ");
                res = addS2(source, res, 2, @"-");
                res = addS2(source, res, 2, @"-");
            } else if (len == 10) {
                if ([source length] > 0 && [[source substringWithRange:NSMakeRange(0,1)] isEqualToString: @"7"]) {
                    cou = @"KZ";
                }
                res = addS1 (source, res, 3);
                res = addS2(source, res, 3, @" ");
                res = addS2(source, res, 2, @"-");
                res = addS2(source, res, 2, @"-");
            }
            break;
        }
    }
    if ([res isEqualToString: @""]) {
        if ([source length] > 12) {
            source = [[source substringWithRange:NSMakeRange(0, 12)] mutableCopy];
        }
        res = [NSString stringWithFormat:@"+%@", source];
    }
    return @{KeyPhoneNumber: res,
             KeyCountry: cou};
}

NSString * addS1(NSMutableString * source,NSString * dest, int q) {
    if ([source length] > 0) {
        NSString * prefix = [source substringWithRange:NSMakeRange(0, MIN(q, [source length]))];
        dest = [NSMutableString stringWithFormat:@"%@ (%@%@", dest, prefix,[source length] > q ? @")" : @"" ];
        [source replaceCharactersInRange:NSMakeRange(0, [prefix length]) withString:@""];
    }
    return dest;
}

NSString * addS2(NSMutableString * source,NSString * dest, int q, NSString * p) {
    if ([source length] > 0) {
        NSString * prefix = [source substringWithRange:NSMakeRange(0, MIN(q, [source length]))];
        dest = [dest stringByAppendingFormat:@"%@%@", p, prefix];
        [source replaceCharactersInRange:NSMakeRange(0, [prefix length]) withString:@""];
    }
    return dest;
}

@end
