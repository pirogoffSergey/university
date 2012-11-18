//
//  CustomTableViewController.m
//  GeneticAlgorithm
//
//  Created by Oxygen on 13.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "CustomTableViewController.h"
#import "GeneticAlgorithmModel.h"

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
    
    self.sections = [NSMutableArray array];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row selected");
}


#pragma mark -
#pragma mark UITableViewDataSource

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    // Binary code
    cell.textLabel.text = [self arrayToString: ((GAIndivid *)[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).binaryCode];

    // Adaptation
    float adaptation = ((GAIndivid *)[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).fitness.floatValue;
    float value = ((GAIndivid *)[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).value.floatValue;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Y = %@   X = %@", [GeneticAlgorithmModel roundNumber:adaptation], [GeneticAlgorithmModel roundNumber:value]];
    
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
