//
//  MessageListCell.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "MessageListCell.h"
#import "TimeManager.h"
#import <JSBadgeView.h>
#import "UIImageView+WebCache.h"

@implementation MessageListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    _badgeView = [[JSBadgeView alloc] initWithParentView:_userImageView alignment:JSBadgeViewAlignmentTopRight];
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = _userImageView.frame.size.width / 2.0;
}


-(void)configureCellWithConversation:(Conversation*)c {
    
    AVObject *myself;
    if ([c.myInfo isEqualToString:SELF_ID]) {
        
        myself = [AVObject objectWithClassName:@"SNUser" objectId:c.friendBasicInfo];
    }else {
        
        myself = [AVObject objectWithClassName:@"SNUser" objectId:c.myInfo];
    }
    
    
        [myself fetch];
       
        NSInteger colorIndex = [[myself objectForKey:@"sportTimeSlot"]integerValue];
        UIColor *color = SPORTSLOT_COLOR_ARRAY[colorIndex];
        [_userImageView.layer setBorderColor:color.CGColor];
        [[_userImageView layer] setBorderWidth:2.0f];
    
        AVFile *image_file = [myself objectForKey:@"icon"];
        [image_file getData];
        [image_file save];
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:image_file.url] placeholderImage:[UIImage imageNamed:@"profile"]];
        if(c.unreadMessageNumber) {
            _badgeView.hidden = NO;
            _badgeView.badgeText = [NSString stringWithFormat:@"%ld", c.unreadMessageNumber];
        } else _badgeView.hidden = YES;
        self.userNameLabel.text = [myself objectForKey:@"name"];
        self.lastTimeLabel.text = [TimeManager getTimeStringFromNSDate:c.conversation.lastMessageAt];
        self.bestSportImage.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[myself objectForKey:@"bestSport"]integerValue]]];
        

    [c.conversation queryMessagesWithLimit:1 callback:^(NSArray *objects, NSError *error) {
        AVIMMessage *message = (AVIMMessage*)objects[0];
        self.lastMessageLabel.text = [objects[0]text];
        self.lastTimeLabel.text = [TimeManager getConvastionTimeStr: [NSDate dateWithTimeIntervalSince1970:message.sendTimestamp / 1000]];
    }];
}
@end
