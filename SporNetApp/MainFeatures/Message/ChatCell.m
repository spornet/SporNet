//
//  ChatCell.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/18/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "ChatCell.h"
#import "TimeManager.h"
#define marginFromIconToLeftEdge 10
#define marginFromIconToTopEdge 10
#define marginFromBubbleToIcon 10
#define iconWidth 35
#define insetToBubbleEdge 30
@implementation ChatCell

- (void)awakeFromNib {
    // Initialization code
    _userImageView = [[UIImageView alloc]init];
    _textButton = [[UIButton alloc]init];
    _timeLabel = [[UILabel alloc]init];
    self.showTimeLabel = NO;
    
}

-(void)configureCellWithMessage:(AVIMMessage*)message previousMessage:(AVIMMessage *)previousMessage receiver:(AVObject*)receiver {
    if(previousMessage == nil) self.showTimeLabel = YES;
    else  {
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:message.sendTimestamp];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:previousMessage.sendTimestamp];
    if ([date1 timeIntervalSinceDate:date2] >= 300) self.showTimeLabel = YES;
    else self.showTimeLabel = NO;
    }
    
    self.timeLabel.frame = self.showTimeLabel?CGRectMake(0, 0, 50, 10):CGRectMake(0, 0, 0, 0);
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.center = CGPointMake(SCREEN_WIDTH / 2,10);
    self.timeLabel.text = [TimeManager getTimeStringFromNSDate:[NSDate dateWithTimeIntervalSince1970:message.sendTimestamp]];
    self.timeLabel.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.timeLabel];
    
    NSString *text = [(AVIMTypedMessage*)message text];
    //NSString *text = @"what the fuck? Why should i do these shit.";
    CGSize contentStrSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 100, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial" size:15.0]}
                                               context:nil].size;
    
    if(message.ioType == AVIMMessageIOTypeIn) {
        _userImageView.frame = CGRectMake(marginFromIconToLeftEdge, self.timeLabel.frame.size.height + marginFromIconToTopEdge, iconWidth, iconWidth);
        
        self.userImageView.image = [UIImage imageWithData:[[receiver objectForKey:@"icon"]getData]];
        _textButton.frame = CGRectMake(marginFromIconToLeftEdge + marginFromBubbleToIcon + iconWidth, self.timeLabel.frame.size.height + marginFromIconToTopEdge, contentStrSize.width + insetToBubbleEdge, contentStrSize.height + 10);
        //_textButton.backgroundColor = [UIColor greenColor];
        _textButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(40, 15, 0, 5);
        UIImage *backgroundButtonImage = [[UIImage imageNamed:@"messageBubbleLeft"]
                                          resizableImageWithCapInsets:edgeInsets];
        [self.textButton setBackgroundImage:backgroundButtonImage
                                   forState:UIControlStateNormal];

    }
    else  {
        _userImageView.frame = CGRectMake(SCREEN_WIDTH - marginFromIconToLeftEdge - iconWidth, self.timeLabel.frame.size.height + marginFromIconToTopEdge, iconWidth, iconWidth);
        self.userImageView.image = [UIImage imageWithData:[[[AVUser currentUser] objectForKey:@"icon"]getData]];
        
        _textButton.frame = CGRectMake(SCREEN_WIDTH - marginFromIconToLeftEdge - marginFromBubbleToIcon - insetToBubbleEdge - iconWidth- contentStrSize.width, self.timeLabel.frame.size.height + marginFromIconToTopEdge, contentStrSize.width + insetToBubbleEdge, contentStrSize.height + 10);
        //_textButton.backgroundColor = [UIColor greenColor];
        _textButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(40, 5, 0, 15);
        UIImage *backgroundButtonImage = [[UIImage imageNamed:@"messageBubbleRight"]
                                          resizableImageWithCapInsets:edgeInsets];
        [self.textButton setBackgroundImage:backgroundButtonImage
                                   forState:UIControlStateNormal];
    }
    
    self.textButton.titleLabel.numberOfLines = 0;
    [self.textButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.textButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.textButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [self.textButton setTitle:text forState:normal];
    
    
    [self.contentView addSubview:_userImageView];
    [self.contentView addSubview:_textButton];

}
@end
