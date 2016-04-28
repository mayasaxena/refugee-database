//
//  PatientLookupViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 4/22/16.
//  Copyright © 2016 Workinonit. All rights reserved.
//

#import "PatientLookupViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "PatientResponse.h"

static NSString * const PatientLookupSegueIdentifier = @"PatientLookupSegue";

@interface PatientLookupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UIView *searchingIndicatorView;

@end

@implementation PatientLookupViewController

- (IBAction)viewButtonTapped:(UIButton *)sender {
    
    self.searchingIndicatorView.hidden = NO;
    
    NSString *firstName = self.firstNameField.text;
    NSString *lastName = self.lastNameField.text;
    
    NSDictionary *params = @{ @"first_name" : firstName,
                              @"last_name" : lastName };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"Maya" password:@"killingme"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:@"https://desolate-bayou-99096.herokuapp.com/records/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject count] == 0) {
            self.searchingIndicatorView.hidden = YES;
            [self showErrorAlertWithMessage:@"Patient not found in database. Please enter another first and last name."];
        } else {
            self.searchingIndicatorView.hidden = YES;
            [[PatientResponse sharedResponse] resetResponse];
            [[PatientResponse sharedResponse] loadResponseFromDatabaseDictionary:responseObject[0]];
            [self performSegueWithIdentifier:PatientLookupSegueIdentifier sender:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *body = [[NSString alloc] initWithData:operation.request.HTTPBody encoding:4];
        NSLog(@"%@", body);
        self.searchingIndicatorView.hidden = YES;
        NSLog(@"Error: %@", error);
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:PatientLookupSegueIdentifier]) {
        
    }
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

@end
