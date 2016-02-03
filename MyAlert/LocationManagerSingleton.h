//
//  LocationManagerSingleton.h
//  MyAlert
//
//  Created by user on 2016/02/02.
//  Copyright © 2016年 user. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "UIView+Toast.h"
#import "JCAlertView.h"
#import <AudioToolbox/AudioServices.h>

@interface LocationManagerSingleton : NSObject <CLLocationManagerDelegate>
@property (nonatomic) BOOL iShouldShowAlert;
@property (nonatomic) BOOL iShouldKeepBuzzing;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *selectStations;
+ (LocationManagerSingleton*)sharedSingleton;

@end