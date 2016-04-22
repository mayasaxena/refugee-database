//
//  PartThreeTableViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 3/9/16.
//  Copyright (c) 2016 Workinonit. All rights reserved.
//

#import "PartThreeTableViewController.h"
#import "PartThreeQuestionTableViewCell.h"
#import "PatientResponse.h"

static NSString * const PartThreeGeneralQuestionTableViewCellIdentifier = @"PartThreeQuestionTableViewCell";
static NSString * const PartThreeQuestionFiveTableViewCellIdentifier = @"PartThreeQuestionFiveTableViewCell";

static const float PartThreeQuestionTableViewCellHeight = 60;
static const float PartThreeQuestionTableViewCellExpandedOnceHeight = 120;
static const float PartThreeQuestionTableViewCellExpandedTwiceHeight = 180;
static const float PartThreeQuestionFiveTableViewCellHeight = 160;



@interface PartThreeTableViewController () <PartThreeQuestionTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) NSMutableDictionary *answers;

@end

@implementation PartThreeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readQuestions];
    
    if ([PatientResponse sharedResponse].partThreeAnswers) {
        self.answers = [PatientResponse sharedResponse].partThreeAnswers;
    } else {
        self.answers = [NSMutableDictionary new];
    
        NSMutableDictionary *emptyAnswer = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(UISegmentedControlNoSegment), @"firstAnswer", @(UISegmentedControlNoSegment), @"secondAnswer", @0, @"duration", nil];
        
        for (int i = 0; i < self.questions.count; i++) {
            [self.answers setValue:[emptyAnswer mutableCopy] forKey:[NSString stringWithFormat:@"%d", i]];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [PatientResponse sharedResponse].partThreeAnswers = self.answers;
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

    NSMutableDictionary *answerDict = self.answers[[@(indexPath.row) stringValue]];
    if ([answerDict[@"firstAnswer"] boolValue]) {
        if (indexPath.row == 4) {
            return PartThreeQuestionFiveTableViewCellHeight;
        } else {
            return PartThreeQuestionTableViewCellExpandedOnceHeight;
        }
    } else if ([answerDict[@"firstAnswer"] boolValue] && [answerDict[@"secondAnswer"] boolValue]) {
        return PartThreeQuestionTableViewCellExpandedTwiceHeight;
    } else {
        return PartThreeQuestionTableViewCellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartThreeQuestionTableViewCell *cell;
    if (indexPath.row < 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:PartThreeGeneralQuestionTableViewCellIdentifier forIndexPath:indexPath];
        cell.isQuestionFive = NO;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:PartThreeQuestionFiveTableViewCellIdentifier forIndexPath:indexPath];
        cell.isQuestionFive = YES;
    }
    
    NSString *questionString = [NSString stringWithFormat:@"%ld. %@", (long)indexPath.row + 1, self.questions[indexPath.row]];
    cell.questionLabel.text =  questionString;
    
    cell.delegate = self;
    [cell setExpandedHeight];
    
    NSMutableDictionary *answerDict = self.answers[[@(indexPath.row) stringValue]];
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
    NSMutableDictionary *answerDict = self.answers[[@(cellIndexPath.row) stringValue]];
    if (!answerDict) {
        answerDict = [NSMutableDictionary new];
    }
    [answerDict setValue:@(answer) forKey:@"firstAnswer"];
    if (!answer) {
        [answerDict setValue:@(UISegmentedControlNoSegment) forKey:@"secondAnswer"];
    }
    self.answers[[@(cellIndexPath.row) stringValue]] = answerDict;
    
    [self.tableView beginUpdates];
    [UIView animateWithDuration:0.3 animations:^{
        [cell.contentView layoutIfNeeded];
    }];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:cellIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)tableViewCell:(PartThreeQuestionTableViewCell *)cell didChooseSecondAnswer:(BOOL)answer {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *answerDict = self.answers[[@(cellIndexPath.row) stringValue]];
    
    answerDict[@"secondAnswer"] = @(answer);
    if (!answer) {
        [answerDict setValue:@0 forKey:@"duration"];
        
    }
    self.answers[[@(cellIndexPath.row) stringValue]] = answerDict;
    
    
    [self.tableView beginUpdates];
    [UIView animateWithDuration:0.3 animations:^{
        [cell.contentView layoutIfNeeded];
    }];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:cellIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)tableViewCell:(PartThreeQuestionTableViewCell *)cell didChooseDuration:(NSTimeInterval)duration {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *answerDict = self.answers[[@(cellIndexPath.row) stringValue]];
    
    answerDict[@"duration"] = @(55);
    self.answers[[@(cellIndexPath.row) stringValue]] = answerDict;
}

@end
