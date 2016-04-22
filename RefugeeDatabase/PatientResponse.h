//
//  Answers.h
//  RefugeeDatabase
//
//  Created by Maya Saxena on 4/21/16.
//  Copyright © 2016 Workinonit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientResponse : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSMutableDictionary *partOneAnswers;
@property (strong, nonatomic) NSMutableDictionary *partTwoAnswers;
@property (strong, nonatomic) NSMutableDictionary *partThreeAnswers;
@property (strong, nonatomic) NSMutableDictionary *partFourAnswers;

+ (instancetype)sharedResponse;

- (BOOL)isComplete;
- (void)resetResponse;
- (void)loadResponseFromDatabaseDictionary:(NSDictionary *)dictionary;

@end
