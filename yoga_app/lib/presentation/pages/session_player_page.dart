import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:math' as math;

import 'package:yoga_app/core/theme/app_theme.dart';
import 'package:yoga_app/domain/entities/session_state.dart';
import 'package:yoga_app/presentation/bloc/session/session_bloc.dart';

class SessionPlayerPage extends StatefulWidget {
  const SessionPlayerPage({super.key});

  @override
  State<SessionPlayerPage> createState() => _SessionPlayerPageState();
}

class _SessionPlayerPageState extends State<SessionPlayerPage>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _fadeController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _breathingController.repeat(reverse: true);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: BlocListener<SessionBloc, SessionBlocState>(
        listener: (context, state) {
          state.maybeWhen(
            completed: (sessionState) {
              _showCompletionDialog(context);
            },
            orElse: () {},
          );
        },
        child: BlocBuilder<SessionBloc, SessionBlocState>(
          builder: (context, state) {
            return state.when(
              initial: () => _buildIdleState(context),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (sessionState) =>
                  _buildSessionPlayer(context, sessionState),
              playing: (sessionState) =>
                  _buildSessionPlayer(context, sessionState),
              paused: (sessionState) =>
                  _buildSessionPlayer(context, sessionState),
              stopped: (sessionState) =>
                  _buildSessionPlayer(context, sessionState),
              completed: (sessionState) =>
                  _buildSessionPlayer(context, sessionState),
              error: (message) => _buildErrorState(context, message),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIdleState(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _breathingAnimation,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.primaryGreen.withOpacity(0.3),
                              AppTheme.primaryGreen.withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.self_improvement,
                          size: 80,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Ready to begin?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tap the button below to start your yoga session',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<SessionBloc>().add(const StartSessionEvent());
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Begin Session',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionPlayer(BuildContext context, SessionState sessionState) {
    final progress = sessionState.totalDuration.inSeconds > 0
        ? sessionState.currentDuration.inSeconds /
              sessionState.totalDuration.inSeconds
        : 0.0;

    return SafeArea(
      child: Column(
        children: [
          _buildHeader(context, sessionState),
          Expanded(child: _buildPoseDisplay(context, sessionState)),
          _buildInstructionText(context, sessionState),
          _buildProgressBar(context, progress, sessionState),
          _buildControls(context, sessionState),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SessionState sessionState) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context.read<SessionBloc>().add(const StopSessionEvent());
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
          Expanded(
            child: Text(
              sessionState.session?.metadata.title ?? 'Yoga Session',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<SessionBloc>().add(
                const ToggleBackgroundMusicEvent(),
              );
            },
            icon: Icon(
              sessionState.isBackgroundMusicEnabled
                  ? Icons.music_note
                  : Icons.music_off,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoseDisplay(BuildContext context, SessionState sessionState) {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: Container(
          key: ValueKey(sessionState.currentImagePath ?? 'default'),
          child: ScaleTransition(
            scale: _breathingAnimation,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primaryGreen.withOpacity(0.2),
                    AppTheme.primaryGreen.withOpacity(0.05),
                  ],
                ),
              ),
              child: _buildPoseIcon(sessionState.currentImagePath),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPoseIcon(String? imagePath) {
    // In a real app, you would load the actual image
    // For now, we'll show icons based on the pose
    IconData icon;
    Color color;

    switch (imagePath?.split('.').first) {
      case 'Cat':
        icon = Icons.keyboard_arrow_up;
        color = AppTheme.accentTeal;
        break;
      case 'Cow':
        icon = Icons.keyboard_arrow_down;
        color = AppTheme.primaryGreen;
        break;
      default:
        icon = Icons.self_improvement;
        color = AppTheme.primaryGreen;
    }

    return Icon(icon, size: 100, color: color);
  }

  Widget _buildInstructionText(
    BuildContext context,
    SessionState sessionState,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Text(
          sessionState.currentText ?? 'Get ready...',
          key: ValueKey(sessionState.currentText),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: AppTheme.textPrimary,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    double progress,
    SessionState sessionState,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(sessionState.currentDuration),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _formatDuration(sessionState.totalDuration),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppTheme.textSecondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, SessionState sessionState) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              context.read<SessionBloc>().add(const StopSessionEvent());
            },
            icon: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.stop, color: Colors.red, size: 24),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (sessionState.status == SessionStatus.playing) {
                context.read<SessionBloc>().add(const PauseSessionEvent());
              } else if (sessionState.status == SessionStatus.paused) {
                context.read<SessionBloc>().add(const ResumeSessionEvent());
              } else {
                context.read<SessionBloc>().add(const StartSessionEvent());
              }
            },
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                sessionState.status == SessionStatus.playing
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // Placeholder for skip functionality
            },
            icon: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.skip_next,
                color: AppTheme.textSecondary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: AppTheme.primaryGreen,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Text('Session Complete!'),
          ],
        ),
        content: const Text(
          'Congratulations on completing your yoga session. Take a moment to notice how you feel.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to preview
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }
}

extension SessionBlocStateX on SessionBlocState {
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(SessionState sessionState) loaded,
    required T Function(SessionState sessionState) playing,
    required T Function(SessionState sessionState) paused,
    required T Function(SessionState sessionState) stopped,
    required T Function(SessionState sessionState) completed,
    required T Function(String message) error,
  }) {
    final state = this;
    if (state is Initial) return initial();
    if (state is Loading) return loading();
    if (state is Loaded) return loaded(state.sessionState);
    if (state is Playing) return playing(state.sessionState);
    if (state is Paused) return paused(state.sessionState);
    if (state is Stopped) return stopped(state.sessionState);
    if (state is Completed) return completed(state.sessionState);
    if (state is Error) return error(state.message);
    throw StateError('Unknown state: $state');
  }

  T? maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(SessionState sessionState)? loaded,
    T Function(SessionState sessionState)? playing,
    T Function(SessionState sessionState)? paused,
    T Function(SessionState sessionState)? stopped,
    T Function(SessionState sessionState)? completed,
    T Function(String message)? error,
    required T Function() orElse,
  }) {
    final state = this;
    if (state is Initial && initial != null) return initial();
    if (state is Loading && loading != null) return loading();
    if (state is Loaded && loaded != null) return loaded(state.sessionState);
    if (state is Playing && playing != null) return playing(state.sessionState);
    if (state is Paused && paused != null) return paused(state.sessionState);
    if (state is Stopped && stopped != null) return stopped(state.sessionState);
    if (state is Completed && completed != null)
      return completed(state.sessionState);
    if (state is Error && error != null) return error(state.message);
    return orElse();
  }
}
