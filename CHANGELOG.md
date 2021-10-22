## [0.0.10-dev] - Oct 21, 2021
* controller is no longer an event based system. Instead, functions are copied from the state of the widget onto the widget.
* A field called `autoClose` was also added to the controller to mimic the effect of a pointer up event.

## [0.0.9+1] - Sep 29, 2021
* Fixed tooltip closing immediately when isModal is set to false and using a controller.

## [0.0.9] - Sep 29, 2021
* Fixed issue where hot reload would create skrim. Skrim no longer disables back button now.
* Fixed issue where tooltip would not update correctly from property changes.
* Added new tooltip property `triggerMode` and `enableFeedback`.

**[BREAKING]**
* Renamed JustTheTooltip.entry named constructor to other class JustTheTooltipEntry. This was necessary as the two methods were different enough to be their own widgets.

## [0.0.8] - Sep 10, 2021
* Added a `tailBuilder` for users to draw custom tails using their own path. Defaults to a linear implementation.
* Added pubignore for golden files

## [0.0.7+6] - Sep 2, 2021
Avoid another force unwrap error

## [0.0.7+5] - Sep 2, 2021
Tooltip area will no longer force unwrap and cause error when its scope is lost

## [0.0.7+4] - Sep 2, 2021
Fixes the mouse moved at load bug

## [0.0.7+3] - Sep 2, 2021
Field descriptions are not accessible

## [0.0.7+2] - Jun 18, 2021
Adds a longer description so I get them 130 points

## [0.0.7+1] - Jun 18, 2021
Added a builder around `JustTheTooltipArea` build function

## [0.0.7] - Jul 17, 2021
Added controller for managing the state of the tooltip.

Controller is now reset to normal state when the cancelShowTimer is canceled. This avoids weird states.

## [0.0.6-dev] - Jul 17, 2021
Add controller for showing and hiding the tooltip

## [0.0.5+1] - Jul 1, 2021
Make calls async in prep for controller migration.

## [0.0.5] - Jun 30, 2021
Much cleaner implementation. No longer JustTheTooltipEntry. Rather, that's been replaced with a `JustTheTooltip.entry` factory constructor.

## [0.0.4+1] - Jun 28, 2021
Adds key check for just_the_tooltip_entry

## [0.0.4] - Jun 28, 2021
Added a `isModal` property that defines how the tooltip is handled.

## [0.0.3+7] - Jun 26, 2021
Adds naive golden tests

## [0.0.3+6] - Jun 24, 2021
Hides tooltip if it's already visible with tooltip entry

## [0.0.3+5] - Jun 23, 2021
Accounts for scrollable space in both axis directions

## [0.0.3+4] - Jun 23, 2021
Accounts for margin when getting child's intrinsic size

## [0.0.3+3] - Jun 23, 2021
Uses optional scroll position to better position tooltip

## [0.0.3+2] - Jun 19, 2021
Gets child size through intrinsics rather than compute drylayout which breaks textFields

## [0.0.3+1] - Jun 19, 2021
Added `computeDryLayout` method to overlay


## [0.0.3] - Jun 19, 2021
Added `JustTheTooltipArea` for users who need to insert their tooltips into the tree more precisely.

## [0.0.2+2] - Jun 19, 2021
Add in curve animation property

## [0.0.2+1] - Jun 18, 2021
Wire up already in place fade animations

## [0.0.2] - Jun 18, 2021
Change layout strategy and add screnshots

## [0.0.1+2] - Jun 17, 2021
We only do one layout now

## [0.0.1+1] - Jun 17, 2021
Fixed a bug in second layout pass

## [0.0.1] - Jun 17, 2021
initial release