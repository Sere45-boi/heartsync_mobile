import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';

class PairScreen extends StatefulWidget {
  const PairScreen({super.key});

  @override
  State<PairScreen> createState() => _PairScreenState();
}

class _PairScreenState extends State<PairScreen> {
  bool _isCreating = true;
  String? _inviteCode;
  final _codeController = TextEditingController();
  bool _isLoading = false;
  bool _isWaitingForPartner = false;

  @override
  void initState() {
    super.initState();
    _generateInviteCode();
  }

  void _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final code = String.fromCharCodes(Iterable.generate(
      6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
    setState(() => _inviteCode = code);
  }

  Future<void> _createSpace() async {
    setState(() => _isLoading = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      // Create couple record
      final coupleRes = await Supabase.instance.client.from('couples').insert({
        'partner_a': user.id,
        'invite_code': _inviteCode,
        'paired_at': null,
      }).select().single();

      // Update user profile
      await Supabase.instance.client.from('profiles').update({
        'couple_id': coupleRes['id']
      }).eq('id', user.id);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isWaitingForPartner = true;
        });
        _pollForPartnerInfo(coupleRes['id']);
      }
    } catch (e) {
      _showError(e.toString());
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pollForPartnerInfo(String coupleId) async {
    while (_isWaitingForPartner && mounted) {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) break;
      try {
        final res = await Supabase.instance.client
            .from('couples')
            .select()
            .eq('id', coupleId)
            .maybeSingle();
        if (res != null && res['partner_b'] != null) {
          _showSuccessAndGoHome();
          break;
        }
      } catch (_) {}
    }
  }

  Future<void> _joinSpace() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.length != 6) {
      _showError("Code must be 6 characters");
      return;
    }
    setState(() => _isLoading = true);
    
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      // Find couple by code
      final coupleRes = await Supabase.instance.client
          .from('couples')
          .select()
          .eq('invite_code', code)
          .maybeSingle();

      if (coupleRes == null) {
        _showError("Invalid invite code");
        setState(() => _isLoading = false);
        return;
      }

      // Update couple record with partner_b
      await Supabase.instance.client.from('couples').update({
        'partner_b': user.id,
        'paired_at': DateTime.now().toIso8601String(),
        'invite_code': null, // Invalidate code after use
      }).eq('id', coupleRes['id']);

      // Update user profile
      await Supabase.instance.client.from('profiles').update({
        'couple_id': coupleRes['id']
      }).eq('id', user.id);

      _showSuccessAndGoHome();
    } catch (e) {
      _showError(e.toString());
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessAndGoHome() {
    // In a full implementation, add Lottie confetti here
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) context.go('/home');
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: AppColors.error, content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _isCreating ? 'Create Invite' : 'Join Partner',
          style: const TextStyle(color: AppColors.primary),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => _isCreating = !_isCreating),
            child: Text(_isCreating ? 'Join Instead' : 'Create Instead'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isCreating) ...[
              const Text("Share this code with your partner:", textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _inviteCode ?? '...',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),
              if (_isWaitingForPartner)
                Column(
                  children: [
                    const CircularProgressIndicator(color: AppColors.primary),
                    const SizedBox(height: 16),
                    const Text("Waiting for partner to join...", style: TextStyle(color: AppColors.primary)),
                  ],
                )
              else
                ElevatedButton(
                  onPressed: _isLoading ? null : _createSpace,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: AppColors.surface)
                    : const Text("Create Space"),
                ),
            ] else ...[
              TextField(
                controller: _codeController,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 4),
                decoration: const InputDecoration(hintText: "Enter 6-digit code"),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _isLoading ? null : _joinSpace,
                child: _isLoading
                  ? const CircularProgressIndicator(color: AppColors.surface)
                  : const Text("Connect our hearts"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
