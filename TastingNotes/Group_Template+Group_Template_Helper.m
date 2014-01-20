//
//  Group_Template+Group_Template_Helper.m
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import "Group_Template+Group_Template_Helper.h"

@implementation Group_Template (Group_Template_Helper)

-(NSArray *) contentTypesByOrder{
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"order"
                                                             ascending:YES];
    
    return [self.contentTypes sortedArrayUsingDescriptors:@[sorter]];
}

-(NSNumber *)maxContentTypeOrder{
    NSNumber *max = [self.contentTypes valueForKeyPath:@"@max.order"];
    
    return max;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"GT[%@].%@", self.order, self.name];
}

@end
