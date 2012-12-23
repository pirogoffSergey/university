//
//  IndividCell.h
//  GeneticAlgorithm
//
//  Created by Oxygen on 20.12.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndividCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *binCode1Label;
@property (weak, nonatomic) IBOutlet UILabel *binCode2Label;

@property (weak, nonatomic) IBOutlet UILabel *xyLabel;
//@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@end
