//
//  AppContent.h
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppContent : NSObject

@property(strong,readonly) NSMutableArray *notebooks;

-(void)save;

-(Notebook *)newWineNotebook;

-(Note *)addNoteToThisNotebook:(Notebook *)notebook;
-(Content *)getNewContent;

//-(void)removeThisNote:(Note *)note;


@end
