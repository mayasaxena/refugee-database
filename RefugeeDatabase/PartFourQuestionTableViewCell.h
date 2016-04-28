//
//  PartFourQuestionTableViewCell.h
//  RefugeeDatabase
//
//  Created by Maya Saxena on 12/4/15.
//  Copyright (c) 2015 Workinonit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PartFourQuestionTableViewCell;

@protocol PartFourQuestionTableViewCellDelegate

- (void)tableViewCell:(PartFourQuestionTableViewCell *)cell didChooseAnswer:(NSInteger)answer;

@end

@interface PartFourQuestionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) id<PartFourQuestionTableViewCellDelegate> delegate;

- (void)setupCellWithAnswer:(int)answer;

@end
