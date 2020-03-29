# MultipleSelection
Demonstrates UITableView multiple selection working on iOS/iPadOS and failing on macOS Catalyst.

Below are traces of calls to tableView(_ :, didSelectRowAt:) and tableView(_ :, didDeselectRowAt:) for the sequence of tapping rows 0,1,2,3,3,2,1,0 which should select all rows from 0 to 3 and then move back deselecting each row.  On iOS and iPadOS the correct sequence of selection and deselection is observed.   On macOS Catalyst when the second row is selected the first row is deselected, leaving only one row selected.

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
