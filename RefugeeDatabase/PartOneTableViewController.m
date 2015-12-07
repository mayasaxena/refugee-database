//
//  PartOneTableViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 11/30/15.
//  Copyright (c) 2015 Workinonit. All rights reserved.
//

#import "PartOneTableViewController.h"
#import "QuestionTableViewCell.h"

static NSString * const QuestionTableViewCellIdentifier = @"QuestionTableViewCell";

@interface PartOneTableViewController ()

@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;

@end

@implementation PartOneTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readQuestions];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QuestionTableViewCellIdentifier forIndexPath:indexPath];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)readQuestions {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"part1" ofType:@"txt"];
    NSError *error;
    NSStringEncoding *encoding;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath usedEncoding:encoding error:&error];
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    
    self.questions = [fileContents componentsSeparatedByString:@"\n"];
    
}

@end
