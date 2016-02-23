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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *firstName = [self.firstNameField.text isEqualToString:@""] ? @"None" : self.firstNameField.text;
    NSString *lastName = [self.lastNameField.text isEqualToString:@""] ? @"None" : self.lastNameField.text;
    NSDictionary *params = @{@"user" : @"/api/v1/user/1/",
                             @"first_name" : firstName,
                             @"last_name" : lastName,
                             @"id" : @9};
    
    [manager POST:@"https://pure-harbor-9891.herokuapp.com/api/v1/record/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.sendDataButton.titleLabel.text = @"Data sent!";
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
}


@end
