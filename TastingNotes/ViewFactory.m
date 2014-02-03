//
//  ViewFactory.m
//  TastingNotes
//
//  Created by Matt on 2/3/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "ViewFactory.h"

@implementation ViewFactory

int margin = 10;

+(UIView *)testViewWithThisReferenceFrame:(CGRect)refFrame{
    CGRect r = CGRectMake(margin,
                          refFrame.origin.y,
                          refFrame.size.width-margin,
                          50);
    
    UIView *testView = [[UIView alloc] initWithFrame:r];
    testView.backgroundColor = [UIColor blueColor];
    
    return testView;
}

@end
