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
    [log appendFormat:@"%@\n", notebook];
    [log appendString:@"   Summary: "];
    [notebook.summaryContentTypesByOrder enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ContentType_Template *sct = obj;
        [log appendFormat:@"%@, ", sct.name];
    }];
    [log appendString:@"\n"];
    [[notebook groupsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Group_Template *gt = (Group_Template *)obj;
        [log appendFormat:@"   %@\n", gt];
        [[gt contentTypesByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ContentType_Template *ct = (ContentType_Template *)obj;
            [log appendFormat:@"      %@\n", ct];
            [[ct listObjectsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ListObject *lo = (ListObject *)obj;
                [log appendFormat:@"         %@\n", lo];
            }];
        }];
    }];
}

+(void)dumpThisNotebookContent:(Notebook *)notebook
                   intoThisLog:(NSMutableString *)log
           includingBinaryData:(BOOL)includeBinary{
    [log appendFormat:@"%@\n", notebook];
    [[notebook notesByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Note *note = (Note *)obj;
        [log appendFormat:@"   N[%@]\n", note];
        [[notebook groupsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Group_Template *gt = (Group_Template *)obj;
            [log appendFormat:@"   %@\n", gt];
            [[gt contentTypesByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ContentType_Template *ct = (ContentType_Template *)obj;
                [log appendFormat:@"      %@\n", ct];
                Content *c = [note contentInThisGroup:gt
                                   andThisContentType:ct];
                if([ct.type isEqualToString:@"List"]){
                    [c.selectedListObjectsByIdentifier enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [log appendFormat:@"         %@\n", obj];
                    }];
                }
                else{
                    if([ct.type isEqualToString:@"Picture"] && includeBinary){
                        [log appendFormat:@"         %@\n", c.binaryData];
                    }
                    else{
                        [log appendFormat:@"         %@\n", c];
                    }
                }
            }];
        }];
    }];
}

@end
