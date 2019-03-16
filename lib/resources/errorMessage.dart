class ErrorMessage {
  final String code;

  final Map<String, Map<String, String>> _errorMessages = {
    'ERROR_WRONG_PASSWORD': {'en': 'Incorrect password'},
    'ERROR_USER_NOT_FOUND': {'en': 'Account not found'},
    'ERROR_USER_DISABLED': {'en': 'Your account has been disabled'},
    'ERROR_WEAK_PASSWORD': {'en': 'The password is not strong enough'},
    'ERROR_INVALID_CREDENTIAL': {'en': 'The email address format is wrong'},
    'ERROR_EMAIL_ALREADY_IN_USE': {'en': 'The email address is already in use'},
    'ERROR_EMAIL_ADDRESS_IS_SAME': {'en': 'The entered email address is same as the current email'}
  };

  ErrorMessage(this.code);

  String toString() {
    print(this.code);
    return _errorMessages.containsKey(code) ? _errorMessages[code]['en'] : 'Error message not found.';
  }
} 