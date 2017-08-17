//
//  NewMineQuestionController.m
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/7/27.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "NewMineQuestionController.h"
#import "PhotoNavigationController.h"
#import "PhotoManagerConfig.h"
#import "PhotoRevealCell.h"
#import "UIImage+StackBlur.h"
#import "zoomPopup.h"
#import "UIImage+StackBlur.h"
#import "User.h"
#import "SCLAlertView.h"
#import "Version.h"
#import "APIHelper.h"
#import "UITextView+Placeholder.h"

@interface NewMineQuestionController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,JJPhotoDelegate,HWImagePickerSheetDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UITableView *QuestionTableView;
    UIButton *saveBtn;
    NSInteger  clickImageNumber;
    User *user;
    NSString *questionProblemText;
    
    NSString *pushImageName;

    UILabel *headerLaber;
}
//@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) NSArray <ALAsset *>*dataArray;
//@property (nonatomic, strong) UILabel *imageNotelabel;
//@property (nonatomic, strong) NSMutableArray<UIImage *> * imageArray;
//@property (nonatomic, strong) NSMutableArray<UIImage *> * imageArrayorigin;

@property (nonatomic, strong) Version *version;

@property (nonatomic, strong) HWImagePickerSheet *imgPickerActionSheet;



@end




@implementation NewMineQuestionController


