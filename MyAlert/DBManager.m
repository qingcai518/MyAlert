//
//  DBManager.m
//  MyAlert
//
//  Created by 張艶斉 on 2016/01/24.
//  Copyright © 2016年 user. All rights reserved.
//

#import "DBManager.h"
NSString *DB_FILE = @"station.db";
@implementation DBManager
+ (NSMutableArray *) getInfoByStationName:(NSString *)name {
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:DB_FILE];
    
    BOOL checkDb;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // データベースファイルを確認
    checkDb = [fileManager fileExistsAtPath:dbPath];
    if(!checkDb){
        // ファイルが無い場合はコピー
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_FILE];
        checkDb = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if(!checkDb){
            // error
            NSLog(@"Copy error = %@", defaultDBPath);
        }
    }
    else{
        NSLog((@"DB file OK"));
    }
    
    FMDatabase *db  = [FMDatabase databaseWithPath:dbPath];
    NSString *sql = @"select * from station where name like ? order by searchDate";

    [db open];
    FMResultSet *results = [db executeQuery:sql, [NSString stringWithFormat:@"%%%@%%", name]];
    NSMutableArray *stations = [[NSMutableArray alloc] init];
    
    while ([results next]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[results stringForColumnIndex:0] forKey:@"place"];
        [dic setObject:[results stringForColumnIndex:1] forKey:@"line"];
        [dic setObject:[results stringForColumnIndex:2] forKey:@"name"];
        [dic setObject:[results stringForColumnIndex:3] forKey:@"latitude"];
        [dic setObject:[results stringForColumnIndex:4] forKey:@"longitude"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:[results stringForColumnIndex:5]];
        [dic setObject:date forKey:@"date"];
        [stations addObject:dic];
    }
    [db close];
    
    return stations;
}
@end
