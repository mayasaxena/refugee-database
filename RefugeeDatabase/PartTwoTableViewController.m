//
//  PartTwoTableViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 2/22/16.
//  Copyright (c) 2016 Workinonit. All rights reserved.
//

#import "PartTwoTableViewController.h"
#import "PartTwoTableViewCell.h"

static NSString * const kPartTwoCellIdentifier = @"PartTwoTableViewCell";

@interface PartTwoTableViewController ()

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

@end

@implementation PartTwoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readQuestions];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPartTwoCellIdentifier forIndexPath:indexPath];
    
    NSString *questionText = self.questions[indexPath.row];
    cell.questionLabel.text = questionText;
    
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

@end
