import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

/// Central access point for Supabase client
class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;
  static GoTrueClient get auth => client.auth;
  static SupabaseStorageClient get storage => client.storage;

  static User? get currentUser => auth.currentUser;
  static bool get isLoggedIn => currentUser != null;

  // ── Auth ──────────────────────────────────────────────────────────────────

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) =>
      auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) =>
      auth.signInWithPassword(email: email, password: password);

  static Future<void> signOut() => auth.signOut();

  static Future<void> sendPasswordResetEmail(String email) =>
      auth.resetPasswordForEmail(email);

  static Future<UserResponse> updatePassword(String newPassword) =>
      auth.updateUser(UserAttributes(password: newPassword));

  static Stream<AuthState> get authStateChanges => auth.onAuthStateChange;

  // ── Database ──────────────────────────────────────────────────────────────

  /// Sessions table
  static SupabaseQueryBuilder get sessions => client.from('sessions');

  /// Saved concepts table
  static SupabaseQueryBuilder get concepts => client.from('concepts');

  /// User profiles table
  static SupabaseQueryBuilder get profiles => client.from('profiles');

  // ── Storage ───────────────────────────────────────────────────────────────

  /// Upload an image to the 'visual-lab' bucket
  static Future<String> uploadImage(String path, List<int> bytes) async {
    await storage.from('visual-lab').uploadBinary(path, Uint8List.fromList(bytes));
    return storage.from('visual-lab').getPublicUrl(path);
  }

  /// Delete an image from the 'visual-lab' bucket
  static Future<void> deleteImage(String path) =>
      storage.from('visual-lab').remove([path]);
}
