//
//  CalculatorViewController.m
//  Calculator
//
//  Created by John on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (weak, nonatomic) IBOutlet UILabel *stackview;
@end

@implementation CalculatorViewController
@synthesize display;
@synthesize stackview = _stackview;
@synthesize userIsInTheMiddleOfEnteringNumber;
@synthesize brain = _brain;

- (CalculatorBrain*)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringNumber)
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringNumber = YES;
    }
}
- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringNumber = NO;
    [self updateStackView:self.display.text];
}
- (void) updateStackView:(NSString *)value {
    self.stackview.text = [self.stackview.text stringByAppendingFormat:@" %@", value];
}
- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringNumber)
    {
        [self enterPressed];
    }
    NSString *operation = sender.currentTitle;
    double result = [self.brain performOperation:operation];
    [self updateStackView:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}
- (IBAction)decimalPressed:(id)sender {
    if ([self.display.text rangeOfString:@"."].location == NSNotFound)
    {
        self.display.text = [self.display.text stringByAppendingString:@"."];
        self.userIsInTheMiddleOfEnteringNumber = YES;
    }
}
- (IBAction)clearPressed {
    self.display.text = @"0";
    self.stackview.text = @"";
    [self.brain clearOperands];
    self.userIsInTheMiddleOfEnteringNumber = NO;
}

- (void)viewDidUnload {
    [self setStackview:nil];
    [super viewDidUnload];
}
@end