static NSString * const reuseIdentifier = @"HWCollectionViewCell";
static NSString *headerViewIdentifier = @"hederview";
-(instancetype)init{
    self = [super init];
    if (self) {
        if (!_showActionSheetViewController) {
            _showActionSheetViewController = self;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [[User alloc]init];
    self.version = [[Version alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTableView];
}


-(void)setTableView
{
    QuestionTableView=[[UITableView alloc] init];  
    [self.view addSubview:QuestionTableView];
    QuestionTableView.scrollEnabled =NO; //设置tableview 不能滚动
    [QuestionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [QuestionTableView setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"]];
    QuestionTableView.dataSource = self;
    QuestionTableView.delegate = self;
    QuestionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma  get GroupArray count  to set number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        return 155;
    }
    else if (indexPath.row==1)
    {
        return 110;
    }
    else if (indexPath.row==2)
    {
        return 45;
    }
    else
    {
        return 50;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0;//self.view.frame.size.height-360;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        static NSString *Identifier = @"questionCell";
        UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {//重新实例化对象的时候才添加button，队列中已有的cell上面是有button的
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            //添加按钮（或者其它控件）也可以写在继承自UITableViewCell的子类中,然后用子类来实例化这里的cell，将button作为子类的属性，这样添加button的触发事件的响应可以写在这里，target就是本类，方法也在本类中实现
            UILabel *opinionLabel=[[UILabel alloc] init];
            opinionLabel.text = @"问题修改及改进意见：";
            opinionLabel.textColor = [NewAppColor yhapp_3color];
            opinionLabel.font = [UIFont systemFontOfSize:15];
            opinionLabel.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:opinionLabel];
            UITextView *opinionTextview = [[UITextView alloc] init];
//            opinionTextview.text=@"请描述您遇到的问题(1-500字)";
//            opinionTextview.font=[UIFont systemFontOfSize:15];
            opinionTextview.textAlignment = NSTextAlignmentLeft;
            opinionTextview.font = [UIFont systemFontOfSize:15];
            opinionTextview.placeholderLabel.font = [UIFont boldSystemFontOfSize:15];
            opinionTextview.placeholder = @"请描述您遇到的问题(1-500字)";
            opinionTextview.userInteractionEnabled = YES;
            opinionTextview.textColor=[NewAppColor yhapp_4color];
            opinionTextview.delegate=self;
            opinionTextview.keyboardType = UIKeyboardTypeDefault;
            opinionTextview.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0);
            [cell addSubview:opinionTextview];
            
            
            UIView *cellView=[[UIView alloc] init];
            [cell addSubview: cellView];
            [cellView setBackgroundColor:[NewAppColor yhapp_9color]];
            [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left).offset(16);
                make.top.mas_equalTo(cell.mas_bottom).offset(-1);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
            }];
            
            [opinionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top).offset(16);
                make.left.mas_equalTo(cell.mas_left).offset(16);
            }];
            [opinionTextview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top).offset(44);
                make.left.mas_equalTo(cell.mas_left).offset(16);
                make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width-32, 111));
            }];
        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row==1)
    {
        static NSString *Identifier = @"photoCell";
        UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {//重新实例化对象的时候才添加button，队列中已有的cell上面是有button的
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            //添加按钮（或者其它控件）也可以写在继承自UITableViewCell的子类中,然后用子类来实例化这里的cell，将button作为子类的属性，这样添加button的触发事件的响应可以写在这里，target就是本类，方法也在本类中实现
            //此部分 需要宝峰技术支持
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//            layout.headerReferenceSize=CGSizeMake(cell.contentView.frame.size.width,15);
            layout.sectionInset=  UIEdgeInsetsMake(12, 16,20, 20);
            layout.minimumLineSpacing = 4;
            layout.minimumInteritemSpacing = 4;
            layout.itemSize = CGSizeMake(56,56);
            self.pickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,110) collectionViewLayout:layout];
            if (_showInView) {
                [_showInView addSubview:self.pickerCollectionView];
            }else{
                [cell addSubview:self.pickerCollectionView];
            }
             [self initPickerView];
        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row==2)
    {
        static NSString *Identifier = @"photoCell";
        UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {//重新实例化对象的时候才添加button，队列中已有的cell上面是有button的
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            //添加按钮（或者其它控件）也可以写在继承自UITableViewCell的子类中,然后用子类来实例化这里的cell，将button作为子类的属性，这样添加button的触发事件的响应可以写在这里，target就是本类，方法也在本类中实现
            UILabel *stimulateLabel=[[UILabel alloc] init];
            stimulateLabel.text=@"您的鞭策是我们进步的源泉，感谢您的宝贵意见！";
            stimulateLabel.textColor=[UIColor colorWithHexString:@"#666666"];
            stimulateLabel.font=[UIFont systemFontOfSize:13];
            [cell.contentView addSubview:stimulateLabel];
            [stimulateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(cell.contentView.mas_centerX);
                 make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            }];
            [cell setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"]];
        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *Identifier = @"saveCell";
        UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {//重新实例化对象的时候才添加button，队列中已有的cell上面是有button的
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            //添加按钮（或者其它控件）也可以写在继承自UITableViewCell的子类中,然后用子类来实例化这里的cell，将button作为子类的属性，这样添加button的触发事件的响应可以写在这里，target就是本类，方法也在本类中实现
            saveBtn=[[UIButton alloc]init];
            [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
            saveBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
            [saveBtn addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
            [saveBtn setTitleColor:[UIColor colorWithHexString:@"#00a4e9"] forState:UIControlStateNormal];
            [saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
            [saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"]  forState:UIControlStateSelected];
            [saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#f3f3f3"] forState:UIControlStateHighlighted];
            [cell addSubview:saveBtn];
            [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(cell.mas_centerX);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 50));
            }];
        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        
        return cell;
    }
}
/**
 开始编辑
 @param textView textView
 */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请描述您遇到的问题(1-500字)"]) {
        
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text length]==0) {
        textView.text = @"请描述您遇到的问题(1-500字)";
        textView.textColor=[UIColor colorWithHexString:@"bcbcbc"];
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
//        NSLog(@"%@",textView.text);
    textView.textColor=[UIColor colorWithHexString:@"#32414b"];
    questionProblemText=textView.text;
}
//延时执行函数
-(void)delayMethod
{
    self.view.userInteractionEnabled=YES;
    [HudToolView hideLoadingInView:self.view];
    
}

-(void)saveBtn
{
        self.view.userInteractionEnabled=NO;
    
    if ([questionProblemText length]==0) {
        [HudToolView showTopWithText:@"您的反馈意见为空" color:[NewAppColor yhapp_11color]];
        [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];
        return;
    }
    else if ([questionProblemText length]>=500) {
        [HudToolView showTopWithText:@"您的反馈意见长度超长" color:[NewAppColor yhapp_11color]];
        [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];

        return;
    }
    else{
         [HudToolView showLoadingInView:self.view];
        Version *version = [[Version alloc]init];
         NSDictionary *parames = @{
                              @"content":questionProblemText,
                              @"title":@"生意人问题反馈",
                              @"user_num":SafeText(user.userNum),
                              kAPI_TOEKN:ApiToken(YHAPI_USER_UPLOAD_FEEDBACK),
                              @"app_version":version.current,
                              @"platform":@"ios",
                              @"platform_version":version.platform
                              };
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *postString = [NSString stringWithFormat:@"%@%@",kBaseUrl,YHAPI_USER_UPLOAD_FEEDBACK];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:postString parameters:parames constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [self getBigImageArray];
        for (int i = 0; i < self.bigImageArray.count; i++) {
            UIImage *image = self.bigImageArray[i];
            NSData *data = UIImagePNGRepresentation(image);
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"image%d",i] fileName:[NSString stringWithFormat:@"image%d.png",i] mimeType:@"multipart/form-data"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
            [HudToolView showTopWithText:@"提交成功" color:[NewAppColor yhapp_1color]];

            [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];
            
            [self NewQuestionViewBack];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                /*
                 * 用户行为记录, 单独异常处理，不可影响用户体验
                 */
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName] = @"点击/问题反馈/成功";
                [APIHelper actionLog:logParams];
            });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",@"上传失败了");
  
        [HudToolView showTopWithText:@"上传失败，请重试" color:[NewAppColor yhapp_11color]];

        [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName] = @"点击/问题反馈/失败";
            [APIHelper actionLog:logParams];
        });
    }];
    
    }
}


