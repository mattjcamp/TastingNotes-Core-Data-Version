//
//  AppContent+ContentUtilities.h
//  TastingNotes
//
//  Created by Matt on 12/31/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import "AppContent.h"

@interface AppContent (ContentUtilities)

-(void)addToThisNotebookTemplate:(Notebook_Template *)template
                    thisGroupNum:(int)gtnum
           andThisContentTypeNum:(int)ctnum;

-(void)generateTestDataForThisManyNotebooks:(int)notebooks
                      withThisManyContentTypes:(int)contentTypes
                   andWithThisManyNotes:(int)notes;

@end