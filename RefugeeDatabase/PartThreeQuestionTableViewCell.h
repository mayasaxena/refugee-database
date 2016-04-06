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

- (void)tableViewCell:(PartThreeQuestionTableViewCell *)cell didChooseFirstAnswer:(BOOL) answer;
- (void)tableViewCell:(PartThreeQuestionTableViewCell *)cell didChooseSecondAnswer:(BOOL) answer;
- (void)tableViewCell:(PartThreeQuestionTableViewCell *)cell didChooseDuration:(NSTimeInterval)duration;

@end

@interface PartThreeQuestionTableViewCell : UITableViewCell

@property (weak, nonatomic) id<PartThreeQuestionTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *yesNoControl;

- (void)setupCellWithAnswers:(NSMutableDictionary *)answerDict;

@end
