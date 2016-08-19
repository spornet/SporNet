//
//  SNInputView.m
//  Messaging
//
//  Created by Peng on 8/16/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNInputView.h"

@interface SNInputView ()< UITextFieldDelegate>


@end

@implementation SNInputView


+ (instancetype)viewWithNib {
    
    return [[[NSBundle mainBundle]loadNibNamed:@"SNInputView" owner:nil options:nil]lastObject];
}


@end
