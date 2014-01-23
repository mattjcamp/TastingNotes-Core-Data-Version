//
//  Dump.h
//  TastingNotes
//
//  Created by Matt on 12/31/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dump : NSObject

+(void)dumpThisNotebookTemplate:(Notebook *)notebook
            intoThisLog:(NSMutableString *)log;
+(void)dumpThisNotebookContent:(Notebook *)notebook
                   intoThisLog:(NSMutableString *)log
           includingBinaryData:(BOOL)includeBinary;
+(void)dumpNoteSummariesForThisNotebook:(Notebook *)notebook
                            intoThisLog:(NSMutableString *)log;

@end
