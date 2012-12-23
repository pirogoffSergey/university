//
//  IneqTableController.m
//  GeneticAlgorithm
//
//  Created by Oxygen on 23.12.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "IneqTableController.h"
#import "IneqCell.h"

#import "GAInequality.h"

@interface IneqTableController () <UITableViewDataSource, UITableViewDelegate>
{
    CGRect _aFrame;
}
@end


@implementation IneqTableController

- (id)initWithFrame:(CGRect)aFramee
{
    self = [self init];
    if(self) {
        _aFrame = aFramee;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:_aFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.allowsMultipleSelection = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Public Methods

- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (void)selectCellAtIndexPathAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:nil];
}

- (void)deselectCellAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row selected");
}


#pragma mark -
#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int n = [self.system count];
    return n;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IneqCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"IneqCellView" owner:self options:nil] objectAtIndex:0];
    }
        
    NSArray *arr = [self.system allInequalities];
    GAInequality *ineq = [arr objectAtIndex:indexPath.row];
  
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@x1 ", [self roundNumber:ineq.a]];
    if(ineq.b >= 0) {
        str = [NSMutableString stringWithFormat:@"%@+ ",str];
    }
    str = [NSMutableString stringWithFormat:@"%@%@x2 <= %@",str, [self roundNumber:ineq.b], [self roundNumber:ineq.c]];
    cell.mainLabel.text = str;
    return cell;
}


- (NSString *)roundNumber:(float)number
{
    return [NSString stringWithFormat:@"%.2f", number];
}


@end
