//
//  MPReplyToolBarView.m
//  kissfire
//
//  Created by Plum on 16/2/3.
//  Copyright © 2016年 manpaoTech. All rights reserved.
//

#import "MPReplyToolBarView.h"

#import "CONST.h"


@interface MPReplyToolBarView ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@end
@implementation MPReplyToolBarView
#pragma mark -
- (void)initNotionCenter
{
     [MPNotificationCenter addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:_textView];
}
- (void)dealloc
{
    [MPNotificationCenter removeObserver:self];
}
#pragma mark -
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        
        [self initView];
        
        [self initNotionCenter];
        
    }
    return self;
}
#pragma mark - 
- (void)initView
{
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    CGFloat left = 15;
    
    CGFloat width = ScreenWidth - left*2;

    CGFloat top = 20;

    CGFloat bottomH = 50;
    
    CGFloat bgH = 75;

    UIView *bgVi = [[UIView alloc]initWithFrame:CGRectMake(left, top, width, bgH)];
    bgVi.backgroundColor = [UIColor whiteColor];
    bgVi.layer.borderColor = Line_COLOR.CGColor;
    bgVi.layer.borderWidth = 1;
    [self addSubview:bgVi];
    self.bgView = bgVi;
    
    [self initBgView];

    CGFloat bottomBtnW = 60;
    
    CGFloat btnImgW = 22;
    CGFloat btnImL = (bottomBtnW - btnImgW)/2;
    CGFloat btnImT = (bottomH - btnImgW)/2;

    CGFloat bottomT = _bgView.bottom;
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
     
        if (i == 0) {
            self.addImgBtn = btn;
            
            [btn setImageEdgeInsets:UIEdgeInsetsMake(btnImT, 0, btnImT, btnImL*2)];
            
            
            btn.frame = CGRectMake(left, bottomT, bottomBtnW, bottomH);

            [btn setImage:[UIImage imageNamed:@"传图1"] forState:0];
            [btn addTarget:self action:@selector(addImgBtnClicked) forControlEvents:UIControlEventTouchUpInside];


        }
        if (i == 1) {
            self.attendBtn = btn;
            
            CGFloat btnW = 55;
            btn.frame = CGRectMake(ScreenWidth - btnW -left, bottomT+btnImT-2, btnW, btnImgW+4);
            
            btn.layer.borderColor = Line_COLOR.CGColor;
            btn.layer.cornerRadius = 2;
            btn.layer.masksToBounds = YES;

            btn.titleLabel.font = [UIFont systemFontOfSize:15];
          
            [btn setTitle:NSLocalizedString(@"Forum_Reply_Send", nil) forState:0];
            [btn setTitleColor:[UIColor colorWithWhite:0.811 alpha:1.000] forState:UIControlStateDisabled];
            [btn setTitleColor:[UIColor whiteColor] forState:0];

            [self PostDisEnable];

        }
    }
  
    
    self.height = bottomT +bottomH +15;

}
- (void)initBgView
{
    
    CGFloat bgH = _bgView.height;
    CGFloat bgW = _bgView.width;
    
    CGFloat imgW = bgH;
    
    CGFloat sep = 5;
    UIImageView *headImgVi = [[UIImageView alloc]initWithFrame:CGRectMake(bgW - imgW +sep, sep, imgW-sep*2, imgW-sep*2)];
    headImgVi.contentMode = UIViewContentModeScaleAspectFill;
    headImgVi.layer.masksToBounds = YES;
    headImgVi.userInteractionEnabled = YES;
    [_bgView addSubview:headImgVi];
    self.imgView = headImgVi;
    
    CGFloat deleteBtnW = 40;
    CGFloat btnImgW = 17;
    CGFloat btnImL = (deleteBtnW - btnImgW)/2;
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(headImgVi.width-deleteBtnW, 0, deleteBtnW, deleteBtnW);
    left.userInteractionEnabled = YES;
    [left addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
    [left setImage:[UIImage imageNamed:@"删除图片"] forState:0];
    [left setImageEdgeInsets:UIEdgeInsetsMake(0, btnImL*2, btnImL*2, 0)];
    [headImgVi addSubview:left];
    
    PlaceholderTextView *contentView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 0, bgW,bgH)];
    contentView.font = [UIFont  systemFontOfSize:15];
    contentView.placeholder = NSLocalizedString(@"Forum_Reply_Hint", nil);
    contentView.placeholderColor = [UIColor lightGrayColor];
    contentView.placeholderFont = [UIFont  systemFontOfSize:15];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.delegate = self;
    //contentView.returnKeyType = UIReturnKeyDone;
    [_bgView addSubview:contentView];
    self.textView = contentView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImage)];
    [headImgVi addGestureRecognizer:tap];


}
#pragma mark -
- (void)deleteImage
{
    chooseImg = nil;
    [self layerImgView];
    
}
- (void)addImgBtnClicked
{
    
    [self tapHeagImg];
    
}


#pragma mark -
- (void)layerImgView
{
    
    CGFloat bgH = _bgView.height;
    CGFloat bgW = _bgView.width;
    CGFloat imgW = bgH;
    
    _imgView.image = chooseImg;
    if (chooseImg) {
       _textView.width = bgW - imgW;
        
    }else{
       _textView.width = bgW;

    }
    

}

#pragma mark- 监听文本改变

-(void)textViewEditChanged:(NSNotification *)obj{
    
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    
    if (![toBeString isEqualToString:@""]) {
        [self PostEnable];
    }else{
        
        [self PostDisEnable];
        
    }
}

- (void)PostEnable
{
    _attendBtn.enabled = YES;
    
    _attendBtn.layer.borderWidth = 0;
    _attendBtn.backgroundColor = BackColor;
    
}
- (void)PostDisEnable
{
    
    _attendBtn.enabled = NO;
    _attendBtn.layer.borderWidth = 1;
    _attendBtn.backgroundColor = [UIColor clearColor];
    
}


#pragma mark-- 更换图片

-(void)tapHeagImg{
    
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
 
    sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    //imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [_selfVc presentViewController:imagePickerController animated:YES completion:^{}];
}


#pragma mark - image picker delegte

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_selfVc dismissViewControllerAnimated:YES completion:Nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *pickImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    chooseImg = pickImage;
    [self layerImgView];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
}


@end
