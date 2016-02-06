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
    GMSMapView *mapView_;
    NSInteger index;
}

- (instancetype) init:(NSInteger) pos {
    self = [super init];
    if (self != nil) {
        index = pos;
    }
    return self;
}

- (void)viewDidLoad {
    CLLocationManager *locationManager = LocationManagerSingleton.sharedSingleton.locationManager;
    CLLocationCoordinate2D position = locationManager.location.coordinate;
    NSDictionary *dest = LocationManagerSingleton.sharedSingleton.selectStations[index];
    
    CGFloat currentZoom = mapView_.camera.zoom;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:position.latitude
                                                            longitude:position.longitude
                                                                 zoom:currentZoom];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    double latitude = [[dest valueForKey:@"latitude"] doubleValue];
    double longitude = [[dest valueForKey:@"longitude"] doubleValue];
    NSString *name = [dest valueForKey:@"name"];
    NSString *place = [dest valueForKey:@"place"];
    NSString *line = [dest valueForKey:@"line"];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
    marker.title = name;
    marker.snippet = [NSString stringWithFormat:@"%@ %@", line, place];
    marker.map = mapView_;
    
    // add polyline
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:CLLocationCoordinate2DMake(position.latitude, position.longitude)];
    [path addCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor redColor];
    polyline.map = mapView_;
}

@end