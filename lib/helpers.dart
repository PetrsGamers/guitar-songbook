String getFileExtension(String filename) {
  return filename.split(".").last;
}

String getFileExtensionFromMime(String? mimeType) {
  if (mimeType == null) {
    return "";
  }
  return mimeType.split("/").last;
}
