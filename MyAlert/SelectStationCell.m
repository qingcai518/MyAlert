//
//  SelectStationCell.m
//  MyAlert
//
//  Created by user on 2016/02/01.
//  Copyright © 2016年 user. All rights reserved.
//

#import "SelectStationCell.h"

@implementation SelectStationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self !=nil) {
        _height = 65;
    }
    return self;
}

- (void) setContents:(NSDictionary *)dic current:(CLLocation*)current {
    if (dic == nil) {
        return;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSString *name = [dic valueForKey:@"name"];
    NSString *line = [dic valueForKey:@"line"];
    NSString *place = [dic valueForKey:@"place"];
    double latitude = [[dic valueForKey:@"latitude"]doubleValue];
    double longitude = [[dic valueForKey:@"longitude"]doubleValue];
    
    NSString *distanceStr = @"";
    if (current == nil) {
        distanceStr = @"計算中";
    } else {
        CLLocation *dest = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        CLLocationDistance distance = [current distanceFromLocation:dest];
        
        if (distance >= 1000) {
            distanceStr = [NSString stringWithFormat:@"%.2fkm", (distance / 1000)];
        } else {
            distanceStr = [NSString stringWithFormat:@"%.2fm", distance];
        }
//        distanceStr = [NSString stringWithFormat:@"%.5fm", distance];
    }
    
    UILabel *distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, width - 200 - 50, 20)];
    distanceLbl.text = distanceStr;
    distanceLbl.font = [UIFont fontWithName:@"Avenir-Light" size:15];
    distanceLbl.textColor = [UIColor blueColor];
    [self addSubview:distanceLbl];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, width - 200 - 20, 20)];
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
