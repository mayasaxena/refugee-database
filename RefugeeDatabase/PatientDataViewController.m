//
//  PartTwoTestViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 12/6/15.
//  Copyright (c) 2015 Workinonit. All rights reserved.
//

#import "PatientDataViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "PatientResponse.h"

@interface PatientDataViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UIButton *sendDataButton;
@property (nonatomic) UITextField* currentTextField;

@end

@implementation PatientDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.sendDataButton.titleLabel.text = @"Send data";
}

- (IBAction)sendButtonTapped:(UIButton *)sender {
    if (self.currentTextField) {
        [self.currentTextField resignFirstResponder];
    }
    
    PatientResponse *sharedResponse = [PatientResponse sharedResponse];
    if ([sharedResponse isComplete]) {
        [self savePatientResponse:sharedResponse];
    } else {
        [self showErrorAlert];
    }
}

- (void)savePatientResponse:(PatientResponse *)response {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *firstName = response.firstName;
    NSString *lastName = response.lastName;
    NSDictionary *part1 = [response.partOneAnswers copy];
    NSDictionary *part2 = [response.partTwoAnswers copy];
    NSDictionary *part3 = [response.partThreeAnswers copy];
    NSDictionary *part4 = [response.partFourAnswers copy];
    
    NSDictionary *userInfo = @{ @"firstName" : firstName,
                                @"lastName" : lastName,
                                @"Part1" : part1,
                                @"Part2" : part2,
                                @"Part3" : part3,
                                @"Part4" : part4 };
    
    NSUInteger hash = [[firstName stringByAppendingString:lastName] hash];
    [defaults setObject:userInfo forKey:[NSString stringWithFormat:@"%lu", (unsigned long)hash]];
    
    NSDictionary *params = @{ @"first_name" : firstName,
                              @"last_name" : lastName,
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

- (void) showErrorAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                   message:@"Please go through all parts of questionnaire and fill in first and last name."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:nil];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:NO completion:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.firstNameField]) {
        [PatientResponse sharedResponse].firstName = textField.text;
        self.currentTextField = nil;
    } else if ([textField isEqual:self.lastNameField]) {
        [PatientResponse sharedResponse].lastName = textField.text;
        self.currentTextField = nil;
    }
}

@end
