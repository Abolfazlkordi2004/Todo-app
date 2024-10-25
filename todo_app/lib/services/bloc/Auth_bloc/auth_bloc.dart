import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Error/auth_exception.dart';
import 'package:todo_app/class/authentication.dart';
import 'package:todo_app/class/cache_handler.dart';
import 'package:todo_app/class/oTP_service.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_event.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_state.dart';
import 'package:bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const InitializeAppState()) {
    on<InitializeAppEvent>(
      (event, emit) async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String? userNumber = pref.getString('number');

        if (userNumber == null || userNumber == '') {
          emit(const LoggedInState());
        } else {
          emit(const HomeState());
        }
      },
    );

    on<HomeEvent>(
      (event, emit) async {
        emit(const HomeState(isLoading: true));
        await Future.delayed(const Duration(seconds: 1));
        emit(const HomeState());
      },
    );

    on<RegisterEvent>(
      (event, emit) async {
        try {
          emit(const RegisteringState(isLoading: true));
          await CacheHandler.saveUserInfo(
            userName: event.name,
            phoneNumber: event.number,
            password: event.password,
          );
          Authentication().isRegistered = true;
          emit(RegisteringState(exception: AccountCreatedSuccessfully()));
          emit(const ConfirmNumberState());
        } on Exception catch (e) {
          emit(RegisteringState(exception: e));
        }
      },
    );

    on<LogoutEvent>((event, emit) async {
      emit(const LoggedInState());
    });

    on<LoginEvent>(
      (event, emit) async {
        emit(const LoggedInState(isLoading: true));
        try {
          final userInfo = await CacheHandler.getUserInfo();
          final storedName = userInfo['userName']?.trim().toLowerCase() ?? '';
          final storedPassword = userInfo['password']?.trim() ?? '';

          if (event.name.trim().toLowerCase() == storedName &&
              event.password.trim() == storedPassword) {
            Authentication().isRegistered = true;
            emit(const HomeState());
          } else {
            emit(LoggedInState(exception: WrongPasswordAuthExceptions()));
          }
        } on Exception catch (e) {
          emit(LoggedInState(exception: e));
        }
      },
    );

    on<ConfirmNumberEvent>(
      (event, emit) {
        emit(const ConfirmNumberState(isLoading: true));
        try {
          if (Authentication().otp == event.oTP) {
            if (Authentication().isRegistered) {
              emit(const HomeState());
            } else {
              emit(const RegisteringState());
            }
          } else {
            emit(ConfirmNumberState(exception: WrongOTPException()));
          }
        } on Exception catch (e) {
          emit(ConfirmNumberState(exception: e));
        }
      },
    );

    on<ChangePhoneNumberEvent>((event, emit) async {
      try {
        emit(const RegisteringState(isLoading: true));
        await CacheHandler.clearUserInfo();
        emit(const RegisteringState());
      } on Exception catch (e) {
        emit(LoggedInState(exception: e));
      }
    });

    on<ResendOTPEvent>((event, emit) async {
      try {
        emit(const ConfirmNumberState(isLoading: true));
        await OtpServices()
            .sendVerificationSMS(event.context, event.oTP, event.phoneNumber);
        emit(const ConfirmNumberState());
      } on Exception catch (e) {
        emit(ConfirmNumberState(exception: e));
      }
    });
  }
}
