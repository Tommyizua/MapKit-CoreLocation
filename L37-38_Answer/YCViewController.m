//
//  ViewController.m
//  L37-38_Answer
//
//  Created by Yaroslav on 26/01/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import "YCViewController.h"
#import <MapKit/MapKit.h>
#import "YCStudent.h"
#import "UIView+MKAnnotationView.h"
#import "YCDetailTableViewController.h"
#import "YCAnnotation.h"


@interface YCViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@property (strong, nonatomic) CLGeocoder *geoCoder;

@end

@implementation YCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.mapView.showsUserLocation = YES;
    
    for (int i = 0; i < 10; i++) {
        
        [self.mapView addAnnotation:[YCStudent generateStudent]];
    }
    
    YCAnnotation *partyAnnotation = [YCAnnotation generateParty];
    
    [self.mapView addAnnotation:partyAnnotation];
    
    for (int i = 500; i <= 1500; i += 500) {
        
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:partyAnnotation.coordinate radius:i];
        [self.mapView addOverlay:circle];
    }
    
    
    UIBarButtonItem *zoomButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                  target:self
                                                  action:@selector(actionShowAll:)];
    
    self.navigationItem.rightBarButtonItems = @[zoomButton];
}

- (void)dealloc {
    
    if ([self.geoCoder isGeocoding]) {
        [self.geoCoder cancelGeocode];
    }
}

#pragma mark - Actions

- (void)actionShowAll:(UIBarButtonItem *)sender {
    
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        
        CLLocationCoordinate2D location = annotation.coordinate;
        
        MKMapPoint center = MKMapPointForCoordinate(location);
        
        static double delta = 0;
        
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
        
        zoomRect = MKMapRectUnion(rect, zoomRect);
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(50, 50, 50, 50)
                           animated:YES];
}

#pragma mark - MKMapViewDelegate

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        
        return nil;
    }
    
    if ([annotation isKindOfClass:[YCAnnotation class]]) {
        
        static NSString *identifier = @"Party";
        
        MKAnnotationView *pin = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!pin) {
            
            pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            pin.canShowCallout = YES;
            pin.draggable = YES;
            pin.image = [UIImage imageNamed:@"party.png"];
            
        } else {
            pin.annotation = annotation;
        }
        
        return pin;
    }
    
    static NSString *identifier = @"Annotation";
    
    MKAnnotationView *pin = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!pin) {
        
        pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
        pin.canShowCallout = YES;
        
        if ([(YCStudent *)annotation isMan]) {
            
            pin.image = [UIImage imageNamed:@"man.png"];
            
        } else {
            
            pin.image = [UIImage imageNamed:@"woman.png"];
        }
        
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        [infoButton addTarget:self action:@selector(actionInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        pin.rightCalloutAccessoryView = infoButton;
        
    } else {
        
        pin.annotation = annotation;
    }
    
    return pin;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.location = [locations lastObject];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
        
        MKCircleRenderer *render = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        
        render.lineWidth = 0.5f;
        render.strokeColor = [UIColor colorWithRed:0.f green:0.5f blue:1.0f alpha:0.5f];
        render.fillColor = [UIColor colorWithRed:0.f green:0.5f blue:1.0f alpha:0.1f];
        
        return render;
    }
    
    return nil;
}

#pragma mark - Actions

- (void)showViewController:(UIViewController *)vc sender:(id)sender {
    
    if (!sender) {
        return;
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    navController.modalPresentationStyle = UIModalPresentationPopover;
    
    [self presentViewController:navController animated:YES completion:nil];
    
    
    UIPopoverPresentationController *popController = [navController popoverPresentationController];
    
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    popController.delegate = self;
    
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        
        popController.barButtonItem = sender;
        
    } else {
        
        popController.sourceView = self.view;
        popController.sourceRect = [sender frame];
    }
}


- (void)actionInfo:(UIButton *)sender {
    
    YCStudent *studentAnnotation = (YCStudent <MKAnnotation> *)[[sender superAnnotationView] annotation];
    
    CLLocationCoordinate2D coordinate = [studentAnnotation coordinate];
    
    if ([self.geoCoder isGeocoding]) {
        
        [self.geoCoder cancelGeocode];
    }
    
    self.geoCoder = [[CLGeocoder alloc] init];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        NSString *message = nil;
        
        if (error) {
            
            message = [error localizedDescription];
        }
        
        if (placemarks.count > 0) {
            
            MKPlacemark *placeMark = [[MKPlacemark alloc] initWithPlacemark:[placemarks firstObject]];
            
            NSString *streetName = placeMark.thoroughfare;
            NSString *streetNumber = placeMark.subThoroughfare;
            NSString *city = placeMark.administrativeArea;
            NSString *country = placeMark.country;
            
            NSDictionary *addressDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:streetName, @"throughfare", streetNumber, @"subThoroughfare", city, @"locality", country, @"country", nil];
            
            studentAnnotation.addressDictionary = addressDictionary;
            
            YCDetailTableViewController *detailsController = [self.storyboard instantiateViewControllerWithIdentifier:@"YCDetailTableViewController"];
            
            detailsController.student = studentAnnotation;
            
            
            [self showViewController:detailsController sender:sender];
            
        } else {
            
            message = @"Not Placemark Found";
        }
    }];
}


@end
