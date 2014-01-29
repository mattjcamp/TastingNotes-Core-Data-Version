//
//  NotesTVC.m
//  TastingNotes
//
//  Created by Matt on 1/18/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "NotesTVC.h"
#import "NoteCVC.h"

@interface NotesTVC ()

@property (weak, nonatomic) UIButton *navbarTitleButton;

@end

@implementation NotesTVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navbarTitleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.navbarTitleButton setTitle:self.notebook.name
                            forState:UIControlStateNormal];
    [self.navbarTitleButton addTarget:self
                               action:@selector(presentNotebooks)
                     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.navbarTitleButton;
}

-(void)presentNotebooks{
    [self performSegueWithIdentifier:@"NBChooser"
                              sender:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.notebook = [[AppContent sharedContent] appState].selectedNotebook;
    [self.navbarTitleButton setTitle:self.notebook.name
                            forState:UIControlStateNormal];
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
    cell.detailTextLabel.text = @"##########\n##########\n##########\n##########\n##########\n";
    cell.imageView.image = [n image];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ToNote"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Note *n = [self.notebook.notesByOrder objectAtIndex:indexPath.row];
        NoteCVC *ncvc = segue.destinationViewController;
        ncvc.note = n;
    }
}

@end
