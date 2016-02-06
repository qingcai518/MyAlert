//
//  StationViewController.h
//  MyAlert
//
//  Created by user on 2016/01/28.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioServices.h>
#import "StationCell.h"
#import "UIView+Toast.h"
#import "JCAlertView.h"
#import "LocationManagerSingleton.h"

@interface StationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) NSArray *contents;
- (id)initWithStyle:(UITableViewStyle)theStyle data:(NSArray *)data;
@end
