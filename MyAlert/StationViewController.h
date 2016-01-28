//
//  StationViewController.h
//  MyAlert
//
//  Created by user on 2016/01/28.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationCell.h"

@interface StationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) UITableViewStyle style;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *contents;
- (id)initWithStyle:(UITableViewStyle)theStyle data:(NSArray *)data;
@end
