//
//  NotebookChooserTVC.m
//  TastingNotes
//
//  Created by Matt on 1/20/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "NotebookChooserTVC.h"

@interface NotebookChooserTVC ()

@end

@implementation NotebookChooserTVC

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[AppContent sharedContent] notebooks] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Notebook *n = [[[AppContent sharedContent] notebooks] objectAtIndex:indexPath.row];
    cell.textLabel.text = n.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Notebook *n = [[[AppContent sharedContent] notebooks] objectAtIndex:indexPath.row];
    [[AppContent sharedContent] appState].selectedNotebook = n;
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismisses");
    }];
}

@end
