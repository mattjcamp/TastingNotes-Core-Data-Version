//
//  AppContent+ContentUtilities.m
//  TastingNotes
//
//  Created by Matt on 12/31/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import "AppContent+ContentUtilities.h"

@implementation AppContent (ContentUtilities)

-(void)addToThisNotebookTemplate:(Notebook_Template *)template
                    thisGroupNum:(int)gtnum
           andThisContentTypeNum:(int)ctnum{
    
    NSString *gts = [NSString stringWithFormat: @"%@_GT%i", template.belongsToNotebook.name, gtnum];
    
    Group_Template *gt1 = [self addGroupTemplateWithThisName:gts
                                         toThisNotebookTemplate:template];
    [template addGroupsObject:gt1];
    for(int i=0;i<ctnum;i++){
        NSString *cts = [NSString stringWithFormat: @"%@_CT%i", gts, i + 1];
        ContentType_Template *c = [self addContentTypeTemplateWithThisName:cts
                                                          toThisGroupTemplate:gt1];
        c.type = @"smalltext";
        [gt1 addContentTypesObject:c];
    }
}

-(void)generateTestDataForThisManyNotebooks:(int)notebooks
                      withThisManyContentTypes:(int)contentTypes
                      andWithThisManyNotes:(int)notes{
    //Make notebooks
    for(int ni=1;ni<=notebooks;ni++){
        NSString *notebookName = [NSString stringWithFormat:@"NB%i", ni];
        Notebook *nb = [self addNewNotebookWithThisName:notebookName];
        
        //Add Notebook Templates
        Notebook_Template *nbt = [self addNewNotebookTemplateToThisNotebook:nb];
        
        for(int i=1;i<=contentTypes;i++)
            [self addToThisNotebookTemplate:nbt thisGroupNum:i
                      andThisContentTypeNum:i];
        
        //Add Note Content to each content type in notebook
        for(int i=0;i<=notes;i++){
            Note *n;
            n = [self addNoteToThisNotebook:nb];
            
            [[nbt groupsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                int gi = [[obj order]integerValue];
                Group_Template *gt = obj;
                [[obj contentTypesByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    int ci = [[obj order]integerValue];
                    Content *c = [self addNewContentToThisNote:n
                                              inThisGroupTemplate:gt
                                               andThisContentType:obj];
                    c.data = [NSString stringWithFormat:@"NB%@_GT%i_CT%i_C", n.belongsToNotebook.order, gi, ci];
                }];
            }];
        }
    }
}

@end
