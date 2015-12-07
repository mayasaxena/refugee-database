//
//  PartTwoTestViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 12/6/15.
//  Copyright (c) 2015 Workinonit. All rights reserved.
//

#import "PartTwoTestViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface PartTwoTestViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;

@property (weak, nonatomic) IBOutlet UITextField *lastNameField;

@end

@implementation PartTwoTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendButtonTapped:(UIButton *)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *firstName = [self.firstNameField.text isEqualToString:@""] ? @"None" : self.firstNameField.text;
    NSString *lastName = [self.lastNameField.text isEqualToString:@""] ? @"None" : self.lastNameField.text;
    NSDictionary *params = @{@"user" : @"/api/v1/user/1/",
                             @"first_name" : firstName,
                             @"last_name" : lastName};
    
    [manager POST:@"https://pure-harbor-9891.herokuapp.com/api/v1/record/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
}


@end
