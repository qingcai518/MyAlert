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

CLLocation *dest;
double baseLatitude;
double baseLongitude;

@implementation StationViewController
- (id)initWithStyle:(UITableViewStyle)theStyle data:(NSArray *)data {
    self = [super init];
    if (self != nil) {
        self.contents = data;
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
    NSString *cellId = @"id1";
    StationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[StationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
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
    NSString *place = [dic valueForKey:@"place"];
    NSString *line = [dic valueForKey:@"line"];
    NSString *name = [dic valueForKey:@"name"];
    double latitude = [[dic valueForKey:@"latitude"] doubleValue];
    double longitude = [[dic valueForKey:@"longitude"] doubleValue];
    
    dest = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    
    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ) {
        // iOS8の場合は、以下の何れかの処理を追加しないと位置の取得ができない
        // アプリがアクティブな場合だけ位置取得する場合
        //            [self.locationManager requestWhenInUseAuthorization];
        // アプリが非アクティブな場合でも位置取得する場合
        [self.locationManager requestAlwaysAuthorization];
    }
    
    //GPSの利用可否判断
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
        
        CLLocation *local = self.locationManager.location;
        CLLocationDistance meters=[local distanceFromLocation:dest];
        NSLog(@"最初%f", meters);
        [self.navigationController.view makeToast:[NSString stringWithFormat:@"行き先駅を%@に設定しました。", name]
                                         duration:2.0
                                         position:CSToastPositionCenter
                                            title:nil
                                            image:[UIImage imageNamed:@"ok.png"]
                                            style:nil
                                       completion:nil];
    } else {
        [self.navigationController.view makeToast:@"Unforunately! The location services is disabled."
                                         duration:2.0
                                         position:CSToastPositionCenter
                                            title:nil
                                            image:[UIImage imageNamed:@"unfortunately.png"]
                                            style:nil
                                       completion:nil];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    //緯度
    double latitude = newLocation.coordinate.latitude;
    double longitude = newLocation.coordinate.longitude;
    
    CLLocation *current = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocationDistance distance = [current distanceFromLocation:dest];
    NSLog(@"経過%f", distance);
    
    if (distance < 500) {
        NSLog(@"もうすぐ到着だよ！%f", distance);
    }
}

// 現在地取得に失敗したら
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
}


@end
