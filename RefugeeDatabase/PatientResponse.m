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


@end
