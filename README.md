update ưake lock 

--------------
xception has occurred.
FlutterError (Duplicate GlobalKey detected in widget tree.
The following GlobalKey was specified multiple times in the widget tree. This will lead to parts of the widget tree being truncated unexpectedly, because the second time a key is seen, the previous instance is moved to the new location. The key was:
- [GlobalObjectKey int#18843]
This was determined by noticing that after the widget with the above global key was moved out of its previous parent, that previous parent never updated during this frame, meaning that it either did not update at all or updated before the widget was moved, in either case implying that it still thinks that it should have a child with that global key.
The specific parent that did not update after having one or more children forcibly removed due to GlobalKey reparenting is:
- PopScope<dynamic>(dependencies: [_ModalScopeStatus], state: _PopScopeState<dynamic>#7fa6c)