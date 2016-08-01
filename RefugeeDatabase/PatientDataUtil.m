//
//  PatientDataUtil.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 7/31/16.
//  Copyright © 2016 Workinonit. All rights reserved.
//

#import "PatientDataUtil.h"

@implementation PatientDataUtil

+ (NSString *)stringFromNumberDictionary:(NSDictionary *)dictionary {
    NSString *valueString = [NSString new];
    NSArray *sortedKeys = [self getSortedKeysFromDictionary:dictionary];
    for (NSString *key in sortedKeys) {
        NSNumber *value = dictionary[key];
        valueString = [valueString stringByAppendingString:[value stringValue]];
        valueString = [valueString stringByAppendingString:@","];
    }
    return valueString;
}

+ (NSString *)stringFromNestedDictionary:(NSDictionary *)dictionary {
    NSString *valueString = [NSString new];
    NSArray *sortedKeys = [self getSortedKeysFromDictionary:dictionary];
    for (NSString *key in sortedKeys) {
        NSDictionary *valueDict = dictionary[key];
        NSNumber *firstAnswer = valueDict[@"firstAnswer"];
        NSNumber *secondAnswer = valueDict[@"secondAnswer"];
        NSNumber *duration = valueDict[@"duration"];
        valueString = [valueString stringByAppendingString:[firstAnswer stringValue]];
        valueString = [valueString stringByAppendingString:@":"];
        valueString = [valueString stringByAppendingString:[secondAnswer stringValue]];
        valueString = [valueString stringByAppendingString:@":"];
        valueString = [valueString stringByAppendingString:[duration stringValue]];
        valueString = [valueString stringByAppendingString:@","];
    }
    return valueString;
}

+ (NSString *)stringFromStringDictionary:(NSDictionary *)dictionary {
    NSString *valueString = [NSString new];
    NSArray *sortedKeys = [self getSortedKeysFromDictionary:dictionary];
    for (NSString *key in sortedKeys) {
        NSString *value = dictionary[key];
        valueString = [valueString stringByAppendingString:value];
        valueString = [valueString stringByAppendingString:@","];
    }
    return valueString;
}

+ (NSArray *)getSortedKeysFromDictionary:(NSDictionary *)dictionary {
    NSArray * sortedKeys = [[dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    return sortedKeys;
}

+ (UIAlertController *)alertWithMessage:(NSString *)message andTitle:(NSString *)title {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:nil];
    
    [alert addAction:okAction];
    return alert;
}


+ (UIAlertController *)errorAlertWithMessage:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:nil];
    
    [alert addAction:okAction];
    return alert;
}

@end
