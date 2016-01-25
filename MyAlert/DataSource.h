//
//  DataSource.h
//  MyAlert
//
//  Created by 張艶斉 on 2016/01/23.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MLPAutoCompleteTextFieldDataSource.h"

@interface DataSource : NSObject <MLPAutoCompleteTextFieldDataSource>
@property (assign) BOOL testWithAutoCompleteObjectsInsteadOfStrings;
@property (assign) BOOL simulateLatency;
@property (strong, nonatomic) NSArray *countryObjects;
@end
