//
//  ListObject+ListObjectHelper.m
//  TastingNotes
//
//  Created by Matt on 1/19/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "ListObject+ListObjectHelper.h"

@implementation ListObject (ListObjectHelper)

-(NSString *)description{
    return [NSString stringWithFormat:@"LO[%@].%@.%@.%@", self.order, self.name, self.identifier, self.objectDescription];
}

@end
