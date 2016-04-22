//
//  PartTwoTableViewCell.h
//  RefugeeDatabase
//
//  Created by Maya Saxena on 2/22/16.
//  Copyright (c) 2016 Workinonit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PartTwoTableViewCell;

@protocol PartTwoTableViewCellDelegate

- (void)tableViewCell:(PartTwoTableViewCell *)cell didChangeAnswer:(NSString *)answer;

@end

@interface PartTwoTableViewCell : UITableViewCell

@property (weak, nonatomic) id<PartTwoTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;

@end
