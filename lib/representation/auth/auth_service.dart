import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<AuthResponse> signInWithGoogle() async {
  // 1. Cấu hình GoogleSignIn với thông tin thật từ GCP
  final googleSignIn = GoogleSignIn(
    // Lấy từ Client ID loại iOS trên GCP
    clientId: dotenv.env['GOOGLE_IOS_CLIENT_ID'],

    // Lấy từ Client ID loại Web trên GCP (Dùng để xác thực với Supabase)
    serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],
  );

  final googleUser = await googleSignIn.signIn();

  if (googleUser == null) {
    throw 'Người dùng đã hủy đăng nhập.';
  }

  final googleAuth = await googleUser.authentication;
  final accessToken = googleAuth.accessToken;
  final idToken = googleAuth.idToken;

  if (idToken == null) {
    throw 'Không tìm thấy ID Token.';
  }

  // 2. Đăng nhập vào Supabase bằng Token lấy từ Google
  return await Supabase.instance.client.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: idToken,
    accessToken: accessToken,
  );
}

Future<AuthResponse> signUpWithEmail(
  String email,
  String password,
  String name,
) async {
  return await Supabase.instance.client.auth.signUp(
    email: email,
    password: password,
    data: {'full_name': name},
  );
}

Future<AuthResponse> signInWithEmail(String email, String password) async {
  return await Supabase.instance.client.auth.signInWithPassword(
    email: email,
    password: password,
  );
}
