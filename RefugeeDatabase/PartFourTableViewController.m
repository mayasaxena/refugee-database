//
//  PartFourTableViewController.m
//  RefugeeDatabase
//
//  Created by Maya Saxena on 12/4/15.
//  Copyright (c) 2015 Workinonit. All rights reserved.
//

#import "PartFourTableViewController.h"
#import "PartFourQuestionTableViewCell.h"
#import "PatientResponse.h"

static NSString * const PartFourQuestionTableViewCellIdentifier = @"PartFourQuestionTableViewCell";
static const int PartFourQuestionTableViewCellHeight = 100;

@interface PartFourTableViewController ()

@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) NSMutableDictionary *answers;

@end

@implementation PartFourTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readQuestions];
    self.answers = [NSMutableDictionary new];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    for (int i = 0; i < self.questions.count; i++) {
        if (!self.answers[[NSString stringWithFormat:@"%d", i]]) {
            [self.answers setValue:@(UISegmentedControlNoSegment) forKey:[NSString stringWithFormat:@"%d", i]];
        }
    }
    [PatientResponse sharedResponse].partFourAnswers = self.answers;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questions.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PartFourQuestionTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartFourQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: PartFourQuestionTableViewCellIdentifier forIndexPath:indexPath];
    
    NSString *index = [NSString stringWithFormat:@"%ld. %@", (long)indexPath.row + 1, self.questions[indexPath.row]];
    cell.questionLabel.text =  index;
    
    NSNumber *answer = self.answers[[@(indexPath.row) stringValue]];
    if (answer) {
        [cell setupCellWithAnswer:[answer intValue]];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 150;
}

- (void)readQuestions {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"part4" ofType:@"txt"];
    NSError *error;
    NSStringEncoding *encoding;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath usedEncoding:encoding error:&error];
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    
    self.questions = [fileContents componentsSeparatedByString:@"\n"];
}

@end
