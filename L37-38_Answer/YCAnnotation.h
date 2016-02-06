//
//  YCAnnotation.h
//  L37-38_Answer
//
//  Created by Yaroslav on 27/01/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MKAnnotation.h>


@interface YCAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


+ (YCAnnotation *)generateParty;

@end
