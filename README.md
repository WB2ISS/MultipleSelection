# MultipleSelection
Demonstrates UITableView multiple selection working on iOS/iPadOS and failing on macOS Catalyst.

On a tableView in iOS and iPadOS, multiple selection is enabled by setting

     tableView.allowsMultipleSelectionDuringEditing = true

This will bring up circles on the left hand side of each row in the tableView. One or more rows may be selected, and the selection will be indicated by a checkmark in the cirle on each selected row.  But when the app is built for macOS Catalyst, only one selection is enabled at a time.  When a second row is selected, the first row is de-selected and the check mark on the de-selected row is removed.   However, multiple selection will be allowed if the Command key is held down while the second and subsequent items are selected.  In fact, holding Shift down during selection results in multiple selection of contiguous rows, and holding Command down allows multiple non-contiguous selection.   This is a Mac-like way of doing multiple selection, but it is not what a user will expect in the Catalyst app where the circles on each row look like they are what should be selected.  The fact that the Command or Shift key must be held down to enable multiple selection is not what users will expect.  Furthermore, multiple selection from code (for example, the app that this was intended for has a “Select All” function that selects all of the items) doesn’t work doesn't work at all on macOS Catalyst.

MultipleSelection is a small test program that clearly demonstrates this behavior.  It provides a trace of calls to didSelect and didDeselect so it is possible to clearly see what is happening on the different platforms.  Below are the traces for a sequence in which first Export is tapped to get into the editing mode with multiple selection, then rows are tapped in the order 0,1,2,3,3,2,1,0.   On iOS and iPadOS this results in the rows being selected and checked in order from top to bottom so that all four rows are selected, then deselected from bottom to top.   But on macOS Catalyst, after the first row is tapped and checked, tapping the second row causes the first row to be de-selected and there is a call to didDeselect before the second row is selected, so only the second row ends up selected.   In the final trace, the same sequence of taps is done but with the Command key pressed.   Now the rows are selected and checked in sequence, and then de-selected and unchecked.  There are no calls to didDeselect during the first four taps so multiple selection occurs properly.


Demo Project

tableView.allowsMultipleSelectionDuringEditing = true

Select row 0,1,2,3
Deselect row 3,2,1,0

iOS and iPadOS

didSelectRowAt indexPath.row = 0<br/>
didSelectRowAt indexPath.row = 1<br/>
didSelectRowAt indexPath.row = 2<br/>
didSelectRowAt indexPath.row = 3<br/>
didDeselectRowAt indexPath.row = 3<br/>
didDeselectRowAt indexPath.row = 2<br/>
didDeselectRowAt indexPath.row = 1<br/>
didDeselectRowAt indexPath.row = 0<br/>



macOS Catalyst

didSelectRowAt indexPath.row = 0<br/>
didDeselectRowAt indexPath.row = 0<br/>
didSelectRowAt indexPath.row = 1<br/>
didDeselectRowAt indexPath.row = 1<br/>
didSelectRowAt indexPath.row = 2<br/>
didDeselectRowAt indexPath.row = 2<br/>
didSelectRowAt indexPath.row = 3<br/>
didSelectRowAt indexPath.row = 3<br/>
didDeselectRowAt indexPath.row = 3<br/>
didSelectRowAt indexPath.row = 2<br/>
didDeselectRowAt indexPath.row = 2<br/>
didSelectRowAt indexPath.row = 1<br/>
didDeselectRowAt indexPath.row = 1<br/>
didSelectRowAt indexPath.row = 0<br/>


macOS - Command select

didSelectRowAt indexPath.row = 0<br/>
didSelectRowAt indexPath.row = 1<br/>
didSelectRowAt indexPath.row = 2<br/>
didSelectRowAt indexPath.row = 3<br/>
didDeselectRowAt indexPath.row = 3<br/>
didDeselectRowAt indexPath.row = 2<br/>
didDeselectRowAt indexPath.row = 1<br/>
didDeselectRowAt indexPath.row = 0<br/>
