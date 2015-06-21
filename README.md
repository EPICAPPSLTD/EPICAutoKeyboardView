# EPICColors

EPICAutoKeyboardView is a utility UIView subclass that manages it's own autoresizing logic when the keyboard is displayed or hidden. It is designed to work on both iPhone and iPad and works in both portrait and landscape orientations. By using this class, you will avoid having to manage `UIKeyboardWillChangeFrameNotification`, `UIKeyboardWillShowNotification` and `UIKeyboardWillHideNotification`. 

To use this, configure the root view of your view controllers to be a subclass of `EPICAutorezisingKeyboardInputRootView` (a mouthful, I know, but the name made sense!) on either your xib file or programatically.

Gotchas:
------
EPICAutoKeyboardView is designed to work as the root view of a full screen view controller. Adding this view anywhere else in the view hierarchy or inside a child view controller whose frame is not full screen might produce unexpected behaviour, specially if the view's bottom is not aligned with the screen's bottom margin, or the view's height is less than the keyboard's height. 

Just stick to this one simple rule: Use this class only on the root view of view controllers being presented full screen.

Others:
------

This class serves as an extension to the tutorial of the blog article: ["TODO"](TODO).
Usage is free for all based on the attached license details, if you find this code useful, please consider [making a donation](http://epic-apps.uk/donations/). :)

Copyright (c) EPIC 
[www.epic-apps.uk](www.epic-apps.uk)


