//
//  ViewController.m
//  MySafari
//
//  Created by GLB-MXM0004 on 01/10/14.
//  Copyright (c) 2014 Hugo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *buttonFoward;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
@property (weak, nonatomic) IBOutlet UILabel *pageTitleLabel;

@property (nonatomic) CGFloat previousScrollViewYOffset;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUrlString:@"http://www.mobilemakers.co"];
    [self checkCanFoward];
    [self checkCanBack];
    self.urlTextField.text= [NSString stringWithFormat:@"http://"];
    
    self.urlTextField.clearButtonMode = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkCanFoward{
    if (![self.webView canGoForward]) {
        self.buttonFoward.enabled = NO;
    }else
        self.buttonFoward.enabled=YES;
}

-(void)checkCanBack{
    if (![self.webView canGoBack]) {
        self.buttonBack.enabled = NO;
    }else
        self.buttonBack.enabled = YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSURL *url = [NSURL URLWithString:self.urlTextField.text];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    
    return YES;
}


- (void)loadUrlString: (NSString *)urlString{
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
   
    //Displaying page title in pageTitleLabel
    
    [self.webView loadRequest:urlRequest];
    
}


- (IBAction)onPlusButtonPressed:(id)sender {
 
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    alertView.title = @"Coming Soon.... Asshole";
    alertView.message = @"Se aproxima";
    [alertView addButtonWithTitle:@"Sucker!!!"];
    [alertView addButtonWithTitle:@"Get out"];
    [alertView show];
    
}


- (IBAction)onBackButtonPressed:(id)sender {
    
    [self.webView goBack];
}

- (IBAction)onFowardButtonPressed:(id)sender {
    
    [self.webView goForward];
}

- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [self.webView stopLoading];
}
- (IBAction)onReloadButtonPressed:(id)sender {
    [self.webView reload];
    
}



-(void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self checkCanFoward];
    [self checkCanBack];

    NSString *currentURL = webView.request.URL.absoluteString;
    self.urlTextField.text = currentURL;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString *pageTitle = [webView stringByEvaluatingJavaScriptFromString:   @"document.title"];
    self.pageTitleLabel.text = pageTitle;
}



#pragma mark - Hiding/Showing urlTextField & pageTitleLabel

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frameLabel = self.pageTitleLabel.frame;
    CGRect frameTextField = self.urlTextField.frame;
    CGFloat sizeLabel = frameLabel.size.height - 21;
    CGFloat sizeTextField = frameTextField.size.height - 21;
    CGFloat frameLabelPercentageHidden = ((20 - frameLabel.origin.y) / (frameLabel.size.height - 1));
    CGFloat frameTextFieldPercentageHidden = ((20 - frameTextField.origin.y) / (frameTextField.size.height - 1));
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    if (scrollOffset <= -scrollView.contentInset.top) {
        frameLabel.origin.y = 20;
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
        frameLabel.origin.y = -sizeLabel;
    } else {
        frameLabel.origin.y = MIN(20, MAX(-sizeLabel, frameLabel.origin.y - scrollDiff));
    }
    
    if (scrollOffset <= -scrollView.contentInset.top) {
        frameTextField.origin.y = 48;
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
        frameTextField.origin.y = -sizeTextField;
    } else {
        frameTextField.origin.y = MIN(48, MAX(-sizeTextField, frameTextField.origin.y - scrollDiff));
    }
    
    [self.pageTitleLabel setFrame:frameLabel];
    [self changeLabelAlpha:(1 - frameLabelPercentageHidden)];
    self.previousScrollViewYOffset = scrollOffset;
    
    [self.urlTextField setFrame:frameTextField];
    [self changeLabelAlpha:(1 - frameTextFieldPercentageHidden)];
    self.previousScrollViewYOffset = scrollOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stoppedScrolling];
    }
}

- (void)stoppedScrolling
{
    CGRect frameLabel = self.pageTitleLabel.frame;
    if (frameLabel.origin.y < 20) {
        [self animateLabelTo:-(frameLabel.size.height - 21)];
    }
    CGRect frameTextField = self.urlTextField.frame;
    if (frameTextField.origin.y < 20) {
        [self animateLabelTo:-(frameTextField.size.height - 21)];
    }
}

- (void)changeLabelAlpha:(CGFloat)alpha {
    self.pageTitleLabel.alpha = alpha;
    self.urlTextField.alpha = alpha;
}

- (void)animateLabelTo:(CGFloat)y
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frameLabel = self.pageTitleLabel.frame;
        CGRect frameTextField = self.urlTextField.frame;
        CGFloat alphaLabel = (frameLabel.origin.y >= y ? 0 : 1);
        frameLabel.origin.y = y;
        CGFloat alphaTextField = (frameTextField.origin.y >= y ? 0 : 1);
        [self.pageTitleLabel setFrame:frameLabel];
        [self.urlTextField setFrame:frameTextField];
        [self changeLabelAlpha:alphaLabel];
        [self changeLabelAlpha:alphaTextField];
    }];
}
@end
