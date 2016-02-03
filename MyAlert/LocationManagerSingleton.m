#import "LocationManagerSingleton.h"

@implementation LocationManagerSingleton
int alertDistance = 500;
@synthesize locationManager;

- (id)init {
    self = [super init];
    
    if(self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        
        if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ) {
            // iOS8の場合は、以下の何れかの処理を追加しないと位置の取得ができない
            // アプリがアクティブな場合だけ位置取得する場合
            //            [self.locationManager requestWhenInUseAuthorization];
            // アプリが非アクティブな場合でも位置取得する場合
            [self.locationManager requestAlwaysAuthorization];
            self.locationManager.allowsBackgroundLocationUpdates = YES;
            [self.locationManager startMonitoringSignificantLocationChanges];
        }
        [self.locationManager startUpdatingLocation];
        self.iShouldShowAlert = YES;
        self.iShouldKeepBuzzing = YES;

        self.selectStations = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (LocationManagerSingleton*)sharedSingleton {
    static LocationManagerSingleton* sharedSingleton;
    if(!sharedSingleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedSingleton = [LocationManagerSingleton new];
        });
    }
    
    return sharedSingleton;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    double latitude = newLocation.coordinate.latitude;
    double longitude = newLocation.coordinate.longitude;
    CLLocation *current = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    NSMutableDictionary *distanceDict = [NSMutableDictionary dictionaryWithObject:current forKey:@"currentLocation"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentLocationNotification" object:nil userInfo:distanceDict];
    
    for (NSDictionary *dic in self.selectStations) {
        double latitude = [[dic valueForKey:@"latitude"] doubleValue];
        double longitude = [[dic valueForKey:@"longitude"] doubleValue];
        CLLocation *dest = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        NSString *name = [dic valueForKey:@"name"];
        CLLocationDistance distance = [current distanceFromLocation:dest];
        NSLog(@"We have %fm from %@", distance, name);
        
        if (distance < alertDistance && self.iShouldShowAlert) {
            NSLog(@"もうすぐ%@に到着だよ！%f", name, distance);
            self.iShouldShowAlert = NO;
            
            [JCAlertView showTwoButtonsWithTitle:@"My Alert" Message:[NSString stringWithFormat:@"もうすぐ%@に到着だよ!\n後%dメートル",name,alertDistance] ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"閉じる" Click:^{
                self.iShouldKeepBuzzing = NO;
                self.iShouldShowAlert = NO;
                
                // 削除を実施.
                [self.selectStations removeObject:dic];
                NSDictionary *dataDict = [NSDictionary dictionaryWithObject:self.selectStations forKey:@"stations"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterCompletionNotification" object:nil userInfo:dataDict];
            } ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"再通知" Click:^{
                self.iShouldKeepBuzzing = NO;
                self.iShouldShowAlert = YES;
                alertDistance = 200;
            }];
            
            AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
}

void MyAudioServicesSystemSoundCompletionProc(SystemSoundID ssID, void *clientData) {
    if (LocationManagerSingleton.sharedSingleton.iShouldKeepBuzzing) {
        [NSThread sleepForTimeInterval:(NSTimeInterval)0.5];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    } else {
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
        LocationManagerSingleton.sharedSingleton.iShouldKeepBuzzing = YES;
    }
}

@end