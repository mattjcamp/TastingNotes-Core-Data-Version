//
//  SelectedListObject+SelectedListObject_Helper.m
//  TastingNotes
//
//  Created by Matt on 1/19/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "SelectedListObject+SelectedListObject_Helper.h"

@implementation SelectedListObject (SelectedListObject_Helper)

-(NSString *)description{
    ListObject *lo = [self.belongsToContent.inThisContent_Type listObjectsForThisSelectedObject:self];
    return [NSString stringWithFormat:@"SLO[%@].%@.%@.%@", lo.order, lo.name, lo.identifier, lo.objectDescription];
}

@end
