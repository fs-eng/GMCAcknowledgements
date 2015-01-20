// GMCAcknowledgementsViewController.m
//
// Copyright (c) 2014 Hilton Campbell
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "GMCAcknowledgementsViewController.h"
#import "MMMarkdown.h"

@interface GMCAcknowledgementsViewController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *HTML;

@end

@implementation GMCAcknowledgementsViewController

- (id)init {
    if ((self = [super init])) {
        self.title = NSLocalizedStringFromTable(@"Acknowledgements", @"GMCAcknowledgements", nil);
    }
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.webView];
    
    // Hack to remove the unsightly web view shadows
    self.webView.backgroundColor = [UIColor whiteColor];
    for (UIView *subview in self.webView.scrollView.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            subview.hidden = YES;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *templateURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"GMCAcknowledgements" ofType:@"html"]];
    NSString *templateHTML = [NSString stringWithContentsOfURL:templateURL encoding:NSUTF8StringEncoding error:NULL];
    
    NSURL *acknowledgementsURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Acknowledgements" ofType:@"markdown"]];
    NSString *acknowledgementsMarkdown = [NSString stringWithContentsOfURL:acknowledgementsURL encoding:NSUTF8StringEncoding error:NULL];
    NSString *acknowledgementsHTML = [MMMarkdown HTMLStringWithMarkdown:acknowledgementsMarkdown error:NULL];
    
    self.HTML = [templateHTML stringByReplacingOccurrencesOfString:@"__ACKNOWLEDGEMENTS__" withString:acknowledgementsHTML];
    
    [self configureWebView];
}

- (void)setInverted:(BOOL)inverted {
    _inverted = inverted;
    
    [self configureWebView];
}

- (void)configureWebView {
    if (self.inverted) {
        self.webView.backgroundColor = [UIColor blackColor];
        NSString *invertedHTML = [self.HTML stringByReplacingOccurrencesOfString:@"<body>" withString:@"<body bgcolor=\"#000000\" text=\"#FFFFFF\">"];
        [self.webView loadHTMLString:invertedHTML baseURL:nil];
    } else {
        [self.webView loadHTMLString:self.HTML baseURL:nil];
    }
}

@end
