# MultipleSelection
#### Demonstrates UITableView multiple selection working on iOS/iPadOS and failing on macOS Catalyst.

On a UITableView in iOS and iPadOS, multiple selection is enabled by setting

     tableView.allowsMultipleSelectionDuringEditing = true

This will bring up circles on the left hand side of each row in the tableView. One or more rows may be selected, and the selection will be indicated by a checkmark in the circle on each selected row.  But when the app is built for macOS Catalyst, only one selection is allowed at a time.  When a second row is selected, the first row is deselected and the checkmark on the deselected row is removed.   However, multiple selection will be allowed if the Command key is held down while the second and subsequent items are selected.  And holding Shift down during selection results in multiple selection of contiguous rows. This is a Mac-like way of doing multiple selection, but it is not what a user will expect in the Catalyst app where the circles on each row suggest an iOS/iPadOS style of multiple selection by directly selecting the desired rows.  The fact that the Command or Shift key must be held down to enable multiple selection on macOS is not what users presented with the iOS/iPadOS UI will expect.  This change in the user experience from iOS/iPadOS to macOS also has implications in the use of the table row selection API from code. For example, a “Select All” button that selects all of the items from code works properly on iOS and iPadOS but doesn't work on macOS Catalyst.  And, in addition to these differences between the two platforms, there is multple selection behavior on macOS Catalyst that is just broken.

MultipleSelection is a small test program that clearly demonstrates these issues.  It provides a trace of calls to didSelect and didDeselect so it is possible to see what is happening on the different platforms.  Below are three selection sequences demonstrating multiple selection behavior and issues on macOS Catalyst compared with iOS/iPadOS.


### 1. Differences Between macOS and iOS/iPadOS Multiple Selection Behavior

This example demonstrates the difference in multiple selection between macOS Catalayst and iOS/iPadOS.  Below are the traces for a sequence in which first Export is tapped to go into editing mode with multiple selection, then rows are tapped in the order 0,1,2,3,3,2,1,0.   On iOS and iPadOS this results in the rows being selected and checked in order from top to bottom so that all four rows are selected, then deselected from bottom to top.  But on macOS Catalyst, after the first row is tapped and checked, tapping the second row causes the first row to be deselected and there is a call to didDeselect before the second row is selected, so only the second row ends up selected.  In the final trace, the same sequence of taps is done but with the Command key pressed.   Now the rows are selected and checked in sequence, and then deselected and unchecked.  There are no calls to didDeselect during the first four taps and multiple selection occurs properly.


**Select row 0,1,2,3**<br/>
**Deselect row 3,2,1,0**<br/>

**iOS and iPadOS**

didSelectRowAt indexPath.row = 0<br/>
didSelectRowAt indexPath.row = 1<br/>
didSelectRowAt indexPath.row = 2<br/>
didSelectRowAt indexPath.row = 3<br/>
didDeselectRowAt indexPath.row = 3<br/>
didDeselectRowAt indexPath.row = 2<br/>
didDeselectRowAt indexPath.row = 1<br/>
didDeselectRowAt indexPath.row = 0<br/>



**macOS Catalyst**

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


**macOS Catalyst - Command select**

didSelectRowAt indexPath.row = 0<br/>
didSelectRowAt indexPath.row = 1<br/>
didSelectRowAt indexPath.row = 2<br/>
didSelectRowAt indexPath.row = 3<br/>
didDeselectRowAt indexPath.row = 3<br/>
didDeselectRowAt indexPath.row = 2<br/>
didDeselectRowAt indexPath.row = 1<br/>
didDeselectRowAt indexPath.row = 0<br/>


### 2. Select All Fails on macOS Catalyst

The second example demonstrates a Select All function implemented in code that works on iOS/iPadOS but fails on macOS Catalyst.  Export is tapped to go into editing mode with multiple selection, the Select All button appears in the upper right, and it is tapped.  The Select All button simply invokes

	tableView.selectRow(at: path, animated: true, scrollPosition: .none)
	
for each row in the table.  The traces of the calls are identical on iOS/iPadOS and macOS Catalyst.  On iOS/iPadOS the sequence results in all of the rows being selected and checked.  On macOS Catalyst the sequence results in only the last row being selected and checked.  The behavior of the UI on macOS Catalyst is the same as if the rows 0,1,2,3 had been selected manually in sequence.  First row 0 is selected.  Then row 1 is selected and row 0 is deselected.  And so forth.  

In general on macOS, Command-a will cause all of the elements in a table to be selected.  For example, this is the behavior in Notes and in Mail.  But on macOS Catalyst, at least in this example program, Command-a has no effect.

There appears to be no way to obtain the Select All function on macOS Catalyst, either in code or through selection and keyboard commands.  


**iOS and iPadOS**

didSelectRowAt indexPath.row = 0<br/>
didSelectRowAt indexPath.row = 1<br/>
didSelectRowAt indexPath.row = 2<br/>
didSelectRowAt indexPath.row = 3<br/>


**macOS Catalyst**

didSelectRowAt indexPath.row = 0<br/>
didSelectRowAt indexPath.row = 1<br/>
didSelectRowAt indexPath.row = 2<br/>
didSelectRowAt indexPath.row = 3<br/>


### 3. Deselect Bug In a Multiple Selection on macOS Catalyst

Consider a sequence in which several rows are selected, and then one is selected again.  For example, select rows 0,2,3 directly on iOS/iPadOS and by holding down Command on macOS.  Then, by direct selection on iOS/iPadOS and by selecting without the Command key on macOS, select row 0.  On iOS/iPadOS that causes row 0 to be deselected. On macOS the behavior is that as the selection is started by clicking down on the trackpad, row 0 remains selected and rows 2 and 3 are deselected.  Then as the trackpad is released, row 0 remains selected and rows 2 and 3 become selected again.  The traces are below. 

This behavior on macOS Catalyst is a bug. To see it clearly, repeat the selection sequence, then with Command not held down select either row 2 or 3.  This time when the final selection is made for row 2 or 3, that row will remain selected and the other rows will be deselected and will remain deselected when the selection is completed.  This is the correct behavior.  On macOS the semantics of selection in a table with multiple selection enabled and without the Command or Shift key held is that only the selected row should remain selected.  

The bug appears to happen when the first in a multiple selection is selected again, but not when any of the others is selected again.


**Select row 0,2,3**<br/>
**Select row 0**<br/>


**macOS Catalyst**
 
didSelectRowAt indexPath.row = 0<br/>
didSelectRowAt indexPath.row = 2<br/>
didSelectRowAt indexPath.row = 3<br/>
didSelectRowAt indexPath.row = 0<br/>


**iOS/iPadOS**

didSelectRowAt indexPath.row = 0<br/>
didSelectRowAt indexPath.row = 2<br/>
didSelectRowAt indexPath.row = 3<br/>
didDeselectRowAt indexPath.row = 0<br/>
 