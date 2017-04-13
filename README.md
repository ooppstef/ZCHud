# ZCHud

A simple usage hud.

Apply two animations for success and 
failure.

Apply touches handler in block.

## Usage
Show:

```
 _hud = [ZCHud new];
 [_hud showInView:self.view];
```
Hide:

```
[_hud hide]
//[_hud hideInFailureAnimationWithText:@"Hide" duration:3];
//[_hud hideInSuccessAnimationWithText:@"Hide" duration:3];
```

## Requirements
iOS7+ and ARC
##Installation
Available through CocoaPods

```
pod 'ZCHud'
```






