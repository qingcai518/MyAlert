//
//  MapViewController.m
//  MyAlert
//
//  Created by 張艶斉 on 2016/02/03.
//  Copyright © 2016年 user. All rights reserved.
//
#import "MapViewController.h"
@import GoogleMaps;

@implementation MapViewController {
    GMSMapView *mapView;
    NSInteger index;
    CLLocationCoordinate2D position;
    GMSMarker *marker;
}

- (instancetype) init:(NSInteger) pos {
    self = [super init];
    if (self != nil) {
        index = pos;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CLLocationManager *locationManager = LocationManagerSingleton.sharedSingleton.locationManager;
    position = locationManager.location.coordinate;

    // zoom:1: World  5: Landmass/continent  10: City  15: Streets  20: Buildings
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:position.latitude
                                                            longitude:position.longitude
                                                                 zoom:10];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
//    [mapView addObserver:self forKeyPath:@"MyLocation" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)updateMap:(NSNotification*)notification {
    //update current location
//    CLLocationManager *locationManager = LocationManagerSingleton.sharedSingleton.locationManager;
//    position = locationManager.location.coordinate;
//    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:position coordinate:position];
//    bounds = [bounds includingCoordinate:marker.position];
//    [mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:70.0f]];
}

- (void) viewDidAppear:(BOOL)animated {
    NSDictionary *dest = LocationManagerSingleton.sharedSingleton.selectStations[index];
    
    double latitude = [[dest valueForKey:@"latitude"] doubleValue];
    double longitude = [[dest valueForKey:@"longitude"] doubleValue];
    NSString *name = [dest valueForKey:@"name"];
    NSString *place = [dest valueForKey:@"place"];
    NSString *line = [dest valueForKey:@"line"];
    
    // Creates a marker in the center of the map.
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
    marker.title = name;
    marker.snippet = [NSString stringWithFormat:@"%@ %@", line, place];
    marker.map = mapView;
    
    // add polyline
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:CLLocationCoordinate2DMake(position.latitude, position.longitude)];
    [path addCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor redColor];
    polyline.strokeWidth = 5;
    polyline.map = mapView;
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:position coordinate:position];
    bounds = [bounds includingCoordinate:marker.position];
    [mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:70.0f]];
}

@end