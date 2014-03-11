//
//  ViewFactory.m
//  TastingNotes
//
//  Created by Matt on 2/3/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "ViewFactory.h"

@interface ViewFactory()

@property Note *note;

@end

@implementation ViewFactory

-(id)initWithNote:(Note *)n{
    self = [super init];
    if (self) {
        self.note = n;
    }
    return self;
}

-(UIView *)viewForThisGroupTemplate:(Group_Template *)gt
                 andThisContentType:(ContentType_Template *)ct{
    UIView *v;
    
    if([ct.type isEqualToString:@"SmallText"] || [ct.type isEqualToString:@"MultiText"])
        v = [self smallTextViewThisGroupTemplate:gt andThisContentType:ct];
    /*
     if([ct.type isEqualToString:@"Picture"])
     v = [self viewForPictureForContentType:ct];
     
     if(!v)
     v = [self testView];*/
    
    return v;
}

/*-(UIView *)viewForPictureForContentType:(ContentType_Template *)ct{
 
 Content *c = [self.note contentInThisGroup:self.gt
 andThisContentType:ct];
 UIImage *i = [UIImage imageWithData:c.binaryData];
 CGRect r;
 
 r = [self getSizedRectangleWithThisHeight:i.size.height];
 
 UIImageView *iv = [[UIImageView alloc]initWithFrame:r];
 iv.image = i;
 iv.contentMode = UIViewContentModeScaleAspectFit;
 
 return iv;
 }
 */
-(UIView *)smallTextViewThisGroupTemplate:(Group_Template *)gt
                       andThisContentType:(ContentType_Template *)ct{
    CGRect r = [self getSizedRectangleWithThisHeight:50];
    
    UILabel *l = [[UILabel alloc]initWithFrame:r];
    //UILabel *l = [[UILabel alloc]init];

    l.font = [UIFont fontWithName:@"Arial" size:12];
    l.numberOfLines = 4;
    l.backgroundColor = [UIColor whiteColor];
    NSMutableString *m = [[NSMutableString alloc]init];
    [m appendString:ct.name];
    [m appendString:@"\n"];
    Content *c = [self.note contentInThisGroup:gt
                            andThisContentType:ct];
    
    if(c)
        [m appendString:c.stringData];
    
    l.text = m;
    
    return l;
}

-(UIView *)testView{
    CGRect r = [self getSizedRectangleWithThisHeight:50];
    
    UIView *testView = [[UIView alloc] initWithFrame:r];
    testView.backgroundColor = [UIColor blueColor];
    
    return testView;
}

-(CGRect)getSizedRectangleWithThisHeight:(CGFloat)height{
    return CGRectMake(10,
                      0,
                      300,
                      78);
}

@end
