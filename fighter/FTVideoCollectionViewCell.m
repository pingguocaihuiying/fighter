//
//  FTVideoCollectionViewCell.m
//  fighter
//
//  Created by Liyz on 5/6/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTVideoCollectionViewCell.h"

@implementation FTVideoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    NSLog(@"awakeFromNib");
    self.cellWidthConstraint.constant = self.cellWidthConstraint.constant * SCALE;
    self.cellHeightConstraint.constant = self.cellHeightConstraint.constant * SCALE;
    self.titleLabelTopConstraint.constant = self.titleLabelTopConstraint.constant * SCALE;
}

- (void)setWithBean:(FTVideoBean *)bean{//根据bean设置cell的显示内容

    if ([bean.isReader isEqualToString:@"YES"]) {
        [self.myTitleLabel setTextColor:Main_Text_Color];
    }else {
        [self.myTitleLabel setTextColor:[UIColor whiteColor]];
    }
    
    //设置来源标签的颜色
//    self.fromLabel.textColor = Secondary_Text_Color;
    self.videoLengthLabel.text = bean.videoLength;
    ;

    self.myTitleLabel.text = bean.title;
//    NSLog(@"视频list的 cell img%@", bean.img);
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:bean.img]];
    
    
    //设置评论数、点赞数
    NSString *commentCount = [NSString stringWithFormat:@"(%@)", bean.commentCount];
    NSString *voteCount = [NSString stringWithFormat:@"(%@)", bean.voteCount];
    self.comentCountLabel.text = commentCount;
    self.voteCount.text = voteCount;
    self.viewCountlabel.text = [NSString stringWithFormat:@"(%@)", bean.viewCount];
    
    //根据newsType去设置类型图片
    self.videoTypeImageView.image = [UIImage imageNamed:[FTTools getChLabelNameWithEnLabelName:bean.videosType]];
}

- (void)setWithArenaBean:(FTArenaBean *)bean{
    
//    if ([arenaBean.isReader isEqualToString:@"YES"]) {
//        [self.myTitleLabel setTextColor:Main_Text_Color];
//    }else {
//        [self.myTitleLabel setTextColor:[UIColor whiteColor]];
//    }
    
    //设置来源标签的颜色
    //    self.fromLabel.textColor = Secondary_Text_Color;
//    self.videoLengthLabel.text = arenaBean.videoLength;
//    ;
    
    //隐藏视频时常，源数据暂无
    self.videoLengthLabel.hidden = YES;
    
    self.myTitleLabel.text = bean.title;
    //    NSLog(@"视频list的 cell img%@", bean.img);
//    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:bean.pic]];
    
    if (bean.videoUrlNames == nil) {
        bean.videoUrlNames = @"";
    }
    if (bean.pictureUrlNames == nil) {
        bean.pictureUrlNames = @"";
    }
    
    if (bean.videoUrlNames && ![bean.videoUrlNames isEqualToString:@""]) {//如果有视频图片，优先显示视频图片
        //        NSLog(@"显示视频");
        NSString *firstVideoUrlString = [[bean.videoUrlNames componentsSeparatedByString:@","]firstObject];
        
        firstVideoUrlString = [NSString stringWithFormat:@"%@?vframe/png/offset/0/w/200/h/100", firstVideoUrlString];
        NSString *videoUrlString = [NSString stringWithFormat:@"%@/%@", bean.urlPrefix, firstVideoUrlString];
        if (![videoUrlString hasPrefix:@"http://"]) {
            videoUrlString = [NSString stringWithFormat:@"http://%@", videoUrlString];
        }
        //        NSLog(@"videoUrlString : %@", videoUrlString);
        [self.myImageView sd_setImageWithURL:[NSURL URLWithString:videoUrlString] placeholderImage:nil options:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            _placeHoldImageView.hidden = YES;
//            self.playVideoImageview.hidden = NO;
        }];
//        self.playVideoImageview.hidden = NO;
        
    }else if(bean.pictureUrlNames && ![bean.pictureUrlNames isEqualToString:@""]){//如果没有视频，再去找图片的缩略图
        //        NSLog(@"显示图片缩略图");
        NSString *firstImageUrlString = [[bean.pictureUrlNames componentsSeparatedByString:@","]firstObject];
        //        firstImageUrlString = [NSString stringWithFormat:@"%@?vframe/png/offset/0/w/200/h/100", firstImageUrlString];
        firstImageUrlString = [NSString stringWithFormat:@"%@?imageView2/2/w/200", firstImageUrlString];
        NSString *imageUrlString = [NSString stringWithFormat:@"%@/%@", bean.urlPrefix, firstImageUrlString];
        if (![imageUrlString hasPrefix:@"http://"]) {
            imageUrlString = [NSString stringWithFormat:@"http://%@", imageUrlString];
        }
        
//        [self.myImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:nil options:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
////            _placeHoldImageView.hidden = YES;
//        }];
        [self.myImageView sd_setImageWithURL:[NSURL URLWithString:@"imageUrlString"]];
        }
    //设置评论数、点赞数
    NSString *commentCount = [NSString stringWithFormat:@"(%@)", bean.commentCount];
    NSString *voteCount = [NSString stringWithFormat:@"(%@)", bean.voteCount];
    self.comentCountLabel.text = commentCount;
    self.voteCount.text = voteCount;
    self.viewCountlabel.text = [NSString stringWithFormat:@"(%@)", bean.viewCount];
    
    //根据newsType去设置类型图片
    self.videoTypeImageView.image = [UIImage imageNamed:[FTTools getChLabelNameWithEnLabelName:bean.labels]];
}

- (void)setWithCoachPhotoBean:(FTCoachPhotoBean *)bean{
    
    
    _myTitleLabel.text = bean.title;
    
    
    if (bean.type == 0) {//照片
        _videoMarkImageView.hidden = YES;
        [_myImageView sd_setImageWithURL:[NSURL URLWithString:bean.url] placeholderImage:[UIImage imageNamed:@"小占位图"]];
    } else if (bean.type == 1) {//视频
        _videoMarkImageView.hidden = NO;
//        if (bean.videoImageURL) {
            [_myImageView sd_setImageWithURL:[NSURL URLWithString:bean.videoImageURL] placeholderImage:[UIImage imageNamed:@"小占位图"]];
//        }
        
    }
    
    _viewCountlabel.hidden = YES;
    _voteCount.hidden = YES;
    _comentCountLabel.hidden = YES;
    _videoLengthLabel.hidden = YES;
    _videoTypeImageView.hidden = YES;
    
    _viewButton.hidden = YES;
    _voteButton.hidden = YES;
    _commentButton.hidden = YES;
    _labelViewContainer.hidden = YES;
    _bottomCoontainerView.hidden = YES;
    
}

@end
