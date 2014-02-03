//
//  ViewFactory.m
//  TastingNotes
//
//  Created by Matt on 2/3/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "ViewFactory.h"

@interface ViewFactory()

@property int margin;
@property CGRect containerFrame;

@end

@implementation ViewFactory

-(id)initWithGroupTemplate:(Group_Template *)gt
                   andNote:(Note *)n
     forThisContainerFrame:(CGRect)frame{
    
    self = [super init];
    if (self) {
        self.margin = 10;
        self.containerFrame = frame;
        self.totalHeight = 0;
    }
    return self;
}

-(UIView *)testView{
    int h = 50;
    self.totalHeight = self.totalHeight + 5;
    CGRect r = CGRectMake(self.margin,
                          self.totalHeight,
                          self.containerFrame.size.width-self.margin,
                          h);
    
    UIView *testView = [[UIView alloc] initWithFrame:r];
    testView.backgroundColor = [UIColor blueColor];
    
    self.totalHeight = self.totalHeight + h;
    
    return testView;
}

@end
