
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class WebScrapingService {
  final String _baseUrl;

  WebScrapingService(this._baseUrl);

  // Fetch the webpage content
  Future<Document?> _fetchPageContent(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl$endpoint'));

    if (response.statusCode == 200) {
      return parse(response.body);
    } else {
      print('Failed to load content from $_baseUrl$endpoint');
      return null;
    }
  }

  // An example function to extract specific data
  Future<List<String>> getCarRepairTips(String query) async {
    final pageContent = await _fetchPageContent('/search?q=$query');

    if (pageContent != null) {
      // Assuming the website has articles with the class 'article-title' for our search query
      List<Element> articleElements = pageContent.querySelectorAll('.article-title');

      // Extract the text from each article element
      List<String> articleTitles = articleElements.map((element) => element.text).toList();
      return articleTitles;
    } else {
      return [];
    }
  }

// More methods can be added based on what data you want to scrape and from where.
}

