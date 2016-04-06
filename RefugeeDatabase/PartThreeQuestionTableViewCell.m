//
//  PartThreeQuestionTableViewCell.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 3/9/16.
//  Copyright (c) 2016 Workinonit. All rights reserved.
//

#import "PartThreeQuestionTableViewCell.h"

static const int PartThreeQuestionTableViewCellTextFieldCharacterLimit = 2;


@interface PartThreeQuestionTableViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *subQuestionOneView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *subQuestionOneControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subQuestionViewOneHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *subQuestionTwoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subQuestionViewTwoHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *subQuestionTwoHoursTextField;
@property (weak, nonatomic) IBOutlet UITextField *subQuestionTwoMinutesTextField;
@property (nonatomic, assign) int expandedHeight;

@end

@implementation PartThreeQuestionTableViewCell

- (void)awakeFromNib {
    [self resetCell];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self resetCell];
}

- (IBAction)optionSelectedChanged:(UISegmentedControl *)sender {
    BOOL answer = NO;
    CGFloat newHeight = 0;
    if (sender.selectedSegmentIndex == 0) {
        answer = YES;
        [self selectYes:sender];
        newHeight = self.expandedHeight;
    } else if (sender.selectedSegmentIndex == 1) {
        answer = NO;
        [self selectNo:sender];
        newHeight = 0;
    }
    
    if ([sender isEqual:self.yesNoControl]) {
        self.subQuestionViewOneHeightConstraint.constant = newHeight;
        [self.delegate tableViewCell:self didChooseFirstAnswer:answer];
    } else if ([sender isEqual:self.subQuestionOneControl]) {
        self.subQuestionViewTwoHeightConstraint.constant = newHeight;
        [self.delegate tableViewCell:self didChooseSecondAnswer:answer];
    }
}

- (IBAction)timeChanged:(UIDatePicker *)sender {
}


- (void)setupCellWithAnswers:(NSMutableDictionary *)answerDict {
    
    NSNumber *firstAnswer = answerDict[@"firstAnswer"];
    NSNumber *secondAnswer = answerDict[@"secondAnswer"];
    NSNumber *duration = answerDict[@"duration"];
    
    if (firstAnswer) {
        if ([firstAnswer boolValue]) {
            [self selectYes:self.yesNoControl];
        } else {
            [self selectNo:self.yesNoControl];
        }
        
        if (secondAnswer) {
            if ([secondAnswer boolValue]) {
                [self selectYes:self.subQuestionOneControl];
            } else {
                [self selectNo:self.subQuestionOneControl];
            }
            
            if (duration) {
                //TODO
            }
        } else {
            [self resetSegmentedControl:self.subQuestionOneControl];
        }
    } else {
        [self resetSegmentedControl:self.yesNoControl];
    }
}

- (void)selectYes:(UISegmentedControl *)sender {
    if (sender) {
        sender.selectedSegmentIndex = 0;
        sender.tintColor = [UIColor colorWithRed:0.18 green:0.80 blue:0.44 alpha:1.0];
    }
}

- (void)selectNo:(UISegmentedControl *)sender {
    sender.selectedSegmentIndex = 1;
    sender.tintColor = [UIColor colorWithRed:0.91 green:0.30 blue:0.24 alpha:1.0];
}

- (void)resetCell {
    self.subQuestionTwoHoursTextField.delegate = self;
    self.subQuestionTwoMinutesTextField.delegate = self;
    [self resetSegmentedControl:self.yesNoControl];
    [self resetSegmentedControl:self.subQuestionOneControl];
    [self setExpandedHeight];
}

- (void)resetSegmentedControl:(UISegmentedControl *)control {
    control.selectedSegmentIndex = UISegmentedControlNoSegment;
    control.tintColor = [UIColor darkGrayColor];
}

- (void)setExpandedHeight {
//    if (self.isQuestionFive) {
//        self.expandedHeight = 100;
//    } else {
        self.expandedHeight = 60;
//    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string  {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSCharacterSet *cs = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return (([string isEqualToString:filtered])&&(newLength <= PartThreeQuestionTableViewCellTextFieldCharacterLimit));
}


@end
