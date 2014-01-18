//
//  AppContent.h
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppContent : NSObject

+(AppContent *)sharedContent;

@property(strong,readonly) NSMutableArray *notebooks;

-(void)save;

-(NSNumber *)maxNotebookOrder;
-(Notebook *)addNewNotebookWithThisName:(NSString *)name;
-(Notebook *)newWineNotebook;
-(Notebook_Template *)addNewNotebookTemplateToThisNotebook:(Notebook *)notebook;
-(Group_Template *) addGroupTemplateWithThisName:(NSString *)name
                          toThisNotebookTemplate:(Notebook_Template *)nt;
-(ContentType_Template *)addContentTypeTemplateWithThisName:(NSString *)name
                                        toThisGroupTemplate:(Group_Template* )gt;
-(ListObject *)addListObjectWithThisName:(NSString *)name
                       toThisContentType:(ContentType_Template *)ct;
-(SelectedListObject *)addSelectedListObjectWithThisIdentifier:(NSNumber *)identifier
                                                 toThisContent:(Content *) c;
-(Note *)addNoteToThisNotebook:(Notebook *)notebook;
-(Content *)addNewContentToThisNote:(Note *)note
                inThisGroupTemplate:(Group_Template *)gt
                 andThisContentType:(ContentType_Template *)ct;

-(void)removeAllContent;


@end
