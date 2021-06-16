class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail já cadastrado',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Tebte mais tarde',
    'EMAIL_NOT_FOUND': 'e-mail não cadastrado',
    'INVALID_PASSWORD': 'Senha inválida',
    'USER_DISABLED': 'Usuário desativado',
  };

  final String key;

  const AuthException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    } else {
      return 'Ocorreu um erro desconhecido';
    }
  }
}
