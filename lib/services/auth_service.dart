import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

abstract class AuthBase {
  Stream<UserModel?> get onAuthStateChanged;
  UserModel? currentUser();
  Future<UserModel?> signInAnonymously();
  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  Future<UserModel?> createUserWithEmailAndPassword(
      String email, String password);
  Future<void> passwordReset(String email);
  Future<UserModel?> signInWithGoogle();
  // Future<UserModel?> signInWithFacebook();
  Future<void> signOut();
}

class AuthService implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  static const String clientId =
      '87655672816-d8vqvmflt05edcq78el8375rhurrg570.apps.googleusercontent.com';
  static const String webClientId =
      '1013929161210-sckorf41obbiadtdlvtt4e9ua05b6jiu.apps.googleusercontent.com';

  UserModel? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(uid: user.uid, email: user.email);
  }

  @override
  Stream<UserModel?> get onAuthStateChanged {
    return _firebaseAuth.idTokenChanges().map(_userFromFirebase);
  }

  @override
  UserModel? currentUser() {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    Fluttertoast.showToast(
        msg: "Signing in",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16.0);
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      Fluttertoast.showToast(
          msg: "Signing in",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return _userFromFirebase(authResult.user);
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "Error sigining in with email: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      if (kDebugMode) {
        print('Error sigining in with email: $e');
      }
      rethrow;
    }
  }

  @override
  Future<UserModel?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      Fluttertoast.showToast(
          msg: "Creating account",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return _userFromFirebase(authResult.user);
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "Error creating account: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      if (kDebugMode) {
        print('Error creating account: $e');
      }
      rethrow;
    }
  }

  @override
  Future<void> passwordReset(
    String email,
  ) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
      );
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    final googleSignIn = kIsWeb
        ? GoogleSignIn(
            clientId: webClientId,
          )
        : GoogleSignIn(
            // scopes: [
            //   'email',
            //   'profile',
            // ],
            scopes: [],
            serverClientId: clientId,
            // clientId: clientId,
          );
    GoogleSignInAccount? googleAccount = kIsWeb
        ? await googleSignIn.signInSilently()
        : await googleSignIn.signIn();
    if (kIsWeb && googleAccount == null) {
      googleAccount = await (googleSignIn.signIn());
    }
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (kIsWeb ||
          (googleAuth.accessToken != null && googleAuth.idToken != null)) {
        final authResult = await _firebaseAuth.signInWithCredential(
          kIsWeb
              ? GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                )
              : GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken,
                ),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<void> signOut() async {
    Fluttertoast.showToast(
        msg: "Logging out",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16.0);
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    //  final facebookLogin = FacebookLogin();
    // await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }

  /*
  @override
  Future<UserModel> signInWithFacebook() async {
      final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logInWithReadPermissions(
      ['public_profile'],
    );
    if (result.accessToken != null) {
      final authResult = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        ),
      );
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }
  */

  /* 
   Future<UserModel?> signInWithPhoneNumber(String phoneno, String code) async {
    ConfirmationResult confirmationResult =
        await _firebaseAuth.signInWithPhoneNumber(
      phoneno,
    );
    UserCredential userCredential = await confirmationResult.confirm(code);
    return _userFromFirebase(userCredential.user);
  }

  Future<ConfirmationResult> signInWithPhoneNumber2(String string) async {
    ConfirmationResult confirmationResult =
        await _firebaseAuth.signInWithPhoneNumber(
      string,
    );

    return confirmationResult;
  }

  Future<UserModel?> signInWithOTPCode(
      ConfirmationResult confirmationResult, String code) async {
    UserCredential userCredential = await confirmationResult.confirm(code);
    return _userFromFirebase(userCredential.user);
  }

  Future<UserModel?> signInWithOTP(String smsCode, String verId) async {
    AuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    final authResult = await _firebaseAuth.signInWithCredential(credential);
    return _userFromFirebase(authResult.user);
  }
*/
}
