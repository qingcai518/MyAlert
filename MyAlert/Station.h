//
//  Station.h
//  MyAlert
//
//  Created by 張艶斉 on 2016/01/27.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject
@property(nonatomic, strong) NSString *place;
@property(nonatomic, strong) NSString *line;
@property(nonatomic, strong) NSString *stationName;
@property(nonatomic, strong) NSString *position;
@property(nonatomic, strong) NSDate *searchDate;
@end
