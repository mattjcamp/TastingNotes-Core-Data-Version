//
//  Note+Note_Helper.m
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import "Note+Note_Helper.h"

@implementation Note (Note_Helper)

-(void)addThisContent:(Content *)content
          ToThisGroup:(Group_Template *)group
    inThisContentType:(ContentType_Template *)contentType{
    
    content.belongsToNote = self;
    content.inThisGroup = group;
    [self addContentObject:content];
    
    
}

-(NSArray *) contentInThisGroup:(Group_Template *)group{
    
    NSMutableArray *a = [[NSMutableArray alloc]init];
    
    [self.content enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        Content *c = (Content *)obj;
        if([c.inThisGroup isEqual:group])
            [a addObject:c];
    }];
    
    return a;
}

@end
