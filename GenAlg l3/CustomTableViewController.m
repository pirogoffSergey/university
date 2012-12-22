//
//  CustomTableViewController.m
//  GeneticAlgorithm
//
//  Created by Oxygen on 13.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "CustomTableViewController.h"
#import "GeneticAlgorithmModel.h"

#import "IndividCell.h"

@interface CustomTableViewController () <UITableViewDataSource, UITableViewDelegate>
{
    CGRect _aFrame;
}
@end


@implementation CustomTableViewController

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
    
    self.tableView.allowsMultipleSelection = YES;
    
    self.sections = [NSMutableArray array];
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

- (void)deselectAllCells {
    NSArray *selectedIndexes = [self.tableView indexPathsForSelectedRows];

    for(NSIndexPath *indx in selectedIndexes) {
        [self deselectCellAtIndexPath:indx];
    }
}

- (void)selectCellsWithMaxElements {
    
    GAIndivid *individ;
    int indexMax = 0;
    
    NSMutableArray *lastSection = [NSMutableArray arrayWithArray:[self.sections objectAtIndex:self.sections.count-1]];

    GAIndivid *maxIndivid = (GAIndivid *)[lastSection objectAtIndex:0];
    
    for(int i=0; i<lastSection.count; i++) {
        individ =  (GAIndivid *)[lastSection objectAtIndex:i];
        
        if(individ.fitness.doubleValue > maxIndivid.fitness.doubleValue) {
            individ = maxIndivid;
            indexMax = i;
        }
    }
        
    //check
    [self selectCellAtIndexPathAtIndexPath:[NSIndexPath indexPathForRow:indexMax inSection:self.sections.count-1]];
    [self selectCellAtIndexPathAtIndexPath:[NSIndexPath indexPathForRow:indexMax inSection:self.sections.count-1]];
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
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sections objectAtIndex:section] count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return @"Initial population";
    }
    return [NSString stringWithFormat:@"Step %d", section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IndividCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"IndividCellView" owner:self options:nil] objectAtIndex:0];
    }
    
    GAIndivid *individ = (GAIndivid *)[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    // Binary code
    cell.binCode1Label.text = [self arrayToString: individ.binaryCodeX]; //@"111 111 000 111";
    cell.binCode2Label.text = [self arrayToString: individ.binaryCodeY];
    
    // Adaptation
    cell.xyLabel.text = [NSString stringWithFormat:@"(%@,%@)", [GeneticAlgorithmModel roundNumber:individ.pt.x], [GeneticAlgorithmModel roundNumber:individ.pt.y]];
    cell.valueLabel.text = [GeneticAlgorithmModel roundNumber:individ.fitness.floatValue];
    return cell;
}


- (NSString *)arrayToString:(NSArray *)anArray
{
    NSMutableString *result = [NSMutableString string];
    for(int i=0; i<anArray.count; i++) {
        [result appendString: ((NSNumber *)[anArray objectAtIndex:i]).stringValue];
    }
    return result;
}

@end
