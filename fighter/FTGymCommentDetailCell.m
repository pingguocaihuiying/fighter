//
//  FTGymCommentDetailCell.m
//  fighter
//
//  Created by kang on 2016/9/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymCommentDetailCell.h"
#import "CellDelegate.h"
#import "FTGymPhotoCollectionViewCell.h"
#import "NSDate+Tool.h"


@interface FTGymCommentDetailCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    BOOL thumbState;
    NSArray *dataSource;
}

@end

@implementation FTGymCommentDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.CollectionHeightConstraint.constant = 0;
    
    //将多余的部分切掉
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) setImageToIndex:(int) index  levelTag:(GymCommentState) gymCommentState {
    
    NSArray *array = nil;
    switch (gymCommentState) {
        case GymCommentStateComfort:{
            array = @[_comfortImage1,
                      _comfortImage2,
                      _comfortImage3,
                      _comfortImage4,
                      _comfortImage5];
        }
            break;
        case GymCommentStateStrength: {
            array = @[_strengthImage1,
                      _strengthImage2,
                      _strengthImage3,
                      _strengthImage4,
                      _strengthImage5];
        }
            break;
        case GymCommentStateTeachLevel:{
            array = @[_levelImage1,
                      _levelImage2,
                      _levelImage3,
                      _levelImage4,
                      _levelImage5];
            
        }
        default:
            break;
    }
    
    for (int i = index-1; i >= 0 ; i--) {
        UIImageView *imageView = [array objectAtIndex:i];
        [imageView setImage:[UIImage imageNamed:@"火苗-红"]];
    }
    
    for (int i = index; i < 5 ; i++) {
        UIImageView *imageView = [array objectAtIndex:i];
        [imageView setImage:[UIImage imageNamed:@"火苗-灰"]];
    }
}

- (void) setCellContentWithBean:(FTGymCommentBean *)bean {
    
    self.commentbean = bean;
    [self getThumbState];
    // 头像
    if (bean.headUrl.length > 0) {
        [self.avatarMask setHidden:NO];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:bean.headUrl] placeholderImage:[UIImage imageNamed:@"头像-空"]];
    }else {
        [self.avatarMask setHidden:YES];
        [self.avatarImageView setImage:[UIImage imageNamed:@"头像-空"]];
    }
    
    // 用户名
    self.nameLabel.text = bean.createName;
    
    if (bean.createTime > 0) {
        self.timeLabel.text = [NSDate dateString:bean.createTime];
    }
    
    
    // 评论文字内容
    self.detailLabel.text = bean.comment;
    
    // 评分图示
    [self setImageToIndex:bean.comfort levelTag:GymCommentStateComfort];
    [self setImageToIndex:bean.strength levelTag:GymCommentStateStrength];
    [self setImageToIndex:bean.teachLevel levelTag:GymCommentStateTeachLevel];
    
    // 评论数
    if (bean.commentcount > 0) {
        [self.commentButton setTitle:[NSString stringWithFormat:@"(%d)",bean.commentcount] forState:UIControlStateNormal];
    }
    
    // 点赞数
    if (bean.thumbCount > 0) {
        [self.thumbsButton setTitle:[NSString stringWithFormat:@"(%d)",bean.thumbCount] forState:UIControlStateNormal];
    }
    
    
    if (bean.urls.length > 0) {
        if (dataSource == nil) {
            dataSource = [[NSArray alloc]init];
        }
        
        dataSource = [bean.urls componentsSeparatedByString:@","];
        [self setCollectionView];
        self.CollectionHeightConstraint.constant = 80;
    }else {
        
        self.CollectionHeightConstraint.constant = 0;
    }
}

#pragma mark - 点赞
- (void) getThumbState {
    
    [NetWorking getVoteStatusWithObjid:[NSString stringWithFormat:@"%d",self.commentbean.id] andTableName:@"v-gym" andOption:^(BOOL result) {
        
        if (result) {
            thumbState = YES;
            [self.thumbsButton setImage:[UIImage imageNamed:@"点赞pre"] forState:UIControlStateNormal];
        }else {
            thumbState = NO;
            [self.thumbsButton setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
        }
    }];
}

- (IBAction)thumbButtonAction:(id)sender {
    
   
    [NetWorking addVoteWithObjid:[NSString stringWithFormat:@"%d",self.commentbean.id] isAdd:thumbState? NO:YES andTableName:@"v-gym" andOption:^(BOOL result) {
        if (result) {
            
            thumbState = thumbState?NO:YES;
            [self setThumbState:thumbState];
        }
    }];
}


- (void) setThumbState:(BOOL) state {
    
    if (state) {
        
        self.commentbean.thumbCount ++;
        
        [self.thumbsButton setTitle:[NSString stringWithFormat:@"(%d)",self.commentbean.thumbCount] forState:UIControlStateNormal];
        
        [self.thumbsButton setImage:[UIImage imageNamed:@"点赞pre"] forState:UIControlStateNormal];
    }else {
        
        self.commentbean.thumbCount --;
        
        [self.thumbsButton setTitle:[NSString stringWithFormat:@"(%d)",self.commentbean.thumbCount] forState:UIControlStateNormal];
        
        [self.thumbsButton setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    }
}

#pragma mark - 评论
- (IBAction)commentButtonAction:(id)sender {
    
    
}

- (void) setCommentState:(BOOL) state {
    
    if (state) {
        
        self.commentbean.commentcount ++;
        [self.commentButton setTitle:[NSString stringWithFormat:@"(%d)",self.commentbean.thumbCount] forState:UIControlStateNormal];
    }
}

#pragma mark - collectionView
- (void) setCollectionView {
    
    [_collectionView registerNib:[UINib nibWithNibName:@"FTGymPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell1"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *urlPrefix = @"http://7xtvwy.com1.z0.glb.clouddn.com/";
    NSString *urlSuffix = @"?vframe/png/offset/0";
    NSString *imageName = dataSource[indexPath.row];
    NSString *imageURL = [urlPrefix stringByAppendingString:imageName];
    
    NSLog(@"imageURL:%@",imageURL);
    FTGymPhotoCollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
    
    if ([imageName hasSuffix:@"mp4"]) {
        
        cell.isVideoView.hidden = NO;
        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:[imageURL stringByAppendingString:urlSuffix]]];
    }else {
        
        cell.isVideoView.hidden = YES;
        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return CGSizeMake(80 * SCALE, 80 * SCALE);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5;
}

@end