/** 初始化collectionView */
-(void)initPickerView{
    _showActionSheetViewController = self;
    self.pickerCollectionView.delegate=self;
    self.pickerCollectionView.dataSource=self;
    self.pickerCollectionView.backgroundColor = [UIColor whiteColor];
    pushImageName = @"plus.png";
    _pickerCollectionView.scrollEnabled = NO;
    [self.pickerCollectionView  registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    [self.pickerCollectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  _imageArray.count==3? _imageArray.count:_imageArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // Register nib file for the cell
    UINib *nib = [UINib nibWithNibName:@"HWCollectionViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"HWCollectionViewCell"];
    // Set up the reuse identifier
    HWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HWCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == _imageArray.count) {
        [cell.profilePhoto setImage:[UIImage imageNamed:pushImageName]];
        cell.closeButton.hidden = YES;
        
    }
    else{
        [cell.profilePhoto setImage:_imageArray[indexPath.item]];
        cell.closeButton.hidden = NO;
    }
    [cell setBigImageViewWithImage:nil];
    cell.profilePhoto.tag = [indexPath item];
    
    //添加图片cell点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    singleTap.numberOfTapsRequired = 1;
    cell.profilePhoto .userInteractionEnabled = YES;
    [cell.profilePhoto  addGestureRecognizer:singleTap];
    cell.closeButton.tag = [indexPath item];
    [cell.closeButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    [self changeCollectionViewHeight];
    return cell;
}



//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        
        //头视图添加view
        [header addSubview:[self addContent]];
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 30);
}

-(UILabel*)addContent
{
    UILabel *oscreenshotLabel=[[UILabel alloc] init];
    oscreenshotLabel.text=@"页面截图(最多3张)：";
    oscreenshotLabel.textColor=[NewAppColor yhapp_3color];
    oscreenshotLabel.font=[UIFont systemFontOfSize:15];
    oscreenshotLabel.frame=CGRectMake(16,15, self.view.frame.size.width, 15);
    return oscreenshotLabel;
        //headerLaber=oscreenshotLabel;
}

#pragma mark <UICollectionViewDelegate>

#pragma mark - 图片cell点击事件
//点击图片看大图
- (void) tapProfileImage:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
    
    UIImageView *tableGridImage = (UIImageView*)gestureRecognizer.view;
    NSInteger index = tableGridImage.tag;
    
    if (index == (_imageArray.count)) {
        [self.view endEditing:YES];
        //添加新图片
        [self addNewImg];
    }
    else{
        //点击放大查看
        HWCollectionViewCell *cell = (HWCollectionViewCell*)[_pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        if (!cell.BigImageView || !cell.BigImageView.image) {
            
            [cell setBigImageViewWithImage:[self getBigIamgeWithALAsset:_arrSelected[index]]];
        }
        
        JJPhotoManeger *mg = [JJPhotoManeger maneger];
        mg.delegate = self;
        [mg showLocalPhotoViewer:@[cell.BigImageView] selecImageindex:0];
    }
}
- (UIImage*)getBigIamgeWithALAsset:(ALAsset*)set{
    //压缩
    // 需传入方向和缩放比例，否则方向和尺寸都不对
    
    ALAssetRepresentation * representation = [set defaultRepresentation];
    UIImage *img = [UIImage imageWithCGImage:[representation fullScreenImage] scale:1.0 orientation:UIImageOrientationDownMirrored];
    NSData *imageData = UIImagePNGRepresentation(img);
    [_bigImgDataArray addObject:imageData];
    
      NSLog(@"%f,%f",_pickerCollectionView.bounds.size.width,_pickerCollectionView.bounds.size.height);
    return [UIImage imageWithData:imageData];
}
#pragma mark - 选择图片
- (void)addNewImg{
    if (!_imgPickerActionSheet) {
        _imgPickerActionSheet = [[HWImagePickerSheet alloc] init];
        _imgPickerActionSheet.delegate = self;
    }
    if (_arrSelected) {
        _imgPickerActionSheet.arrSelected = _arrSelected;
    }
    _imgPickerActionSheet.maxCount = 3;
    
    [_imgPickerActionSheet showImgPickerActionSheetInView:_showActionSheetViewController];
    
}

#pragma mark - 删除照片
- (void)deletePhoto:(UIButton *)sender{
    
    [_imageArray removeObjectAtIndex:sender.tag];
    [_arrSelected removeObjectAtIndex:sender.tag];
    
    [self.pickerCollectionView reloadData];
//    [self.pickerCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:sender.tag inSection:0]]];
    
    for (NSInteger item = sender.tag; item <= _imageArray.count; item++) {
        HWCollectionViewCell *cell = (HWCollectionViewCell*)[self.pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
        cell.closeButton.tag--;
        cell.profilePhoto.tag--;
    }
    
    [self changeCollectionViewHeight];
}

#pragma mark - 改变view，collectionView高度
- (void)changeCollectionViewHeight{
    return;
    if (_collectionFrameY) {
        _pickerCollectionView.frame = CGRectMake(0, _collectionFrameY, [UIScreen mainScreen].bounds.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /4.0 +20.0)* ((int)(_arrSelected.count)/4 +1)+20.0);
    }
    else{
        _pickerCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /4.0 +20.0)* ((int)(_arrSelected.count)/4 +1)+20.0);
    }
    [self pickerViewFrameChanged];
    
}
/**
 *  相册完成选择得到图片
 */
