# ATProxy

[![CI Status](https://img.shields.io/travis/YLCHUN/ATProxy.svg?style=flat)](https://travis-ci.org/YLCHUN/ATProxy)
[![Version](https://img.shields.io/cocoapods/v/ATProxy.svg?style=flat)](https://cocoapods.org/pods/ATProxy)
[![License](https://img.shields.io/cocoapods/l/ATProxy.svg?style=flat)](https://cocoapods.org/pods/ATProxy)
[![Platform](https://img.shields.io/cocoapods/p/ATProxy.svg?style=flat)](https://cocoapods.org/pods/ATProxy)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
![example.gif](https://raw.githubusercontent.com/youlianchun/ATProxy/master/Example/ATProxy.gif)
### UITabBarController
```
OvalMaskTransition *transition = [[OvalMaskTransition alloc] initWithOperation:UINavigationControllerOperationPush timeInterval:2 anchor:self.view.center];
[self setSelectedIndex:1 transition:transition];
```

### UIViewController
```   
- (UIPanGestureRecognizer *)transitionGestureRecognizer {
UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] init];
__weak typeof(self) wself = self;
[pgr setInteractiveDirection:ATGestureRecognizerDirectionLeft transitional:^{
[wself transit];
}];
return pgr;
}

- (IBAction)transit {
PageCoverTransition *transition = [PageCoverTransition transitionWithType:PageCoverTransitionTypePush];
[self presentViewController:[SecViewController new] transitional:transition completion:nil];
//[self.navigationController pushViewController:[SecViewController new] transitional:transition];

}

//- (IBAction)transit {
//    PageCoverTransition *transition = [PageCoverTransition transitionWithType:PageCoverTransitionTypePop];
//    [self dismissViewControllerTtransitional:transition completion:nil];
//    //[self.navigationController popViewControllerTransitional:transition];
//}
```

## Requirements

## Installation

ATProxy is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ATProxy'
```

## Author

YLCHUN, youlianchunios@163.com

## License

ATProxy is available under the MIT license. See the LICENSE file for more info.
