//
//  PartTwoTableViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 2/22/16.
//  Copyright (c) 2016 Workinonit. All rights reserved.
//

#import "PartTwoTableViewController.h"
#import "PartTwoTableViewCell.h"
#import "PatientResponse.h"

static NSString * const kPartTwoCellIdentifier = @"PartTwoTableViewCell";

@interface PartTwoTableViewController () <PartTwoTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) NSMutableDictionary *answers;

@end

@implementation PartTwoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readQuestions];
    self.answers = [NSMutableDictionary new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    for (int i = 0; i < self.questions.count; i++) {
        if (!self.answers[[NSString stringWithFormat:@"%d", i]]) {
            [self.answers setValue:@"n/a" forKey:[NSString stringWithFormat:@"%d", i]];
        }
    }
    
    [PatientResponse sharedResponse].partTwoAnswers = self.answers;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPartTwoCellIdentifier forIndexPath:indexPath];
    
    NSString *questionText = self.questions[indexPath.row];
    cell.questionLabel.text = questionText;
    cell.delegate = self;
    
    NSString *answer = self.answers[[@(indexPath.row) stringValue]];
    if (answer) {
        cell.questionTextView.text = answer;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (void)readQuestions {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"part2" ofType:@"txt"];
    NSError *error;
    NSStringEncoding *encoding;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath usedEncoding:encoding error:&error];
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    
    self.questions = [fileContents componentsSeparatedByString:@"\n"];
}

#pragma mark - PartTwoTableViewCellDelegate

- (void)tableViewCell:(PartTwoTableViewCell *)cell didChangeAnswer:(NSString *)answer {
    NSLog(@"changed!");
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    self.answers[[@(cellIndexPath.row) stringValue]] = answer;
}

@end
