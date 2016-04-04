//
//  PartOneTableViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 11/30/15.
//  Copyright (c) 2015 Workinonit. All rights reserved.
//

#import "PartOneTableViewController.h"
#import "PartOneQuestionTableViewCell.h"

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
    return PartOneQuestionTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartOneQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PartOneQuestionTableViewCellIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    
    NSString *questionString = [NSString stringWithFormat:@"%ld. %@", (long)indexPath.row + 1, self.questions[indexPath.row]];
    cell.questionLabel.text = questionString;
    
    NSNumber *answer = self.answers[@(indexPath.row)];
    if (answer) {
        if ([answer boolValue]) {
            [cell selectYes];
        } else {
            [cell selectNo];
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
    self.answers[@(cellIndexPath.row)] = @(answer);
}

@end
