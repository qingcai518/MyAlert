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

@interface SearchViewController : UIViewController<UITextFieldDelegate, MLPAutoCompleteTextFieldDataSource>
@property(nonatomic, strong) MLPAutoCompleteTextField *stationTF;
@property(nonatomic, strong) NSString *textInput;
@end

