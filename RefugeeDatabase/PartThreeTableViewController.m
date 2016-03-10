//
//  PartThreeTableViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 3/9/16.
//  Copyright (c) 2016 Workinonit. All rights reserved.
//

#import "PartThreeTableViewController.h"

#import "PartThreeQuestionTableViewCell.h"

static NSString * const QuestionTableViewCellIdentifier = @"PartThreeQuestionTableViewCell";

@interface PartThreeTableViewController ()

@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;

@end

@implementation PartThreeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readQuestions];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartThreeQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QuestionTableViewCellIdentifier forIndexPath:indexPath];
    
    NSString *index = [NSString stringWithFormat:@"%ld. %@", (long)indexPath.row + 1, self.questions[indexPath.row]];
    cell.questionLabel.text =  index;
    
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

@end
