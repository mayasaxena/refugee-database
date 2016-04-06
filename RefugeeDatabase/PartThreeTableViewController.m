//
//  PartThreeTableViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 3/9/16.
//  Copyright (c) 2016 Workinonit. All rights reserved.
//

#import "PartThreeTableViewController.h"

#import "PartThreeQuestionTableViewCell.h"

static NSString * const PartThreeGeneralQuestionTableViewCellIdentifier = @"PartThreeQuestionTableViewCell";
static NSString * const PartThreeQuestionFiveTableViewCellIdentifier = @"PartThreeQuestionFiveTableViewCell";

static const float PartThreeQuestionTableViewCellHeight = 60;

@interface PartThreeTableViewController () <PartThreeQuestionTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) NSMutableDictionary *answers;

@end

@implementation PartThreeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readQuestions];
    self.answers = [NSMutableDictionary new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PartThreeQuestionTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartThreeQuestionTableViewCell *cell;
//    if (indexPath.row < 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:PartThreeGeneralQuestionTableViewCellIdentifier forIndexPath:indexPath];
        cell.isQuestionFive = NO;
//    } else {
//        cell = [tableView dequeueReusableCellWithIdentifier:PartThreeQuestionFiveTableViewCellIdentifier forIndexPath:indexPath];
//        cell.isQuestionFive = YES;
//    }
    
    NSString *questionString = [NSString stringWithFormat:@"%ld. %@", (long)indexPath.row + 1, self.questions[indexPath.row]];
    cell.questionLabel.text =  questionString;
    
    cell.delegate = self;
    [cell setExpandedHeight];
    
    NSMutableDictionary *answerDict = self.answers[@(indexPath.row)];
    if (answerDict) {
        [cell setupCellWithAnswers:answerDict];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120;
}

- (void)readQuestions {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"part3" ofType:@"txt"];
    NSError *error;
    NSStringEncoding *encoding;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath usedEncoding:encoding error:&error];
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    
    self.questions = [fileContents componentsSeparatedByString:@"\n"];
}

#pragma mark - PartThreeQuestionTableViewCellDelegate

- (void)tableViewCell:(PartThreeQuestionTableViewCell *)cell didChooseFirstAnswer:(BOOL)answer {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *answerDict = self.answers[@(cellIndexPath.row)];
    if (!answerDict) {
        answerDict = [NSMutableDictionary new];
    }
    
    
    answerDict[@"firstAnswer"] = @(answer);
    if (!answer) {
        [answerDict removeObjectForKey:@"secondAnswer"];
    }
    self.answers[@(cellIndexPath.row)] = answerDict;
    
    [self.tableView beginUpdates];
    [UIView animateWithDuration:0.3 animations:^{
        [cell.contentView layoutIfNeeded];
    }];
    [self.tableView endUpdates];
//    [self.tableView scrollToRowAtIndexPath:cellIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

}

- (void)tableViewCell:(PartThreeQuestionTableViewCell *)cell didChooseSecondAnswer:(BOOL)answer {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *answerDict = self.answers[@(cellIndexPath.row)];
    
    answerDict[@"secondAnswer"] = @(answer);
    if (!answer) {
        [answerDict removeObjectForKey:@"duration"];
        
    }
    self.answers[@(cellIndexPath.row)] = answerDict;
    
    
    [self.tableView beginUpdates];
    [UIView animateWithDuration:0.3 animations:^{
        [cell.contentView layoutIfNeeded];
    }];
    [self.tableView endUpdates];
//    [self.tableView scrollToRowAtIndexPath:cellIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)tableViewCell:(PartThreeQuestionTableViewCell *)cell didChooseDuration:(NSTimeInterval)duration {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *answerDict = self.answers[@(cellIndexPath.row)];
    
    answerDict[@"duration"] = @(55);
    self.answers[@(cellIndexPath.row)] = answerDict;
    NSLog(@"%@", self.answers);
}

@end