-(void)getSelectImageWithALAssetArray:(NSArray *)ALAssetArray thumbnailImageArray:(NSArray *)thumbnailImgArray{
    //（ALAsset）类型 Array
    _arrSelected = [NSMutableArray arrayWithArray:ALAssetArray];
    //正方形缩略图 Array
    _imageArray = [NSMutableArray arrayWithArray:thumbnailImgArray] ;
    
    [self.pickerCollectionView reloadData];
}
- (void)pickerViewFrameChanged{
    
}
- (void)updatePickerViewFrameY:(CGFloat)Y{
    
    _collectionFrameY = Y;
    _pickerCollectionView.frame = CGRectMake(0, Y, [UIScreen mainScreen].bounds.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /4.0 +20.0)* ((int)(_arrSelected.count)/4 +1)+20.0);
}

#pragma mark - 防止奔溃处理
-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

- (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

//获得大图
- (NSArray*)getBigImageArrayWithALAssetArray:(NSArray*)ALAssetArray{
    _bigImgDataArray = [NSMutableArray array];
    NSMutableArray *bigImgArr = [NSMutableArray array];
    for (ALAsset *set in ALAssetArray) {
        [bigImgArr addObject:[self getBigIamgeWithALAsset:set]];
    }
    _bigImageArray = bigImgArr;
    return _bigImageArray;
}

#pragma mark - 获得选中图片各个尺寸
- (NSArray*)getALAssetArray{
    return _arrSelected;
}

- (NSArray*)getBigImageArray{
    
    return [self getBigImageArrayWithALAssetArray:_arrSelected];
}

- (NSArray*)getSmallImageArray{
    return _imageArray;
}

- (CGRect)getPickerViewFrame{
    return self.pickerCollectionView.frame;
}


-(void)NewQuestionViewBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
