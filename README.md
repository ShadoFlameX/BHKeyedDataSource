# BHKeyedDataSource

BHKeyedDataSource allows you to dynamically organize and modify UITableView section and row content. This makes it easy to show, hide or reorder cells as desired. An example project is included.

## Organizing Content

BHKeyedDataSource is an abstract superclass which requires that you create concrete subclass. At a minimum you must override `tableView:cellForRow:inSection:atIndexPath:`.

Sections and rows are added, inserted or removed via unique key strings. Cell configuration is done via `tableView:cellForRow:inSection:atIndexPath:` which allows you to reference the section and row keys when configuring and returning a cell.

## Collection-based Content

Section content driven by a collection (array) is also possible. In this case, a section should be added for the content but adding rows is not necessary. You also need to override `numberOfRowsInSection:` and return the appropriate row count for this section. You should call `super` for any other sections that are not collection-based.

## Delegate Interaction

You can determine which section or row is being referenced within UITableViewDelegate callbacks by retrieving key information via `sectionForSectionIndex:` or `sectionInfoForIndexPath:`. For example, within `tableView:didSelectRowAtIndexPath:` you could determine which child view controller to present based on the section and row keys.

