//
//  Content+Content_Helper.m
//  TastingNotes
//
//  Created by Matt on 1/18/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "Content+Content_Helper.h"

@implementation Content (Content_Helper)

-(NSArray *) selectedListObjectsByIdentifier{
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"identifier"
                                                             ascending:YES];
    
    return [self.selectedListObjects sortedArrayUsingDescriptors:@[sorter]];
}

-(NSString *)description{
    if([self.inThisContent_Type.type isEqualToString:@"SmallText"]
       || [self.inThisContent_Type.type isEqualToString:@"MultiText"]){
        
        return self.stringData;
    }
    
    if([self.inThisContent_Type.type isEqualToString:@"Picture"]){
     return [NSString stringWithFormat: @"Binary Data.length: %i", [self.binaryData length]];
     }
    
    if([self.inThisContent_Type.type isEqualToString:@"5StarRating"] ||
       [self.inThisContent_Type.type isEqualToString:@"Numeric"] ||
       [self.inThisContent_Type.type isEqualToString:@"Currency"]
       || [self.inThisContent_Type.type isEqualToString:@"100PointScale"] ||
       [self.inThisContent_Type.type isEqualToString:@"Date"]){
        
        return [self.numberData stringValue];
    }
    
    if([self.inThisContent_Type.type isEqualToString:@"List"]){
        NSMutableString *listObjects = [[NSMutableString alloc]init];
        [[self selectedListObjectsByIdentifier] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SelectedListObject *slo = (SelectedListObject *)obj;
            ListObject *lo = [self.inThisContent_Type listObjectsForThisSelectedObject:slo];
            [listObjects appendFormat:@"%@\n", lo];
        }];
        
        return listObjects;
    }
    return nil;
}

@end