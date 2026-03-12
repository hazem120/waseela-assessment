class AppConstants {
  static const String baseUrl = 'http://localhost:3000';

  static const String healthEndpoint = '/health';
  static const String productsEndpoint = '/api/products';
  static String productDetailsEndpoint(String id) => '/api/products/$id';
  static const String plansEndpoint = '/api/plans';
  static const String orderStatusEndpoint = '/api/order/status';
}

