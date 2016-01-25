//
//  DBManager.m
//  MyAlert
//
//  Created by 張艶斉 on 2016/01/24.
//  Copyright © 2016年 user. All rights reserved.
//

#import "DBManager.h"
@implementation DBManager
FMDatabase *db;
- (instancetype) initTables {
    self  = [super init];
    if (!self) {
        return nil;
    }
    //DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    
    //DBファイルがあるかどうか確認
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[dir stringByAppendingPathComponent:@"station.db"]])
    {
        //なければ新規作成
        db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:@"station.db"]];
        NSString *sql = @"CREATE TABLE station (name TEXT,line TEXT,searchdate TIMESTAMP CURRENT_TIMESTAMP, PRIMARY KEY(name, line));";
        
        [db open]; //DB開く
        [db executeUpdate:sql]; //SQL実行
        [db close]; //DB閉じる
    }
    
    return self;
}

- (NSMutableArray *)getStations:(NSString *)stationName {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSString *sql=@"select name, line from station where name like '?%' order by searchdate;";
    
    [db open];
    FMResultSet *results = [db executeQuery:sql,stationName];
    [db close];
    
    while( [results next] ){
        NSString *name = [results stringForColumn:@"name"];
        NSString *line = [results stringForColumn:@"line"];
        [array addObject:[NSString stringWithFormat:@"%@, %@",name,line]];
    }
    return array;
}

- (void) updateDate:(NSString *)name line:(NSString*)line {
    NSString *sql=@"update station set searchdate = ? where name = ? and line = ?;";
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    // NSTimeInterval is defined as double
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    
    [db open];
    [db executeUpdate:sql, timeStampObj, name, line];
    [db close];
}

@end
