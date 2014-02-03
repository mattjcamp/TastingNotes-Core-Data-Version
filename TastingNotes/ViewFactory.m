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
@property Group_Template *gt;
@property Note *note;

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
        self.gt = gt;
        self.note = n;
    }
    return self;
}

-(UIView *)viewForContentType:(ContentType_Template *)ct{
    self.totalHeight = self.totalHeight + self.margin;
    UIView *v;
    
    if([ct.type isEqualToString:@"SmallText"] || [ct.type isEqualToString:@"MultiText"])
        v = [self viewForSmallTextForContentType:ct];
    
    if([ct.type isEqualToString:@"Picture"])
        v = [self viewForPictureForContentType:ct];
    
    if(!v)
        v = [self testView];
    
    self.totalHeight = self.totalHeight + v.frame.size.height;
    
    return v;
}

-(UIView *)viewForPictureForContentType:(ContentType_Template *)ct{
    
    Content *c = [self.note contentInThisGroup:self.gt
                            andThisContentType:ct];
    UIImage *i = [UIImage imageWithData:c.binaryData];
    CGRect r = CGRectMake(self.margin,
                          self.totalHeight,
                          i.size.width,
                          i.size.height);
    UIImageView *iv = [[UIImageView alloc]initWithFrame:r];
    iv.image = i;
    return iv;
}

-(UIView *)viewForSmallTextForContentType:(ContentType_Template *)ct{
    int h = 50;
    CGRect r = CGRectMake(self.margin,
                          self.totalHeight,
                          self.containerFrame.size.width-self.margin,
                          h);
    
    UILabel *l = [[UILabel alloc]initWithFrame:r];
    l.numberOfLines = 2;
    l.backgroundColor = [UIColor whiteColor];
    NSMutableString *m = [[NSMutableString alloc]init];
    [m appendString:ct.name];
    [m appendString:@"\n"];
    Content *c = [self.note contentInThisGroup:self.gt
                            andThisContentType:ct];
    
    if(c)
        [m appendString:c.stringData];
    
    l.text = m;
    
    return l;
}

-(UIView *)testView{
    int h = 50;
    CGRect r = CGRectMake(self.margin,
                          self.totalHeight,
                          self.containerFrame.size.width-self.margin,
                          h);
    
    UIView *testView = [[UIView alloc] initWithFrame:r];
    testView.backgroundColor = [UIColor blueColor];
    
    return testView;
}

@end
