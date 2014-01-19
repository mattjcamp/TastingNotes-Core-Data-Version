//
//  ContentType_Template.m
//  TastingNotes
//
//  Created by Matt on 1/19/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "ContentType_Template.h"
#import "Content.h"
#import "Group_Template.h"
#import "ListObject.h"


@implementation ContentType_Template
@synthesize pk;
@dynamic name;
@dynamic order;
@dynamic type;
@dynamic belongsToGroup;
@dynamic contentInThisContent_Type;
@dynamic listObjects;

@end
