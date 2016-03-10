//
//  QuestionTableViewCell.h
//  RefugeeDatabase
//
//  Created by Maya Saxena on 12/4/15.
//  Copyright (c) 2015 Workinonit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PartOneQuestionTableViewCell;

@protocol PartOneQuestionTableViewCellDelegate

- (void)tableViewCell:(PartOneQuestionTableViewCell *)cell didChooseAnswer:(BOOL) answer;

@end

@interface PartOneQuestionTableViewCell : UITableViewCell

@property (weak, nonatomic) id<PartOneQuestionTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *yesNoControl;

- (void)selectYes;
- (void)selectNo;

@end
