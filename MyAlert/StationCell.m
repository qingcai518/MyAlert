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
    return self;
}

- (void) setContents:(NSDictionary *)dic {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSString *name = [dic valueForKey:@"name"];
    NSString *line = [dic valueForKey:@"line"];
    NSString *place = [dic valueForKey:@"place"];
//    double latitude = [[dic valueForKey:@"latitude"]doubleValue];
//    double longitude = [[dic valueForKey:@"longitude"]doubleValue];
    
    UIFont *nameFont = [UIFont fontWithName:@"AvenirNext-Bold" size:20];
    CGSize nameSize = [name sizeWithAttributes:@{NSFontAttributeName:nameFont}];
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, nameSize.width, nameSize.height)];
    nameLbl.text = name;
    nameLbl.font = nameFont;
    [self addSubview:nameLbl];
    
    UIFont *infoFont = [UIFont fontWithName:@"AvenirNext" size:20];
    NSString *infoText = [NSString stringWithFormat:@"%@  %@", place, line];
    CGSize infoSize = [name sizeWithAttributes:@{NSFontAttributeName:nameFont}];
    UILabel *infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 10 - infoSize.width, 10, infoSize.width, infoSize.height)];
    infoLbl.text = infoText;
    infoLbl.font = infoFont;
    [self addSubview:infoLbl];
    
    _height = CGRectGetMaxY(nameLbl.frame) + 10;
}

@end
