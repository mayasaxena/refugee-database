//
//  PartFourQuestionTableViewCell.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 12/4/15.
//  Copyright (c) 2015 Workinonit. All rights reserved.
//

#import "PartFourQuestionTableViewCell.h"

@interface PartFourQuestionTableViewCell ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *frequencySegmentedControl;

@end

@implementation PartFourQuestionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self resetCell];
}


- (IBAction)frequencyChanged:(UISegmentedControl *)sender {
    
}

- (void)setupCellWithAnswer:(int)answer {
    self.frequencySegmentedControl.selectedSegmentIndex = answer;
}

- (void)resetCell {
    self.frequencySegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    self.frequencySegmentedControl.tintColor = [UIColor darkGrayColor];
}

@end
