//
//  PartTwoTableViewCell.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 2/22/16.
//  Copyright (c) 2016 Workinonit. All rights reserved.
//

#import "PartTwoTableViewCell.h"

@interface PartTwoTableViewCell () <UITextViewDelegate>

@end

@implementation PartTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.questionTextView.delegate = self;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.delegate tableViewCell:self didChangeAnswer:textView.text];
}

@end
