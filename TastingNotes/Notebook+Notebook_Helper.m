//
//  Notebook+Notebook_Helper.m
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import "Notebook+Notebook_Helper.h"

@implementation Notebook (Notebook_Helper)

-(NSArray *) notesByOrder{
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"order"
                                                             ascending:YES];
    
    return [self.notes sortedArrayUsingDescriptors:@[sorter]];
}

-(NSNumber *)maxNoteOrder{
    NSNumber *max = [self.notes valueForKeyPath:@"@max.order"];
    
    return max;
}

-(NSArray *) groupsByOrder{
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"order"
                                                             ascending:YES];
    
    return [self.groups sortedArrayUsingDescriptors:@[sorter]];
}

-(NSNumber *)maxGroupOrder{
    NSNumber *max = [self.groups valueForKeyPath:@"@max.order"];
    
    return max;
}

-(NSArray *) summaryContentTypesByOrder{
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"order"
                                                             ascending:YES];
    
    return [self.summaryContentTypes sortedArrayUsingDescriptors:@[sorter]];
}

-(NSString *)description{
    return [NSString stringWithFormat:@"NB[%@].%@", self.order, self.name];
}

@end