//
//  LocationManagerSingleton.h
//  MyAlert
//
//  Created by user on 2016/02/02.
//  Copyright © 2016年 user. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface LocationManagerSingleton : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;

+ (LocationManagerSingleton*)sharedSingleton;

@end