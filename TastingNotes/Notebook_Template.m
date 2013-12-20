//
//  Notebook_Template.m
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import "Notebook_Template.h"
#import "Group_Template.h"
#import "Notebook.h"


@implementation Notebook_Template

@dynamic name;
@dynamic belongsToNotebook;
@dynamic groups;

-(void)addGroupsObject:(Group_Template *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.groups];
    [tempSet addObject:value];
    self.groups = tempSet;
}

@end
