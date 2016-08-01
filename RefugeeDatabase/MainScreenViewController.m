//
//  MainScreenViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 4/20/16.
//  Copyright © 2016 Workinonit. All rights reserved.
//

#import "MainScreenViewController.h"
#import "PatientResponse.h"
#import "PatientDataUtil.h"
#import <AFNetworking/AFNetworking.h>
#import <SecureNSUserDefaults/NSUserDefaults+SecureAdditions.h>

@interface MainScreenViewController ()

@property (weak, nonatomic) IBOutlet UIButton *localPatientDataUploadButton;

@property (strong, nonatomic) NSDictionary *savedPatientInfo;

@end

@implementation MainScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setSecret:SecureNSUserDefaultsSecret];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.savedPatientInfo = [[NSUserDefaults standardUserDefaults] secretObjectForKey: NSUserDefaultsKey];
    self.localPatientDataUploadButton.hidden = self.savedPatientInfo ? NO : YES;
}

- (IBAction)createButtonTapped:(UIButton *)sender {
    [[PatientResponse sharedResponse] resetResponse];
}

- (IBAction)localPatientDataUploadButtonTapped:(UIButton *)sender {
    [self uploadLocalPatientInfo];
}

- (void)uploadLocalPatientInfo {
    
    if (!self.savedPatientInfo) {
        return;
    }
    
    for (NSDictionary *patientInfo in self.savedPatientInfo.allValues) {
        
        NSDictionary *params = @{ @"first_name" : patientInfo[@"firstName"],
                                  @"last_name" : patientInfo[@"lastName"],
                                  @"part1" : [PatientDataUtil stringFromNumberDictionary:patientInfo[@"Part1"]],
                                  @"part2" : [PatientDataUtil stringFromStringDictionary:patientInfo[@"Part2"]],
                                  @"part3" : [PatientDataUtil stringFromNestedDictionary:patientInfo[@"Part3"]],
                                  @"part4" : [PatientDataUtil stringFromNumberDictionary:patientInfo[@"Part4"]] };
        NSLog(@"%@", patientInfo);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"Maya" password:@"killingme"];
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [manager POST:@"https://desolate-bayou-99096.herokuapp.com/records/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:NSUserDefaultsKey];
            UIAlertController *alert = [PatientDataUtil alertWithMessage:@"Uploaded data to server!" andTitle:@"Success!"];
            [self presentViewController:alert animated:NO completion:^{
                [self viewWillAppear:NO];
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            UIAlertController *alert = [PatientDataUtil errorAlertWithMessage:@"Save operation failed, data could not be uploaded"];
            [self presentViewController:alert animated:NO completion:nil];
            
        }];
    }
}

@end
