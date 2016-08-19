//
//  SNMessageViewCell.m
//  Messaging
//
//  Created by Peng on 8/16/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNMessageViewCell.h"
#import "SNChatModelFrame.h"
#import "SNChatModel.h"
#import "UIImage+YFResizing.h"

@interface SNMessageViewCell ()
/**
 *  Show the conversation time
 */
@property (nonatomic, weak) UILabel *timeLabel;
/**
 *  User Profile Button
 */
@property (nonatomic, weak) UIButton *userProfileBtn;
/**
 *  Message Content Button
 */
@property (nonatomic, weak) UIButton *messageContentBtn;

@end

@implementation SNMessageViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"Cell";
    
    SNMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[self alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //Set Cell Background Color
//        self.backgroundColor = BackGround243Color;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // Add All Subviews
        UILabel *timeLab = [[UILabel alloc] init];
        timeLab.backgroundColor = [UIColor grayColor];
        timeLab.textColor = [UIColor whiteColor];
        timeLab.textAlignment = NSTextAlignmentCenter;
        
        // Set Font Color
//        timeLab.font = kTimeFont;
        timeLab.layer.cornerRadius = 5;
        timeLab.clipsToBounds = YES;
        [self.contentView addSubview:timeLab];
        self.timeLabel = timeLab;
        
        // Set User Profile Button
        
        UIButton *userIconBtn = [[UIButton alloc] init];
     
        [userIconBtn addTarget:self action:@selector(showDetailUserInfo) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview: userIconBtn];
        self.userProfileBtn = userIconBtn;
        
        // Set Message Content Button
        
        UIButton *contentTextBtn = [[UIButton alloc] init];
        
//        contentTextBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentEdgeTop, kContentEdgeLeft, kContentEdgeBottom, kContentEdgeRight);
        
        // Set Message Content Font Size
        
//        contentTextBtn.titleLabel.font = kContentTextFont;
        contentTextBtn.titleLabel.numberOfLines = 0;
        
        [contentTextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [contentTextBtn addTarget:self action:@selector(contentChatTouchUpInside) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview: contentTextBtn];
        self.messageContentBtn = contentTextBtn;
    }
    
    return self;
}

- (void)modelFrame:(SNChatModelFrame *)modelFrame
{
    _modelFrame = modelFrame;
    
    SNChatModel *chat = modelFrame.chat;
    self.timeLabel.text = chat.timeStr;
    
    // 如果是真实开发,此处应该用SDWebImage根据URL取图片
    [self.userProfileBtn setImage:[UIImage imageNamed: chat.userIcon] forState: UIControlStateNormal];
    [self.messageContentBtn setBackgroundImage: [UIImage yf_resizingWithIma:chat.contectTextBackgroundIma] forState: UIControlStateNormal];
    [self.messageContentBtn setBackgroundImage: [UIImage yf_resizingWithIma:chat.contectTextBackgroundHLIma] forState: UIControlStateHighlighted];
    [self.messageContentBtn setTitle: chat.contentText forState: UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.timeLabel.frame = self.modelFrame.timeFrame;
//    
//    self.userProfileBtn.frame = self.modelFrame.iconFrame;
//    self.messageContentBtn.frame = self.modelFrame.contentFrame;
    
}

#pragma mark - 私有方法
- (void)showDetailUserInfo
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}

- (void)contentChatTouchUpInside
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}

@end
