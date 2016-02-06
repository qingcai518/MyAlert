//
//  ViewController.h
//  MyAlert
//
//  Created by user on 2016/01/20.
//  Copyright © 2016年 user. All rights reserved.
//
@class DEMODataSource;
#import <UIKit/UIKit.h>
#import "MLPAutoCompleteTextField.h"
#import "MLPAutoCompleteTextFieldDelegate.h"
#import "DataSource.h"
#import "DBManager.h"
#import "StationViewController.h"
#import "UIColor+AppExtension.h"
#import "SelectStationCell.h"
#import "JCAlertView.h"
#import "MapViewController.h"
#import "LocationManagerSingleton.h"

@interface SearchViewController : UIViewController<UITextFieldDelegate, MLPAutoCompleteTextFieldDataSource, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property(nonatomic, strong) MLPAutoCompleteTextField *stationTF;
@property(nonatomic, strong) NSString *textInput;
@property(nonatomic, strong) CLLocation *current;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UILabel *label;
@end

