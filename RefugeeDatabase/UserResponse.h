//
//  Answers.h
//  RefugeeDatabase
//
//  Created by Maya Saxena on 4/21/16.
//  Copyright © 2016 Workinonit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserResponse : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSMutableDictionary *partOneAnswers;
@property (strong, nonatomic) NSMutableDictionary *partTwoAnswers;
@property (strong, nonatomic) NSMutableDictionary *partThreeAnswers;
@property (strong, nonatomic) NSMutableDictionary *partFourAnswers;

+ (instancetype)sharedAnswers;

@end
