//
//  NotesTVC.m
//  TastingNotes
//
//  Created by Matt on 1/18/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "NotesTVC.h"

@interface NotesTVC ()

@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@end

@implementation NotesTVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.notebook = [[AppContent sharedContent] appState].selectedNotebook;
    self.titleButton.titleLabel.text = self.notebook.name;
    [[self tableView] reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.notebook.notes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Note *n = [self.notebook.notesByOrder objectAtIndex:indexPath.row];
    cell.textLabel.text = [n title];
    cell.imageView.image = [n image];
    
    return cell;
}

@end
