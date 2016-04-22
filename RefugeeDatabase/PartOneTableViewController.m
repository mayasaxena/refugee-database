//
//  PartOneTableViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 11/30/15.
//  Copyright (c) 2015 Workinonit. All rights reserved.
//

#import "PartOneTableViewController.h"
#import "PartOneQuestionTableViewCell.h"
#import "PatientResponse.h"

static NSString * const PartOneQuestionTableViewCellIdentifier = @"PartOneQuestionTableViewCell";
static const float PartOneQuestionTableViewCellHeight = 100;

@interface PartOneTableViewController () <PartOneQuestionTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;

@property (strong, nonatomic) NSMutableDictionary *answers;

@end

@implementation PartOneTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readQuestions];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PatientResponse *sharedResponse = [PatientResponse sharedResponse];
    if (sharedResponse.partOneAnswers) {
        self.answers = sharedResponse.partOneAnswers;
    } else {
        self.answers = [NSMutableDictionary new];
        for (int i = 0; i < self.questions.count; i++) {
            [self.answers setValue:@(UISegmentedControlNoSegment) forKey:[NSString stringWithFormat:@"%d", i]];
        }
    }
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSMutableDictionary *orderedAnswers = [NSMutableDictionary new];
    
    [PatientResponse sharedResponse].partOneAnswers = orderedAnswers;
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
    return PartOneQuestionTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartOneQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PartOneQuestionTableViewCellIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    
    NSString *questionString = [NSString stringWithFormat:@"%ld. %@", (long)indexPath.row + 1, self.questions[indexPath.row]];
    cell.questionLabel.text = questionString;
    
    NSNumber *answer = self.answers[[@(indexPath.row) stringValue]];
    if (answer) {
        if ([answer intValue] == UISegmentedControlNoSegment) {
            [cell resetCell];
        } else {
            if ([answer boolValue]) {
                [cell selectYes];
            } else {
                [cell selectNo];
            }
        }
    }
    [cell layoutIfNeeded];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120;
}

- (void)readQuestions {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"part1" ofType:@"txt"];
    NSError *error;
    NSStringEncoding *encoding;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath usedEncoding:encoding error:&error];
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    
    self.questions = [fileContents componentsSeparatedByString:@"\n"];
}

- (void)tableViewCell:(PartOneQuestionTableViewCell *)cell didChooseAnswer:(BOOL)answer {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    self.answers[[@(cellIndexPath.row) stringValue]] = @(answer);
}

@end
