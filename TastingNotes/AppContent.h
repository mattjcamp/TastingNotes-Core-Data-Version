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

-(NSNumber *)maxNotebookOrder;
-(Notebook *)newNotebookWithThisName:(NSString *)name;
-(Notebook *)newWineNotebook;
-(void)addThisNotebookToList:(Notebook *)notebook;
-(Notebook_Template *)newNotebookTemplateWithThisName:(NSString *)name;
-(Group_Template *) addGroupTemplateWithThisName:(NSString *)name
                          toThisNotebookTemplate:(Notebook_Template *)nt;
-(ContentType_Template *)addContentTypeTemplateWithThisName:(NSString *)name
                                        toThisGroupTemplate:(Group_Template* )gt;

-(Note *)addNoteToThisNotebook:(Notebook *)notebook;
-(Content *)newContent;

//-(void)removeThisNote:(Note *)note;


@end
