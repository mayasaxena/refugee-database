//
//  Answers.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 4/21/16.
//  Copyright © 2016 Workinonit. All rights reserved.
//

#import "PatientResponse.h"

@implementation PatientResponse

+ (instancetype)sharedResponse {
    static dispatch_once_t onceToken;
    static PatientResponse *sharedResponse = nil;
    dispatch_once(&onceToken, ^{
        sharedResponse = [PatientResponse new];
    });
    return sharedResponse;
}

- (BOOL)isComplete {
    return (self.firstName &&
            self.lastName &&
            self.partOneAnswers &&
            self.partTwoAnswers &&
            self.partThreeAnswers &&
            self.partFourAnswers);
}

- (void)resetResponse {
    self.firstName = nil;
    self.lastName = nil;
    self.partOneAnswers = nil;
    self.partTwoAnswers = nil;
    self.partThreeAnswers = nil;
    self.partFourAnswers = nil;
}

- (void)loadResponseFromDatabaseDictionary:(NSDictionary *)dictionary {
    self.firstName = dictionary[@"first_name"];
    self.lastName = dictionary[@"last_name"];
    
    [self readInPartOneFromString:dictionary[@"part1"]];
//    NSString *partTwo = dictionary[@"part2"];
//    NSString *partThree = dictionary[@"part3"];
//    NSString *partFour = dictionary[@"part4"];

}

- (void)readInPartOneFromString:(NSString *)partOneString {
    //TODO: remove hardcoded delimiter
    
    NSMutableDictionary *partOneAnswerDict = [NSMutableDictionary new];
    
    NSArray *partOneAnswerArray = [partOneString componentsSeparatedByString:@","];
    int i = 0;
    for (NSString *answer in partOneAnswerArray) {
        partOneAnswerDict[[@(i) stringValue]] = @([answer intValue]);
        i++;
    }
    
    NSLog(@"%@", partOneAnswerDict);
    self.partOneAnswers = partOneAnswerDict;
}

@end
