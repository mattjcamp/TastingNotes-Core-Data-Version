//
//  Note+Note_Helper.h
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import "Note.h"

@interface Note (Note_Helper)

-(void)addThisContent:(Content *)content
          ToThisGroup:(Group_Template *)group
    inThisContentType:(ContentType_Template *)contentType;

-(NSArray *) contentInThisGroup:(Group_Template *)group;

-(Content *) contentInThisGroup:(Group_Template *)group
             andThisContentType:(ContentType_Template *)contentType;

-(NSString *) title;

@end