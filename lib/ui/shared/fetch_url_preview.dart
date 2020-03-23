import 'package:http/http.dart';
import 'package:html/parser.dart';
import '../../ui/shared/logger.dart';

class FetchPreview{

Future fetch(url) async {

  final client = Client();
  final response = await client.get(_validateURL(url));
  final document = parse(response.body);

  String title, twitterTitle, noTitle;
  String description, twitterDescription;
  String image, twitterImage;
  String favIcon, twitterFavIcon;

// First use Twitter Card info if available

  getLogger("url: title $url");
  var elements = document.getElementsByTagName('meta');
  elements.forEach((tmp){

    if (tmp.attributes['property'] == 'twitter:title') {
      title =  tmp.attributes['content'];
      getLogger("fetch1: title $title");
    }
    if (title == null || title.isEmpty || title == "Bad Request") {
      if (tmp.attributes['name'] == 'twitter:title') {
        title =  tmp.attributes['content'];
        getLogger("fetch2: title $title");
      }
    }
    if (title == null || title.isEmpty || title == "Bad Request") {
      if (tmp.attributes['property'] == 'og:title') {
        title =  tmp.attributes['content'];
        getLogger("fetch3: title $title");
      }
    }

if (tmp.attributes['property'] == 'twitter:description') {
      title =  tmp.attributes['content'];
      getLogger("fetch1: description $description");
    }
    if (title == null || title.isEmpty || title == "Bad Request") {
      if (tmp.attributes['name'] == 'twitter:description') {
        title =  tmp.attributes['content'];
        getLogger("fetch2: description $description");
      }
    }
    if (title == null || title.isEmpty || title == "Bad Request") {
      if (tmp.attributes['property'] == 'og:title') {
        title =  tmp.attributes['content'];
        getLogger("fetch3: description $description");
      }
    }
//    if (tmp.attributes['name'] == 'twitter:description') {
//      twitterDescription =  tmp.attributes['content'];
//    }
//    if (tmp.attributes['property'] == 'og:description') {
//      description =  tmp.attributes['content'];
//    }
//
//    if (description == null || description.isEmpty) {
//      if (tmp.attributes['name'] == 'description') {
//        description = document.attributes['content'];
//      }
//    } 

    if (tmp.attributes['name'] == 'twitter:image0') {
      twitterImage =  tmp.attributes['content'];
    }
    if (tmp.attributes['property'] == 'og:image') {
      image =  tmp.attributes['content'];
    }
  });

  if (title == null || title.isEmpty || title == "Bad Request") {  
      title = document.getElementsByTagName('title')[0].text;
      getLogger("fetch4: title $title");
    }


  var linkElements = document.getElementsByTagName('link');
  linkElements.forEach((tmp){
    if (tmp.attributes['rel']?.contains('icon') == true) {
      favIcon =  tmp.attributes['href'];
    }
  });

getLogger("fetch_url_preview: title: $title, desc: $description, image: $image. favIcon: $favIcon");

//ToDo: description and image not showing up, try other tags

  return {
    'title' : title ?? '', // twitterTitle ?? title ?? noTitle ?? '',
    'description' : twitterDescription ?? description ?? '',
    'image' : twitterImage ?? image ?? favIcon ?? '',
    'favIcon' : twitterFavIcon ?? favIcon ?? ''
  };
}

_validateURL(String url) {
  if ((url?.startsWith('http://')) == true || url?.startsWith('https://') == true) { //ToDo what about tel, email etc
    return url;
  } 
  else {
      return 'http://$url';
  }

}

}