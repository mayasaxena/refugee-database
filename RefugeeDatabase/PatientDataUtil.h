//
//  PatientDataUtil.h
//  RefugeeDatabase
//
//  Created by Maya Saxena on 7/31/16.
//  Copyright © 2016 Workinonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PatientDataUtil : NSObject

+ (NSString *)stringFromNumberDictionary:(NSDictionary *)dictionary;
+ (NSString *)stringFromNestedDictionary:(NSDictionary *)dictionary;
+ (NSString *)stringFromStringDictionary:(NSDictionary *)dictionary;
+ (NSArray *)getSortedKeysFromDictionary:(NSDictionary *)dictionary;
+ (UIAlertController *)alertWithMessage:(NSString *)message andTitle:(NSString *)title;
+ (UIAlertController *)errorAlertWithMessage:(NSString *)message;

@end
