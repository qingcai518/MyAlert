//
//  StationCell.m
//  MyAlert
//
//  Created by user on 2016/01/28.
//  Copyright © 2016年 user. All rights reserved.
//

#import "StationCell.h"

@implementation StationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self !=nil) {
        _height = 65;
    }
    return self;
}

- (void) setContents:(NSDictionary *)dic {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSString *name = [dic valueForKey:@"name"];
    NSString *line = [dic valueForKey:@"line"];
    NSString *place = [dic valueForKey:@"place"];

    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, width, 20)];
    nameLbl.text = name;
    nameLbl.font = [UIFont fontWithName:@"AvenirNext-Bold" size:20];
    [self addSubview:nameLbl];

    NSString *infoText = [NSString stringWithFormat:@"%@  %@", place, line];
    UILabel *infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, width, 15)];
    infoLbl.text = infoText;
    infoLbl.textColor = [UIColor grayColor];
    infoLbl.font = [UIFont fontWithName:@"Avenir-Light" size:15];
    [self addSubview:infoLbl];
}

@end
