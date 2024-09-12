import 'package:easy_book/api/network/quotes_api/quote_dto.dart';
import 'package:easy_book/api/network/quotes_api/quotes_client.dart';

class QuoteService {
  static final QuotesApiClient _quotesClient = QuotesApiClient.instance;

  static Future<QuoteDto> getRandomQuote(String languageCode) async {
    var response = await _quotesClient.dio.get("/random/", queryParameters: {"language_code": languageCode});
    QuoteDto result = QuoteDto.fromJson(response.data);
    return result;
  }
}
