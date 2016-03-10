//
//  PartThreeQuestionTableViewCell.h
//  RefugeeDatabase
//
//  Created by Maya Saxena on 3/9/16.
//  Copyright (c) 2016 Workinonit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PartThreeQuestionTableViewCell;

@protocol PartThreeQuestionTableViewCellDelegate

- (void)tableViewCell:(PartThreeQuestionTableViewCell *)cell didChooseAnswer:(BOOL) answer;

@end

@interface PartThreeQuestionTableViewCell : UITableViewCell

@property (weak, nonatomic) id<PartThreeQuestionTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *yesNoControl;

- (void)selectYes;
- (void)selectNo;

@end
