//
//  YCAnnotation.m
//  L37-38_Answer
//
//  Created by Yaroslav on 27/01/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import "YCAnnotation.h"

@implementation YCAnnotation

+ (YCAnnotation *)generateParty {
    
    YCAnnotation *partyAnnotation = [[YCAnnotation alloc] init];
    
    CLLocationDegrees latitude = 50.459784;
    CLLocationDegrees longitude = 30.499498;
    
    partyAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
  
    partyAnnotation.title = @"Party House";
    partyAnnotation.subtitle = @"Free this Night";
 
    return partyAnnotation;
}

@end
