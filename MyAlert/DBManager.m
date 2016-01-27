//
//  DBManager.m
//  MyAlert
//
//  Created by 張艶斉 on 2016/01/24.
//  Copyright © 2016年 user. All rights reserved.
//

#import "DBManager.h"
NSString *DB = @"station.db";
@implementation DBManager
+ (NSMutableArray *) getInfoByStationName:(NSString *)name {
    FMDatabase *db  = [FMDatabase databaseWithPath:DB];
    NSString *sql = @"select * from station where name like '%?%'";
    
    [db open];
    FMResultSet *results = [db executeQuery:sql, name];
    NSMutableArray *stations = [[NSMutableArray alloc] init];
    
    while ([results next]) {
        Station *myStation = [[Station alloc]init];
        [myStation setPlace:[results stringForColumnIndex:0]];
        [myStation setLine:[results stringForColumnIndex:1]];
        [myStation setStationName:[results stringForColumnIndex:2]];
        [myStation setPosition:[results stringForColumnIndex:3]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:[results stringForColumnIndex:4]];
        [myStation setSearchDate:date];
        [stations addObject:myStation];
    }
    [db close];
    
    return stations;
}
@end
