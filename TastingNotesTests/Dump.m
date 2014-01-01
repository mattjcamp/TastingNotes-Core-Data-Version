//
//  Dump.m
//  TastingNotes
//
//  Created by Matt on 12/31/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import "Dump.h"

@implementation Dump

+(void)dumpThisNotebook:(Notebook *)notebook
            intoThisLog:(NSMutableString *)log{
    //Notebook Template
    [log appendString:@"NOTEBOOKS\n"];
    [log appendFormat:@"%@[%@]\n", notebook.name, notebook.order];
    
    //Notebook Template Tests
    [log appendString:@"   NOTEBOOK.TEMPLATE\n"];
    [log appendFormat:@"   %@\n", notebook.template.name];
    
    //Notebook Group Template Tests
    [log appendString:@"       GROUP TEMPLATES\n"];
    [[notebook.template groupsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Group_Template *gt = (Group_Template *)obj;
         [log appendFormat:@"       %@[%@]\n", gt.name, gt.order];
        
        //Notebook Group Template Content_Type Template Tests
        [log appendString:@"           CONTENT_TYPE TEMPLATES\n"];
        
        [[gt contentTypesByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ContentType_Template *ct = (ContentType_Template *)obj;
            [log appendFormat:@"               %@[%@]\n", ct.name, ct.order];
            [log appendFormat:@"               type = %@\n", ct.type];
        }];
    }];
    
    //Notebook Content
    [log appendString:@"\nNOTES\n"];
    [notebook.notesByOrder enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Note *note = (Note *)obj;
        [log appendFormat:@"NOTE[%@]\n", note.order];
        
        [[note.belongsToNotebook.template groupsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Group_Template *g = (Group_Template *)obj;
            [log appendFormat:@"        %@[%@]\n", g.name.uppercaseString, g.order];
            
            [[g contentTypesByOrder]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ContentType_Template *ct = (ContentType_Template *)obj;
                [log appendFormat:@"               %@[%@]\n", ct.name.uppercaseString, ct.order];
                
                Content *c = [note contentInThisGroup:g
                                   andThisContentType:ct];
                if(c){
                    [log appendString:@"                   CONTENT\n"];
                    [log appendFormat:@"                   data =  %@\n", c.data];
                }
                
            }];
        }];
    }];
}

@end
