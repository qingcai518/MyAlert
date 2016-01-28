//
//  ViewController.m
//  MyAlert
//
//  Created by user on 2016/01/20.
//  Copyright © 2016年 user. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

double baseLatitude;
double baseLongitude;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back.png"]];
    backImage.userInteractionEnabled = YES;
    backImage.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    [self.view addSubview:backImage];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, rect.size.width - 20, 60)];
    title.font = [UIFont fontWithName:@"Verdana" size:40];
    title.textColor = [UIColor whiteColor];
    title.text = @"Mr. Alert";
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    self.stationTF = [[MLPAutoCompleteTextField alloc]initWithFrame:CGRectMake(30, 200, rect.size.width - 60 -40, 40)];
    self.stationTF.borderStyle = UITextBorderStyleRoundedRect;
    self.stationTF.backgroundColor = [UIColor whiteColor];
    self.stationTF.placeholder = @"駅名を入力してください";
    self.stationTF.font = [UIFont fontWithName:@"Verdana" size:18];
    self.stationTF.clearButtonMode = UITextFieldViewModeAlways;
    self.stationTF.returnKeyType = UIReturnKeyDone;
    self.stationTF.autoCompleteDataSource = self;
    self.stationTF.delegate = self;
    [self.stationTF addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.stationTF];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.stationTF.frame), 200, 40, 40)];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void) handleTapGesture:(UITapGestureRecognizer*)sender {
    [self.view endEditing:YES];
}

- (void) textFieldChanged {
    self.textInput = self.stationTF.text;
}

- (void) doSearch {
    NSMutableArray *array = [DBManager getInfoByStationName:self.textInput];
    if (array.count == 1) {
        NSDictionary *dic = array[0];
        NSString *place = [dic valueForKey:@"place"];
        NSString *line = [dic valueForKey:@"line"];
        NSString *name = [dic valueForKey:@"name"];
        double latitude = [[dic valueForKey:@"latitude"] doubleValue];
        double longitude = [[dic valueForKey:@"longitude"] doubleValue];

        //GPSの利用可否判断
        if ([CLLocationManager locationServicesEnabled]) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = 100;
            [self.locationManager startUpdatingLocation];
            NSLog(@"Start updating location.");
            
            CLLocation *dest = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            CLLocation *local = self.locationManager.location;
            CLLocationDistance meters=[local distanceFromLocation:dest];
            
            NSLog(@"%f", meters);
        } else {
            NSLog(@"The location services is disabled.");
        }
        
        [self.locationManager startUpdatingLocation];
    } else {
        for (int i = 0; i < array.count; i++) {
            NSLog(@"%@", array[i]);
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    //緯度
    double latitude = newLocation.coordinate.latitude;
    double longitude = newLocation.coordinate.longitude;
    
    NSLog(@"%f, %f", latitude, longitude);
}

// 現在地取得に失敗したら
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; // Dismiss the keyboard.
    [self doSearch];
    return YES;
}

#pragma datasource.
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        NSArray *completions;
        completions = [self getStations];
        handler(completions);
    });
}

- (NSArray *) getStations {
    return @[@"蓮根", @"志村三丁目", @"志村坂上", @"蓮沼", @"高島平", @"巣鴨", @"春日", @"大門", @"勝どき", @"月島", @"上野御徒町", @"新御徒町"];
}

@end
