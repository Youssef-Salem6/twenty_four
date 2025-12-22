import 'package:twenty_four/main.dart';

const String endPoint = "https://new.the24.net/api/cp";

Map<String, String> headers = {
  'Authorization': 'Bearer ${prefs.getString("token")}',
  "Accept": "application/json",
};
//home news
const String homeNews = "$endPoint/home";

//news details
const String getNewsDetailsUrl = "$endPoint/articles";

//auth
const String registerApi = "$endPoint/register";
const String loginApi = "$endPoint/login";
const String logOutApi = "$endPoint/logout";

//search

String searchArticalUrl = "$getNewsDetailsUrl?search";

//sources
const String getSourcesUrl = "$endPoint/news-sources";
String toggleFollowSourceUrl({required String sourceId}) => "$getSourcesUrl/$sourceId/toggle-follow";