//
//  ViewFactory.m
//  TastingNotes
//
//  Created by Matt on 2/3/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "NoteTVCViewFactory.h"

@interface NoteTVCViewFactory()

@property Note *note;

@end

@implementation NoteTVCViewFactory

-(id)initWithNote:(Note *)n{
    self = [super init];
    if (self) {
        self.note = n;
    }
    return self;
}

-(UIView *)viewForThisGroupTemplate:(Group_Template *)gt
                     andThisContent:(Content *)c{
    UIView *v;
    
    if([c.inThisContent_Type.type isEqualToString:@"SmallText"] || [c.inThisContent_Type.type isEqualToString:@"MultiText"])
        v = [self smallTextViewThisGroupTemplate:gt andThisContent:c];
    else
        v = [self baseViewThisGroupTemplate:gt andThisContent:c];
    
    return v;
}

-(UIView *)baseViewThisGroupTemplate:(Group_Template *)gt
                      andThisContent:(Content *)c{
    CGRect r = [self getSizedRectangleWithThisHeight:50];
    
    UILabel *l = [[UILabel alloc]initWithFrame:r];
    
    
    l.font = [UIFont fontWithName:@"Arial" size:12];
    l.numberOfLines = 4;
    l.backgroundColor = [UIColor whiteColor];
    NSMutableString *m = [[NSMutableString alloc]init];
    [m appendString:c.inThisContent_Type.name];
    
    l.text = m;
    
    return l;
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
                           andThisContent:(Content *)c{
    CGRect r = [self getSizedRectangleWithThisHeight:50];
    
    UILabel *l = [[UILabel alloc]initWithFrame:r];
    
    l.font = [UIFont fontWithName:@"Arial" size:12];
    l.numberOfLines = 4;
    l.backgroundColor = [UIColor whiteColor];
    NSMutableString *m = [[NSMutableString alloc]init];
    [m appendString:c.inThisContent_Type.name];
    [m appendString:@"\n"];
    
    if(c)
        [m appendString:c.stringData];
    
    l.text = m;
    
    [l setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
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
