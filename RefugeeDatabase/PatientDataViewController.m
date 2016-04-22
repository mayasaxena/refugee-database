//
//  PartTwoTestViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 12/6/15.
//  Copyright (c) 2015 Workinonit. All rights reserved.
//

#import "PatientDataViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface PatientDataViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UIButton *sendDataButton;

@end

@implementation PatientDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.sendDataButton.titleLabel.text = @"Send data";
}

- (IBAction)sendButtonTapped:(UIButton *)sender {
    NSString *firstName = [self.firstNameField.text isEqualToString:@""] ? @"None" : self.firstNameField.text;
    NSString *lastName = [self.lastNameField.text isEqualToString:@""] ? @"None" : self.lastNameField.text;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *part1 = [defaults dictionaryForKey:@"Part1"];
    NSDictionary *part2 = [defaults dictionaryForKey:@"Part2"];
    NSDictionary *part3 = [defaults dictionaryForKey:@"Part3"];
    NSDictionary *part4 = [defaults dictionaryForKey:@"Part4"];
    
    NSDictionary *userInfo = @{ @"firstName" : firstName,
                                @"lastName" : lastName,
                                @"Part1" : part1,
                                @"Part2" : part2,
                                @"Part3" : part3,
                                @"Part4" : part4 };

    NSUInteger hash = [[firstName stringByAppendingString:lastName] hash];
    //    [defaults setObject:userInfo forKey:[NSString stringWithFormat:@"%lu", (unsigned long)hash]];
    
    NSDictionary *params = @{ @"first_name" : firstName,
                                        @"last_name" : firstName,
                                        @"part1" : [self stringFromNumberDictionary:part1],
                                        @"part2" : [self stringFromStringDictionary:part2],
                                        @"part3" : [self stringFromNestedDictionary:part3],
                                        @"part4" : [self stringFromNumberDictionary:part4] };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"Maya" password:@"killingme"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:@"https://desolate-bayou-99096.herokuapp.com/records/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.sendDataButton.titleLabel.text = @"Data sent!";
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *body = [[NSString alloc] initWithData:operation.request.HTTPBody encoding:4];
        NSLog(@"%@", body);
        NSLog(@"Error: %@", error);
        
    }];
}

- (NSString *)stringFromNumberDictionary:(NSDictionary *)dictionary {
    NSString *valueString = [NSString new];
    for (NSNumber *value in [dictionary allValues])
    {
        valueString = [valueString stringByAppendingString:[value stringValue]];
        valueString = [valueString stringByAppendingString:@","];
    }
    return valueString;
}

- (NSString *)stringFromNestedDictionary:(NSDictionary *)dictionary {
    NSString *valueString = [NSString new];
    for (NSDictionary *valueDict in [dictionary allValues])
    {
        for (NSNumber *value in [valueDict allValues])
        {
            valueString = [valueString stringByAppendingString:[value stringValue]];
            valueString = [valueString stringByAppendingString:@","];
        }
    }
    return valueString;
}

- (NSString *)stringFromStringDictionary:(NSDictionary *)dictionary {
    NSString *valueString = [NSString new];
    for (NSString *value in [dictionary allValues])
    {
        valueString = [valueString stringByAppendingString:value];
        valueString = [valueString stringByAppendingString:@","];
    }
    return valueString;
}

@end
