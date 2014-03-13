//
//  NoteTVCEditorVCFactory.m
//  TastingNotes
//
//  Created by Matt on 3/13/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "NoteTVCEditorVCFactory.h"
#import "SmallTextEditorVC.h"

@interface NoteTVCEditorVCFactory()

@property Note *note;

@end

@implementation NoteTVCEditorVCFactory

-(id)initWithNote:(Note *)n{
    self = [super init];
    if (self) {
        self.note = n;
    }
    return self;
}

-(UIViewController *)viewControllerForThisGroupTemplate:(Group_Template *)gt
                                         andThisContent:(Content *)c
                              andDoThisIfContentChanges:(void (^)())updateUI{
    
    if([c.inThisContent_Type.type isEqualToString:@"SmallText"]){
        SmallTextEditorVC *steVC = [[SmallTextEditorVC alloc]initWithContent:c andDoThisIfContentChanges:updateUI];
        
        return steVC;
    }
    
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor blueColor];
    
    return vc;
}

@end
