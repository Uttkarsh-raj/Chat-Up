class AppWriteConstants {
  static const String databaseId = '64292e022be4e2b44946';
  static const String projectId = '642920cb041baa247546';
  static const String userCollectionId = '6429b1784136708933e2';
  static const String messagesCollectionId = '642acef288374e376cf0';
  static const String imagesBucket = '64319e549ff89c9ff893';
  static const String endpoint = 'http://192.168.0.145:80/v1';

  static String imageUrl(String imageId) =>
      '$endpoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
