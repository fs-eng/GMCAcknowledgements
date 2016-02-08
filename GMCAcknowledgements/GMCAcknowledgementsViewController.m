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

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSString *HTML;

@end

@implementation GMCAcknowledgementsViewController

- (id)init {
    if ((self = [super init])) {
        self.title = NSLocalizedString(@"Third Party Acknowledgements", nil);
    }
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.editable = NO;
    [self.view addSubview:self.textView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *templateURL = [NSURL fileURLWithPath:[[NSBundle bundleForClass:[GMCAcknowledgementsViewController class]] pathForResource:@"GMCAcknowledgements" ofType:@"html"]];
    NSString *templateHTML = [NSString stringWithContentsOfURL:templateURL encoding:NSUTF8StringEncoding error:NULL];
    
    NSURL *acknowledgementsURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Acknowledgements" ofType:@"markdown"]];
    NSString *acknowledgementsMarkdown = [NSString stringWithContentsOfURL:acknowledgementsURL encoding:NSUTF8StringEncoding error:NULL];
    NSString *acknowledgementsHTML = [MMMarkdown HTMLStringWithMarkdown:acknowledgementsMarkdown error:NULL];
    
    self.HTML = [templateHTML stringByReplacingOccurrencesOfString:@"__ACKNOWLEDGEMENTS__" withString:acknowledgementsHTML];
    
    [self configureTextView];
}

- (void)setInverted:(BOOL)inverted {
    _inverted = inverted;
    
    [self configureTextView];
}

- (void)configureTextView {
    NSString *configuredHTML = self.HTML;
    
    if (self.inverted) {
        self.textView.backgroundColor = [UIColor blackColor];
        configuredHTML = [self.HTML stringByReplacingOccurrencesOfString:@"<body>" withString:@"<body bgcolor=\"#000000\" text=\"#FFFFFF\">"];
    } else {
        self.textView.backgroundColor = [UIColor whiteColor];
    }
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    self.textView.attributedText = [[NSAttributedString alloc] initWithData:[configuredHTML dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:nil error:nil];
}

@end
