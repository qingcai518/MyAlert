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
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<UITextFieldDelegate, MLPAutoCompleteTextFieldDataSource, CLLocationManagerDelegate>
@property(nonatomic, strong) MLPAutoCompleteTextField *stationTF;
@property(nonatomic, strong) NSString *textInput;
@property(nonatomic, strong) CLLocationManager *locationManager;
@end

