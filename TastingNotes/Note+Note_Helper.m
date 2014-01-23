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

#warning These methods do not return any content for Stacie's database...

-(NSArray *) contentInThisGroup:(Group_Template *)group{
    
    NSMutableArray *a = [[NSMutableArray alloc]init];
    
    [self.content enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        Content *c = (Content *)obj;
        if([c.inThisGroup isEqual:group])
            [a addObject:c];
    }];
    
    return a;
}

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
    for(Group_Template *gt in self.belongsToNotebook.groupsByOrder){
        for(ContentType_Template *ct in gt.belongsToNotebook.summaryContentTypesByOrder){
            if([ct.type isEqualToString:@"SmallText"]){
                Content *c = [self contentInThisGroup:gt andThisContentType:ct];
                return ct.name;
            }
        }
    }
    
    return nil;
}

/*Group_Template *gt = [n.belongsToNotebook.groupsByOrder firstObject];
 
 [gt.belongsToNotebook.summaryContentTypesByOrder enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
 ContentType_Template *ct = obj;
 Content *c = [n contentInThisGroup:gt andThisContentType:ct];
 if([ct.type isEqualToString:@"SmallText"]){
 cell.textLabel.text = [NSString stringWithFormat:@"%@", c.stringData];
 }
 if([ct.type isEqualToString:@"Date"]){
 cell.textLabel.text = [NSString stringWithFormat:@"%@", c.numberData];
 }
 /if([ct.type isEqualToString:@"Picture"]){
 cell.imageView.image = [UIImage imageWithData:c.binaryData];
 }
 cell.textLabel.text = c.stringData;
 cell.detailTextLabel.text = [c.numberData stringValue];
 }];*/

@end
