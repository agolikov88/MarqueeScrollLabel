Overview
============

MarqueeScrollLabel is a simple subclass of UILabel that adds horizontal scrolling effect for label text when it doesn't fit in the available width.
Current implementation supports basic set of marquee scroll controls:

- enable/disable scroll animation
- enable/disable text fade effect
- enable/disable text inset for fade effect

Also all available UILabel properties can be used in MarqueeScrollLabel both via code and storyboard.

## Getting Started

#### Currently only manual installation supported

1. Clone this repository
2. Copy View/MarqueeScrollLabel.swift into your project
3. Use as a regular UILabel class where marquee scroll effect is needed

## Usage

By default scroll animation is disabled so when MarqueeScrollLabel instance is created you need to set `animating` property to `true`. This can also be done via storyboard.
`enableTextFade` and `enableTextFadeInset` can be used to control showing text fade effect when scrolling and text inset so that text will not appear right under fade effect at the beginning of animation.

All MarqueeScrollLabel properties can be accessed via storyboard as well as MarqueeScrollLabel itself can be instantiated via storyboard. A regular UILabel view can be added to storyboard and then MarqueeScrollLabel can be specified as a custom class.

MarqueeScrollLabel currently supports horizontal scrolling from right to left. It also automatically detects when animation is needed based on text length and available view width.
App foreground/background state changes as well as screen orientation changes are tracked and animation is correctly restarted.
Scroll animation speed is currently automatically calculated based on text length and view width.

Please feel free to suggest further updates and submit PRs.
