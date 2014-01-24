//
//  AppDelegate.m
//  TastingNotes
//
//  Created by Matt on 12/20/13.
//  Copyright (c) 2013 Mobile App Mastery. All rights reserved.
//

#import "AppDelegate.h"
#import "SQLiteUpdater.h"

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    AppContent *ac = [AppContent sharedContent];
    if(ac.notebooks.count == 0){
        [[AppContent sharedContent]removeAllContent];
        SQLiteUpdater *se = [[SQLiteUpdater alloc]init];
        [se importSQLtoCoreData];
    }
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    [[AppContent sharedContent] save];
}

@end
