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
    content.inThisContent_Type = contentType;
    [self addContentObject:content];
    
}

//Should be ordeded by content type order...
-(NSArray *) contentInThisGroup:(Group_Template *)group{
    
    NSMutableArray *a = [[NSMutableArray alloc]init];
    
    [self.content enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        Content *c = (Content *)obj;
        if([c.inThisGroup isEqual:group])
            [a addObject:c];
    }];
    
    return a;
}

//Seems suspect...
-(Content *) contentInThisGroup:(Group_Template *)group
             andThisContentType:(ContentType_Template *)contentType{
    
    NSArray *a = [self contentInThisGroup:group];
    __block Content *returnContent;
    [a enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Content *c = (Content *)obj;
        if([c.inThisContent_Type isEqual:contentType])
            returnContent = c;
    }];
    
    return returnContent;
}

-(NSString *) description{
    return [NSString stringWithFormat:@"%@", [self title]];
}

-(NSString *) title{
    for(ContentType_Template *ct in self.belongsToNotebook.summaryContentTypesByOrder){
        if([ct.type isEqualToString:@"SmallText"]){
            Content *c = [self contentInThisGroup:ct.belongsToGroup
                               andThisContentType:ct];
            return c.stringData;
        }
    }
    return nil;
}

-(UIImage *) image{
    for(ContentType_Template *ct in self.belongsToNotebook.summaryContentTypesByOrder){
        if([ct.type isEqualToString:@"Picture"]){
            Content *c = [self contentInThisGroup:ct.belongsToGroup
                               andThisContentType:ct];
            return [UIImage imageWithData:c.binaryData];
        }
    }
    return nil;
}

@end
