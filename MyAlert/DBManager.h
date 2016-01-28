//
//  DBManager.h
//  MyAlert
//
//  Created by 張艶斉 on 2016/01/24.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DBManager : NSObject
@property (nonatomic, retain) FMDatabase *db;
+ (NSMutableArray *) getInfoByStationName:(NSString *)name;
@end
