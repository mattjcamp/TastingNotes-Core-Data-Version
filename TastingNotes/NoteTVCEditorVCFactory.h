//
//  NoteTVCEditorVCFactory.h
//  TastingNotes
//
//  Created by Matt on 3/13/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteTVCEditorVCFactory : NSObject

-(id)initWithNote:(Note *)n;

-(UIViewController *)viewControllerForThisGroupTemplate:(Group_Template *)gt
                                         andThisContent:(Content *)c
andDoThisIfContentChanges:(void (^)())updateUI;

@end
