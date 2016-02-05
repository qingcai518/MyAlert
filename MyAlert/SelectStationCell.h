//
//  SelectStationCell.h
//  MyAlert
//
//  Created by user on 2016/02/01.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIColor+AppExtension.h"

@interface SelectStationCell : UITableViewCell
@property (nonatomic, assign) CGFloat height;
- (void) setContents:(NSDictionary *)dic current:(CLLocation*)current;
@end
