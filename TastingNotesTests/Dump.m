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
                [[ct listObjectsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ListObject *lo = (ListObject *)obj;
                    [log appendFormat:@"                    LISTOBJECT[%@-%@].%@\n", lo.identifier, lo.order, lo.name];
                }];
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
            
            [log appendFormat:@"        GROUP[%@].%@\n", g.order, g.name];
            
            [[g contentTypesByOrder]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ContentType_Template *ct = (ContentType_Template *)obj;
                
                Content *c = [note contentInThisGroup:g
                                   andThisContentType:ct];
                
                if(c){
                    [log appendFormat:@"            CONTENT_TYPE[%@].%@", ct.order, ct.name];
                    if([ct.type isEqualToString:@"SmallText"] || [ct.type isEqualToString:@"MultiText"]){
                        [log appendFormat:@".%@", c.stringData];
                    }
                    /*if([ct.type isEqualToString:@"Picture"]){
                        [log appendFormat:@".%@", c.binaryData];
                    }*/
                    if([ct.type isEqualToString:@"5StarRating"] || [ct.type isEqualToString:@"Numeric"] || [ct.type isEqualToString:@"Currency"] || [ct.type isEqualToString:@"100PointScale"] || [ct.type isEqualToString:@"Date"]){
                        [log appendFormat:@".%@", c.numberData];
                    }
                    
                    if([ct.type isEqualToString:@"List"]){
                        [[c selectedListObjectsByIdentifier] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            SelectedListObject *slo = (SelectedListObject *)obj;
                            
                            ListObject *lo = [ct listObjectsForThisSelectedObject:slo];
                            
                            [log appendString:@"\n"];
                            [log appendFormat:@"                %@[%@]", lo.name, lo.identifier];
                        }];
                    }
                    [log appendString:@"\n"];
                }
            }];
        }];
    }];
}

@end
