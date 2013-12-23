//
//  Notebook_Template+Notebook_Template_Helper.m
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import "Notebook_Template+Notebook_Template_Helper.h"

@implementation Notebook_Template (Notebook_Template_Helper)

-(NSArray *) groupsByOrder{
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"order"
                                                             ascending:YES];

    return [self.groups sortedArrayUsingDescriptors:@[sorter]];
}

-(NSNumber *)maxGroupOrder{
    NSNumber *max = [self.groups valueForKeyPath:@"@max.order"];
    
    return max;
}

@end