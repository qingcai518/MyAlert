//
//  StationCell.h
//  MyAlert
//
//  Created by user on 2016/01/28.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationCell : UITableViewCell
@property (nonatomic, assign) CGFloat height;
- (void) setContents:(NSDictionary *)dic;
@end
