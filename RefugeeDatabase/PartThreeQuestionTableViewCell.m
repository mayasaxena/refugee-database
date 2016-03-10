//
//  PartThreeQuestionTableViewCell.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 3/9/16.
//  Copyright (c) 2016 Workinonit. All rights reserved.
//

#import "PartThreeQuestionTableViewCell.h"

@implementation PartThreeQuestionTableViewCell

- (void)awakeFromNib {
    [self resetCell];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self resetCell];
}

- (IBAction)optionSelectedChanged:(UISegmentedControl *)sender {
    BOOL answer;
    if (sender == self.yesNoControl) {
        if (sender.selectedSegmentIndex == 0) {
            answer = YES;
            [self selectYes];
        } else if (sender.selectedSegmentIndex == 1) {
            answer = NO;
            [self selectNo];
        }
        [self.delegate tableViewCell:self didChooseAnswer:answer];
    }
}

- (void)selectYes {
    self.yesNoControl.selectedSegmentIndex = 0;
    self.yesNoControl.tintColor = [UIColor colorWithRed:0.18 green:0.80 blue:0.44 alpha:1.0];
}

- (void)selectNo {
    self.yesNoControl.selectedSegmentIndex = 1;
    self.yesNoControl.tintColor = [UIColor colorWithRed:0.91 green:0.30 blue:0.24 alpha:1.0];
}

- (void)resetCell {
    self.yesNoControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    self.yesNoControl.tintColor = [UIColor darkGrayColor];
}


@end
