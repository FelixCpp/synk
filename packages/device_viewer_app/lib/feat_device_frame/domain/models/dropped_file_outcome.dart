enum DroppedFileAction { installed, pushed }

typedef DroppedFileOutcome = ({
  DroppedFileAction action,
  String filename,
});
