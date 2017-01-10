//
//  CellForTopic.m
//  
//
//  Created by jokerking on 17/1/8.
//
//

#import "CellForTopic.h"

@interface CellForTopic() 
@property (nonatomic,strong)UIImageView *imgvAvatar;
@property (nonatomic,strong)UILabel     *labelName;
@property (nonatomic,strong)UILabel     *labelPostTime;
@property (nonatomic,strong)UILabel     *labelContent;
@end

@implementation CellForTopic

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup{
    self.imgvAvatar = [UIImageView new];
    self.imgvAvatar.layer.masksToBounds = YES;
    self.imgvAvatar.userInteractionEnabled = YES;
    [self.contentView addSubview:self.imgvAvatar];
    
    self.labelName = [UILabel new];
    self.labelName.font = [UIFont systemFontOfSize:14.0f];
    self.labelName.numberOfLines = 0;
    [self.contentView addSubview:self.labelName];
    
    self.labelPostTime = [UILabel new];
    self.labelPostTime.font = [UIFont systemFontOfSize:10.0f];
    self.labelPostTime.numberOfLines = 0;
    [self.contentView addSubview: self.labelPostTime];
    
    self.labelContent = [UILabel new];
    self.labelContent.font = [UIFont systemFontOfSize:14.0f];
    self.labelContent.numberOfLines = 0;
    [self.contentView addSubview: self.labelContent];
    
    [self layoutUI];
}

-(void) layoutUI{
    __weak typeof(self) weakSelf = self;
    [self.imgvAvatar mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(weakSelf.contentView).offset(10);
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(10);
        make.left.equalTo(weakSelf.imgvAvatar.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.width.mas_equalTo(weakSelf.contentView.frame.size.width - 80);
        make.height.mas_equalTo(16);
        
    }];
    
    [self.labelPostTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labelName.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.imgvAvatar.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.width.mas_equalTo(weakSelf.contentView.frame.size.width - 80);
        make.height.mas_equalTo(16);
    }];
    
    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imgvAvatar.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.bottom.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(weakSelf.contentView.frame.size.width - 80);
        make.height.mas_equalTo(100);
    }];
}

- (void) setModel:(NSDictionary *) model{
    _model = model;
    [self.imgvAvatar setImage:[UIImage imageNamed:@"iconfont-user.png"]];
    self.labelName.text = [_model objectForKey:@"displayname"];
    [self.labelName sizeToFit];
    self.labelPostTime.text = [_model objectForKey:@"postdate"];
    [self.labelPostTime sizeToFit];
    self.labelContent.text = [_model objectForKey:@"postcontent"];
    [self.labelContent sizeToFit];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
