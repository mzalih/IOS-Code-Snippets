``` swift

```
How To Use

``` swift
use as direct function

  let dragger = DragToTable.activate(myview, table: tableView, view:  self.view) { (indexPath) -> Void in
            // Changesd Index
            self.itemsArray.insert("New Item", atIndex: indexPath.row+1)
            
        }
// myview :-  view to move 
// tableView :- Table to drop
// self.view  :- the controllers view
```

Thanks Fairbanks