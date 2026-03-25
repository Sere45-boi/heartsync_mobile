import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value?.session?.user;
});

// Provides the current user's profile
final currentUserProfileProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  
  return Supabase.instance.client
      .from('profiles')
      .stream(primaryKey: ['id'])
      .eq('id', user.id)
      .map((event) => event.isNotEmpty ? event.first : null);
});

// Provides the couple's record
final coupleProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final profile = ref.watch(currentUserProfileProvider).value;
  if (profile == null || profile['couple_id'] == null) return const Stream.empty();

  return Supabase.instance.client
      .from('couples')
      .stream(primaryKey: ['id'])
      .eq('id', profile['couple_id'])
      .map((event) => event.isNotEmpty ? event.first : null);
});

// Provides the partner's profile
final partnerProfileProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final couple = ref.watch(coupleProvider).value;
  final currentUser = ref.watch(currentUserProvider);
  
  if (couple == null || currentUser == null) return const Stream.empty();

  final partnerId = couple['partner_a'] == currentUser.id ? couple['partner_b'] : couple['partner_a'];
  if (partnerId == null) return const Stream.empty();

  return Supabase.instance.client
      .from('profiles')
      .stream(primaryKey: ['id'])
      .eq('id', partnerId)
      .map((event) => event.isNotEmpty ? event.first : null);
});

// Shared Notes stream for the couple
final notesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final profile = ref.watch(currentUserProfileProvider).value;
  if (profile == null || profile['couple_id'] == null) return const Stream.empty();

  return Supabase.instance.client
      .from('notes')
      .stream(primaryKey: ['id'])
      .eq('couple_id', profile['couple_id'])
      .order('created_at', ascending: false);
});

// Shared Tasks stream for the couple
final tasksProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final profile = ref.watch(currentUserProfileProvider).value;
  if (profile == null || profile['couple_id'] == null) return const Stream.empty();

  return Supabase.instance.client
      .from('tasks')
      .stream(primaryKey: ['id'])
      .eq('couple_id', profile['couple_id'])
      .order('created_at', ascending: false);
});
