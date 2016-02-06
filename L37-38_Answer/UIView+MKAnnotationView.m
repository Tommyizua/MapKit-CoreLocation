//
//  UIView+MKAnnotationView.m
//  L37-38_Answer
//
//  Created by Yaroslav on 27/01/16.
//  Copyright © 2016 Yaroslav Chyzh. All rights reserved.
//

#import "UIView+MKAnnotationView.h"
#import <MapKit/MKAnnotationView.h>

@implementation UIView (MKAnnotationView)

- (MKAnnotationView *)superAnnotationView {
    
    if ([self isKindOfClass:[MKAnnotationView class]]) {
        
        return (MKAnnotationView *)self;
    }
    
    if (!self.superview) {
        
        return nil;
    }
    
    return [self.superview superAnnotationView];
}

@end
