class DocumentPath {
  static String newResponse(String uid, String responseId) =>
      'Users/$uid/geminiresponses/$responseId';
  static String streamResponse(String uid) => 'Users/$uid/geminiresponses/';

  static String newLocation(String newLocationId) => 'Locations/$newLocationId';
  static String streamLocation() => 'Locations/';

  static String newStorageFile(String newFileId) => 'Uploads/$newFileId';
}
