//
//  AppContent.h
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppContent : NSObject

@property(strong,readonly) NSString *test;
@property(strong,readonly) NSMutableArray *notebooks;

-(void)save;

/* -(Note *)addNote;
 -(void)removeThisNote:(Note *)note;
 */

@end
