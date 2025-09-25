enum ExcResponse {
  unknown,
  errorGeneral,
  withoutInternet,
}

class ResponseGeneralException implements Exception {
  ResponseGeneralException({
    required this.message,
    required this.type,
    required this.code,
  });

  final String message;
  final String code;
  final ExcResponse type;

  @override
  String toString() {
    return message;
  }
}

class GeneralException implements Exception {
  GeneralException(this.message, this.type);
  final String message;
  final ExcResponse type;

  @override
  String toString() {
    return message;
  }
}

class ResponseServerException implements Exception {
  ResponseServerException(this.message, this.type);

  final String message;
  final ExcResponse type;

  @override
  String toString() {
    return message;
  }
}
