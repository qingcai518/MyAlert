//
//  StationViewController.m
//  MyAlert
//
//  Created by user on 2016/01/28.
//  Copyright © 2016年 user. All rights reserved.
//

#import "StationViewController.h"

@interface StationViewController ()
@end

double baseLatitude;
double baseLongitude;
//BOOL iShouldShowAlert;
//BOOL iShouldKeepBuzzing;
//int alertDistance = 500;

@implementation StationViewController
- (id)initWithStyle:(UITableViewStyle)theStyle data:(NSArray *)data stations:(NSMutableArray *)stations {
    self = [super init];
    if (self != nil) {
        self.contents = data;
//        if (stations == nil) {
//            self.selectStations = [[NSMutableArray alloc] init];
//        } else {
//            self.selectStations = stations;
//        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.font = [UIFont boldSystemFontOfSize:16.0];
    title.textColor = [UIColor whiteColor];
    title.text = @"候補一覧";
    [title sizeToFit];
    self.navigationItem.titleView = title;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

//カメラボタンが押されたときに呼ばれるメソッド
-(void)goBack:(UIBarButtonItem*)item{
    NSLog(@"ボタンを押されましたね");
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self getCell:(int)indexPath.row tableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    StationCell *cell = [self getCell:(int)indexPath.row tableView:tableView];
    return cell.height;
}

- (StationCell *)getCell:(int)index tableView:(UITableView *)tableView {
    StationCell *cell  = [[StationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSDictionary *dic = self.contents[index];
    [cell setContents:dic];
    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.contents[indexPath.row];
    NSString *name = [dic valueForKey:@"name"];

    CLLocationManager *locationManager = LocationManagerSingleton.sharedSingleton.locationManager;
    
    //GPSの利用可否判断
    if ([CLLocationManager locationServicesEnabled]) {
        [self.navigationController.view makeToast:[NSString stringWithFormat:@"行き先駅を%@に設定しました。", name]
                                         duration:2.0
                                         position:CSToastPositionCenter
                                            title:nil
                                            image:[UIImage imageNamed:@"sucess.jpg"]
                                            style:nil
                                       completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
        [LocationManagerSingleton.sharedSingleton.selectStations addObject:dic];
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithObject:LocationManagerSingleton.sharedSingleton.selectStations forKey:@"stations"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterCompletionNotification" object:nil userInfo:dataDict];
        
        NSMutableDictionary *distanceDict = [NSMutableDictionary dictionaryWithObject:locationManager.location  forKey:@"currentLocation"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentLocationNotification" object:nil userInfo:distanceDict];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController.view makeToast:@"Unforunately! The location services is disabled."
                                         duration:2.0
                                         position:CSToastPositionCenter
                                            title:nil
                                            image:[UIImage imageNamed:@"fail.jpg"]
                                            style:nil
                                       completion:nil];
    }
    
    LocationManagerSingleton.sharedSingleton.iShouldShowAlert = YES;
    LocationManagerSingleton.sharedSingleton.iShouldKeepBuzzing = YES;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
