//
//  MainScreenViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 4/20/16.
//  Copyright © 2016 Workinonit. All rights reserved.
//

#import "MainScreenViewController.h"
#import "PatientResponse.h"

@interface MainScreenViewController ()

@end

@implementation MainScreenViewController

- (IBAction)createButtonTapped:(UIButton *)sender {
    [[PatientResponse sharedResponse] resetResponse];
}


@end
