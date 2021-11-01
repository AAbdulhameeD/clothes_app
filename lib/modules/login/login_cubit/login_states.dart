abstract class LoginStates {}
class LoginInitialState extends LoginStates {}
class GoogleLoginLoadingState extends LoginStates {}

class GoogleLoginSuccessState extends LoginStates {
  String uId;

  GoogleLoginSuccessState(this.uId);
}


class GoogleLoginErrorState extends LoginStates {}

class LoginAnonymouslySuccessState extends LoginStates {
  String uId;

  LoginAnonymouslySuccessState(this.uId);

}

class LoginAnonymouslyErrorState extends LoginStates {}

class SignInAnonymouslyErrorState extends LoginStates {}

class SignInAnonymouslySuccessState extends LoginStates {}
class CreateUserSuccessState extends LoginStates {
  String uId;

  CreateUserSuccessState(this.uId);
}

class CreateUserErrorState extends LoginStates {}
class GetUserDataLoadingState extends LoginStates {}
class GetUserDataSuccessState extends LoginStates {}

class GetUserDataErrorState extends LoginStates {}
