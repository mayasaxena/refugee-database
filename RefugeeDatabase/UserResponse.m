//
//  Answers.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 4/21/16.
//  Copyright © 2016 Workinonit. All rights reserved.
//

#import "UserResponse.h"

@implementation UserResponse

+ (instancetype)sharedAnswers {
    static dispatch_once_t onceToken;
    static UserResponse *sharedAnswers = nil;
    dispatch_once(&onceToken, ^{
        sharedAnswers = [UserResponse new];
    });
    return sharedAnswers;
}

@end
