//
//  ChatCell.h
//  SporNetApp
//
//  Created by 浦明晖 on 8/18/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell
-(void)configureCellWithMessage:(AVIMMessage*)message previousMessage:(AVIMMessage*)previousMessage receiver:(AVObject*)receiver;
@property UIImageView *userImageView;
@property UIButton *textButton;
@property UILabel *timeLabel;
@property BOOL showTimeLabel;
@end
