//
//  ContentType_Template+ContentType_Template_Helper.m
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import "ContentType_Template+ContentType_Template_Helper.h"

@implementation ContentType_Template (ContentType_Template_Helper)

-(NSArray *) listObjectsByOrder{
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"order"
                                                             ascending:YES];
    
    return [self.listObjects sortedArrayUsingDescriptors:@[sorter]];
}

-(NSNumber *)maxListObjectOrder{
    NSNumber *max = [self.listObjects valueForKeyPath:@"@max.order"];
    
    return max;
}

@end