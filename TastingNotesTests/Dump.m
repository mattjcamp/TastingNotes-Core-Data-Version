//
//  Dump.m
//  TastingNotes
//
//  Created by Matt on 12/31/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import "Dump.h"

@implementation Dump

+(void)dumpThisNotebookTemplate:(Notebook *)notebook
                    intoThisLog:(NSMutableString *)log{
    //Notebook
    [log appendFormat:@"NOTEBOOKS[%@].%@\n", notebook.order, notebook.name];
    
    //Notebook Template
    if(notebook.template){
        [log appendFormat:@"   NOTEBOOK.TEMPLATE.%@\n", notebook.template.name];
        
        //Notebook Group Templates
        [[notebook.template groupsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Group_Template *gt = (Group_Template *)obj;
            [log appendFormat:@"       GROUP[%@].%@\n", gt.order, gt.name];
            [[gt contentTypesByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ContentType_Template *ct = (ContentType_Template *)obj;
                [log appendFormat:@"               CONTENT_TYPE[%@].%@.%@\n", ct.order, ct.name, ct.type];
            }];
        }];
    }
}

+(void)dumpThisNotebookContent:(Notebook *)notebook
                   intoThisLog:(NSMutableString *)log{
    //Notebook
    [log appendFormat:@"NOTEBOOKS[%@].%@\n", notebook.order, notebook.name];
    
    [notebook.notesByOrder enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Note *note = (Note *)obj;
        [log appendFormat:@"    NOTE[%@]\n", note.order];
        
        [[note.belongsToNotebook.template groupsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Group_Template *g = (Group_Template *)obj;
            
            [[g contentTypesByOrder]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ContentType_Template *ct = (ContentType_Template *)obj;
                
                Content *c = [note contentInThisGroup:g
                                   andThisContentType:ct];
                if(c)
                    [log appendFormat:@"        %@[%@].%@[%@] = %@\n", g.name.uppercaseString, g.order,
                     ct.name.uppercaseString, ct.order,
                     c.stringData];
                
            }];
        }];
    }];
    
}

@end
