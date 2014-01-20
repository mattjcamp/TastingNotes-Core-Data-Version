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
                   intoThisLog:(NSMutableString *)log{
    
    [log appendFormat:@"%@\n", notebook];
    [[notebook notesByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Note *note = (Note *)obj;
        
        [[notebook groupsByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Group_Template *gt = (Group_Template *)obj;
            [log appendFormat:@"   %@\n", gt];
            [[gt contentTypesByOrder] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ContentType_Template *ct = (ContentType_Template *)obj;
                [log appendFormat:@"      %@\n", ct];
                
                Content *c = [note contentInThisGroup:gt
                                   andThisContentType:ct];
                
                if(c){
                    if([ct.type isEqualToString:@"SmallText"] || [ct.type isEqualToString:@"MultiText"]){
                        [log appendFormat:@"          %@\n", c.stringData];
                    }
                    /*if([ct.type isEqualToString:@"Picture"]){
                     [log appendFormat:@"          %@\n", c.binaryData];
                     }*/
                    if([ct.type isEqualToString:@"5StarRating"] || [ct.type isEqualToString:@"Numeric"] || [ct.type isEqualToString:@"Currency"] || [ct.type isEqualToString:@"100PointScale"] || [ct.type isEqualToString:@"Date"]){
                        [log appendFormat:@"          %@\n", c.numberData];
                    }
                    
                    if([ct.type isEqualToString:@"List"]){
                        [[c selectedListObjectsByIdentifier] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            SelectedListObject *slo = (SelectedListObject *)obj;
                            
                            ListObject *lo = [ct listObjectsForThisSelectedObject:slo];
                            
                            [log appendFormat:@"          %@\n", lo];
                        }];
                    }
                }
                
            }];
        }];
    }];
}

@end
