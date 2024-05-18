import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  //to generate token only once for an app run
  static Future<String?> get getToken async => _token ?? await _getAccessToken();

  // to get admin bearer token
  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        // To get Admin Json File: Go to Firebase > Project Settings > Service Accounts
        // > Click on 'Generate new private key' Btn & Json file will be downloaded

        // Paste Your Generated Json File Content
        // ServiceAccountCredentials.fromJson({
        //   "type": "service_account",
        //   "project_id": "iotpro-10694",
        //   "private_key_id": "273781a0f0babdb6c7eea81aa8ece743f5618195",
        //   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDCmo+cdo4ednlM\nrk9rcYqCDmh1ip2wJ32CGv1G4elkJrr5LduMxwD6aGxfwNzZAORPjx61Wcyenzgd\nrUtz3r7g1mwRknPtecOyZsBQ+AHsxFNpFl6ZxLkMCP/zTL/3gnZEr8f/PjRGLVoP\nWFNiFhjoKqLK0L5yAOpYkXm2e3m287wilgCHpVgZZuSX15sN2W68qP7B9QjpucQ6\nrsUQ243JRNx+cqUdlJJTQLhw41yx3WW1q2Sx/jTZ1cUX1YOSvj3WWhSjXQ0xfJpB\nN354fqfXdJ91ARuyTZHmBY86zRdPqIx5mZGW2QzN4tK8qYYmazFc5TlqeyGQm0HO\nK0LK7jTzAgMBAAECggEADa+TA/zud8P7OeJUYYkFpanfvMx31IiicgD16QNAR7PV\nmGqaMydXsUSgwocswPIoHFRDY5uiIVGvP58NXGPA5s0Nopq7Hmte0PAa/FbEw+L2\nvsA8/PFx1h/X6ENwiLabHK+EEDZOtNTBrayXiKFnNQSymDLgAeKAmKP6fFPotm4E\nQa7fNyW4bPsKHuJPTNETOjvyUJBdzhXLLvFLj6P4UqzEhP50tWJroKG8lSxVtOzF\nW1Qb7a1PpJ5Hfc5G/2WFyY3Lyz2lq/pjKR/qgA4R7pcayCKEnIl068LZK9CSF6wu\npAW5QQ8dx0s3rnMTT17cjUkpoZSGFBOzXKBKGYyiYQKBgQDxs73U214/td4wm+Wa\n9S5IkSUUpIZiSb/pv54kAEzXjnDE6hZ5uYPnb97vlToq0BigJTCQDVpiB200JCZY\nVCGNMYVGbMY2aLVKK+yMAwnoVtEHWFoXH85B3xcQkksg3pRMf07M4EryGNb0muJ9\nZwNHObxbz5DdPq6DBydOnP54MQKBgQDOHZO/I8+W4MI9kdVUZ4T8/rzQ7Oeo4Ioy\nMtTyjPIGkL/O1K5HgTfhbdTqE/ySg1+quzjxF+EgMqtvO3WUy5uuFanLp/wLSzEB\nIJ6Pl85I75zoho6l+obJGY0vsa/KjICZDuDjG4M6EQbQitLg17l07q/XSZc/kMG6\n7T+tpezaYwKBgQC00BTL3suz95bfYFC0yoQ0TzihJ69MagWClRF1ty/E9c8Q0Fm9\n9/VgNoVdT5JzIre5XfjlWsfpm8qq/fwdidqLqKceFxN08oHkmdVcrI1F3WSEDSlg\nMS/4gS7c+8PuM/RXAcnuZEBMuh5cYF3dGCoQp3VsbWvexxx/8uMJ4VJQkQKBgCfc\n+o02HNj+YTLNOKgZWVQg5F2349n6i1/ICv1aGxj/98jFw2sa57bWqh4XfXrMo7z+\ndrXSO30hr5xUsJn1gwd5MxyrQYjhovmn2GLHJmNezEcAdyhMurK8GV1HDUusPtbb\nVM03rfqV/m5o2v4XWsvtud52YiUuFvnTFsS72YInAoGBAOIl6R90OgY2GQj9TSb9\n/FglC25SqwHohwU47ErdcKPqng1Y/MR6IiCEcKx37CrD6sWaXxiuh1/MeqiV3bCg\nFq4prmloBH5ISmJqjKU4De0YtNANtX3aQoZNmg9q/sm81LfZTfN3jto5WGzpH/3N\nB3isR3LiRsD8OYhK5exEMkdX\n-----END PRIVATE KEY-----\n",
        //   "client_email": "firebase-adminsdk-6xaa4@iotpro-10694.iam.gserviceaccount.com",
        //   "client_id": "100229790678366711902",
        //   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        //   "token_uri": "https://oauth2.googleapis.com/token",
        //   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        //   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-6xaa4%40iotpro-10694.iam.gserviceaccount.com",
        //   "universe_domain": "googleapis.com"
        // }),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
