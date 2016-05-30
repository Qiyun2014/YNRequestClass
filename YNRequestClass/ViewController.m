//
//  ViewController.m
//  YNRequestClass
//
//  Created by qiyun on 16/5/28.
//  Copyright © 2016年 qiyun. All rights reserved.
//

#import "ViewController.h"
#import "YNTextAttachment.h"

@interface ViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView    *textView;
@property (nonatomic, copy) NSMutableAttributedString *attributedString;
@property (nonatomic, copy) NSTextContainer *textContainer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                          target:self
                                                                          action:@selector(insertImage:)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.view addSubview:self.textView];
}

- (UITextView *)textView{
    
    if (!_textView) {
        
        // 文本容器
        NSTextStorage *storage = [[NSTextStorage alloc] initWithString:@"输入文本..."];
        
        // 文本容器的布局管理器
        NSLayoutManager *layoutManager = [NSLayoutManager new];
        [storage addLayoutManager:layoutManager];
        _textContainer = [[NSTextContainer alloc] initWithSize:self.view.frame.size];
        [layoutManager addTextContainer:_textContainer];
        
        _textView = [[UITextView alloc] initWithFrame:self.view.frame textContainer:_textContainer];
        _textView.editable      = YES;
        _textView.scrollEnabled = YES;
        _textView.delegate      = self;
        _textView.dataDetectorTypes = UIDataDetectorTypeLink;

    }
    return _textView;
}

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    //Or you can get the image url from AssetsLibrary
    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if ([_attributedString length]) {
        
        _attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    }else
        _attributedString = [[NSMutableAttributedString alloc]initWithString:self.textView.text?self.textView.text:@""
                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    
    /* 创建图片内容 */
    YNTextAttachment *attachment = [[YNTextAttachment alloc] initWithImage:image];
    NSAttributedString *text = [NSAttributedString attributedStringWithAttachment:attachment];
    if ([_attributedString length]) [_attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\t"]];
    
    /* 图片之前文本长度 */
    NSInteger textLength = [_attributedString.string length];
    [_attributedString appendAttributedString:text];
    
    /* 添加图片链接跳转 */
    [_attributedString addAttribute:NSLinkAttributeName
                              value:[NSURL URLWithString:@"http://www.baidu.com"]
                              range:NSMakeRange(textLength, [_attributedString.string length] - textLength)];
    
    [_attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n\t"]];
    
    self.textView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), attachment.image.size.height);
    _textContainer.size = self.textView.contentSize;

    self.textView.attributedText = _attributedString;
    self.textView.editable = NO;
   // NSLog(@"计算的页码数:%f", [_textView sizeThatFits:CGSizeMake(300, FLT_MAX)].height / 540.f);
}



- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
    
    NSLog(@"URL tap handle:%@",URL);
    [[UIApplication sharedApplication] openURL:URL];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
    
    [textView.layoutManager invalidateDisplayForCharacterRange:characterRange];//refresh display
    [textView.layoutManager invalidateLayoutForCharacterRange:characterRange actualCharacterRange:NULL];//refresh layout
    
    NSLog(@"image = %@",textAttachment.image);
    NSLog(@"type = %@",textAttachment.fileType);
    
    return YES;
}



- (void)insertImage:(UIBarButtonItem *)item{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
