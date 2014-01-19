//
//  Notebook+Notebook_Helper.h
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import "Notebook.h"

@interface Notebook (Notebook_Helper)

-(NSArray *) notesByOrder;
-(NSNumber *)maxNoteOrder;
-(NSArray *) groupsByOrder;
-(NSNumber *)maxGroupOrder;

@end
