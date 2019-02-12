class ErrorMessage {
  final String code;

  final Map<String, Map<String, String>> _error_messages = {
    'ERROR_WRONG_PASSWORD': {'en': 'Incorrect password'},
    'ERROR_USER_NOT_FOUND': {'en': 'Account not found'},
    'ERROR_USER_DISABLED': {'en': 'Your account has been disabled'},
    'ERROR_WEAK_PASSWORD': {'en': 'The password is not strong enough'},
    'ERROR_INVALID_CREDENTIAL': {'en': 'The email address format is wrong'},
    'ERROR_EMAIL_ALREADY_IN_USE': {'en': 'The email address is already in use'}
  };

  ErrorMessage(this.code);

  String toString() {
    print(this.code);
    return _error_messages.containsKey(code) ? _error_messages[code]['en'] : 'Error message not found.';
  }
}