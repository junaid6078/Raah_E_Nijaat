import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../navigator/navigator.dart';
class AuthService {
  // for storing data in cloud firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> SignUpWithEmailAndPassword(
      {required BuildContext context,
      required String name,
      required String emailAddress,
      required String password}) async {
    try {
      // Attempt to create a new user with the provided email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      // for addin user in cloud firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        'name': name,
        'email': emailAddress,
        'uid': userCredential.user!.uid,
      });

      // Handle successful sign-up (e.g., send email verification, navigate to another screen)
      User? user = userCredential.user;
      if (user != null) {
        // Optionally, send a verification email
        await user.sendEmailVerification();

        // Navigate to another screen or display a success message

        AppNavigator.toHome(context);
      }
    } on FirebaseAuthException catch (e) {
      // Handle different error codes
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else {
        message = 'An unexpected error occurred. Please try again later.';
      }

      // Display the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      // Catch any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('An unexpected error occurred. Please try again later.')),
      );
    }
    return "some error";
  }
}

Future<void> signInWithEmailAndPassword(
    BuildContext context, String emailAddress, String password) async {
  try {
    // Attempt to sign in the user with the provided email and password
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    // Check if the user was successfully signed in
    User? user = userCredential.user;
    if (user != null) {
      // Navigate to the Home Page
      AppNavigator.toHome(context);
    }
  } on FirebaseAuthException catch (e) {
    String message;
    if (e.code == 'user-not-found') {
      message = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      message = 'Wrong password provided for that user.';
    } else if (e.code == 'invalid-email') {
      message = 'The email address is not valid.';
    } else {
      message = 'Wrong email or password. Please try again later.';
    }

    // Display the error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content:
              Text('An unexpected error occurred. Please try again later.')),
    );
  }
}

Future<UserCredential?> signInWithGoogle() async {
  try {
    // Initialize Google Sign-In
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      // User canceled the sign-in
      return null;
    }

    // Obtain the authentication details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print('Error during Google sign-in: $e');
    // Optionally, handle error by showing a message to the user
    return null;
  }
}
