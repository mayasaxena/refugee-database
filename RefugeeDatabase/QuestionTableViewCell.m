//
//  QuestionTableViewCell.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 12/4/15.
//  Copyright (c) 2015 Workinonit. All rights reserved.
//

#import "QuestionTableViewCell.h"


@interface QuestionTableViewCell ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *yesNoControl;

@end

@implementation QuestionTableViewCell

- (void)awakeFromNib {
    self.yesNoControl.selectedSegmentIndex = UISegmentedControlNoSegment;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)optionSelectedChanged:(UISegmentedControl *)sender {
    if (sender == self.yesNoControl) {
        if (sender.selectedSegmentIndex == 0) {
            sender.tintColor = [UIColor colorWithRed:0.18 green:0.80 blue:0.44 alpha:1.0];
        } else if (sender.selectedSegmentIndex == 1) {
            sender.tintColor = [UIColor colorWithRed:0.91 green:0.30 blue:0.24 alpha:1.0];
        }
    }
}

@end
