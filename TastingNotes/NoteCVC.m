//
//  NoteCVC.m
//  TastingNotes
//
//  Created by Matt on 1/29/14.
//  Copyright (c) 2014 Mobile App Mastery. All rights reserved.
//

#import "NoteCVC.h"
#import "CCVC.h"
#import "ViewFactory.h"

@interface NoteCVC ()

@end

@implementation NoteCVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = self.note.title;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.note.belongsToNotebook groups].count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Group_Template *gt = [[self.note.belongsToNotebook groupsByOrder]objectAtIndex:indexPath.row];
    
    CCVC *cvc = [collectionView dequeueReusableCellWithReuseIdentifier:@"CVCCell"
                                                          forIndexPath:indexPath];
    
    ViewFactory *vf = [[ViewFactory alloc]initWithGroupTemplate:gt
                                                        andNote:self.note
                       forThisContainerFrame:cvc.frame];
    
    cvc.myLabel.text = gt.name;
    cvc.myScrollView.pagingEnabled = YES;
    
    [gt.contentTypesByOrder enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [cvc.myScrollView addSubview:[vf viewForContentType:obj]];
    }];
    
    /*[cvc.myScrollView addSubview:[vf testView]];
    [cvc.myScrollView addSubview:[vf testLabel]];
    
    for (int i =0; i<50; i++) {
        UIView *v = [vf testView];
        v.backgroundColor = [UIColor grayColor];
        [cvc.myScrollView addSubview:v];
    }*/
    
    cvc.myScrollView.contentSize = CGSizeMake(cvc.contentView.frame.size.width, vf.totalHeight);
    
    return cvc;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

@end