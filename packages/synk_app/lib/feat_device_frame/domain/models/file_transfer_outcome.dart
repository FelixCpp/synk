enum FileTransferAction {
  installed,
  pushed,
}

typedef FileTransferOutcome = ({
  FileTransferAction action,
  String filename,
});
