//
//  SmallTextEditorVC.m
//  TastingNotes
//
//  Created by Matt on 3/13/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "SmallTextEditorVC.h"

@interface SmallTextEditorVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property Content *content;
@property (strong) void (^updateCellUI)();

@end

@implementation SmallTextEditorVC

-(id)initWithContent:(Content *)c andDoThisIfContentChanges:(void (^)())updateUI{
    self = [super initWithNibName:@"SmallTextEditorVC" bundle:nil];
    if (self) {
        self.content = c;
        self.updateCellUI = updateUI;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Editor";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonItemStylePlain
                                                                                          target:self action:@selector(doneAction)];
    
    self.navigationItem.rightBarButtonItem.title = @"Done";
    
    self.titleLabel.text = self.content.inThisContent_Type.name;
    [self.contentTextView becomeFirstResponder];
}

-(void)doneAction{
    self.content.stringData = self.contentTextView.text;
    self.updateCellUI();
    [self.navigationController popViewControllerAnimated:YES];
}

@end