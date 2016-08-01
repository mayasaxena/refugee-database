//
//  PartTwoTestViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 12/6/15.
//  Copyright (c) 2015 Workinonit. All rights reserved.
//

#import "PatientDataViewController.h"
#import "PatientResponse.h"
#import <AFNetworking/AFNetworking.h>
#import <SecureNSUserDefaults/NSUserDefaults+SecureAdditions.h>
#import "PatientDataUtil.h"

@interface PatientDataViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UIButton *sendDataButton;
@property (weak, nonatomic) IBOutlet UIView *savingIndicatorView;

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
        [self showErrorAlertWithMessage:@"Please go through all parts of questionnaire and fill in first and last name."];
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
    
    NSDictionary *params = @{ @"first_name" : firstName,
                              @"last_name" : lastName,
                              @"part1" : [PatientDataUtil stringFromNumberDictionary:part1],
                              @"part2" : [PatientDataUtil stringFromStringDictionary:part2],
                              @"part3" : [PatientDataUtil stringFromNestedDictionary:part3],
                              @"part4" : [PatientDataUtil stringFromNumberDictionary:part4] };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"Maya" password:@"killingme"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    self.savingIndicatorView.hidden = NO;
    
    [manager POST:@"https://desolate-bayou-99096.herokuapp.com/records/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.savingIndicatorView.hidden = YES;
        self.sendDataButton.titleLabel.text = @"Data sent!";
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        self.savingIndicatorView.hidden = YES;
        [self showErrorAlertWithMessage:@"Save operation failed, saving data locally"];
        
        // Save user info locally
        NSDictionary *userInfo = @{ @"firstName" : firstName,
                                    @"lastName" : lastName,
                                    @"Part1" : part1,
                                    @"Part2" : part2,
                                    @"Part3" : part3,
                                    @"Part4" : part4 };
        
        NSMutableDictionary *patientInfo = [[defaults secretObjectForKey:NSUserDefaultsKey] mutableCopy];
        
        if (!patientInfo) {
            patientInfo = [[NSMutableDictionary alloc] init];
        }
        
        NSUInteger hash = [[firstName stringByAppendingString:lastName] hash];
        patientInfo[@(hash)] = userInfo;
        
        [defaults setSecretObject:[patientInfo copy]
                           forKey:NSUserDefaultsKey];

    }];
}



- (void) showErrorAlertWithMessage:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                   message:message
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
