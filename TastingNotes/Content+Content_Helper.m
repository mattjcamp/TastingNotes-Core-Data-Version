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

@end