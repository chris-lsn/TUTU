class ErrorMessage {
  final String code;

  final Map<String, Map<String, String>> _error_messages = {
    'ERROR_USER_NOT_FOUND': {'en': 'Incorrect E-mail or Password.'},
    'ERROR_USER_DISABLED': {'en': 'Your account has been disabled'},
    'ERROR_WEAK_PASSWORD': {'en': 'The password is not strong enough.'},
    'ERROR_INVALID_CREDENTIAL': {'en': 'The email address format is wrong.'},
    'ERROR_EMAIL_ALREADY_IN_USE': {'en': 'The email is already in use.'}
  };

  ErrorMessage(this.code);

  String toString() {
    return _error_messages.containsKey(code) ? _error_messages[code]['en'] : 'Error message not found.';
  }
}