import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/core/theme/app_theme.dart';
import 'package:yoga_app/domain/entities/yoga_session.dart';
import 'package:yoga_app/presentation/bloc/session/session_bloc.dart';
import 'package:yoga_app/presentation/pages/session_player_page.dart';

class SessionPreviewPage extends StatelessWidget {
  const SessionPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('Session Preview'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<SessionBloc, SessionBlocState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: Text('No session loaded')),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (sessionState) =>
                _buildPreview(context, sessionState.session!),
            playing: (sessionState) =>
                _buildPreview(context, sessionState.session!),
            paused: (sessionState) =>
                _buildPreview(context, sessionState.session!),
            stopped: (sessionState) =>
                _buildPreview(context, sessionState.session!),
            completed: (sessionState) =>
                _buildPreview(context, sessionState.session!),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading session',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreview(BuildContext context, YogaSession session) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSessionHeader(context, session),
                const SizedBox(height: 32),
                _buildPoseSequence(context, session),
              ],
            ),
          ),
        ),
        _buildStartButton(context),
      ],
    );
  }

  Widget _buildSessionHeader(BuildContext context, YogaSession session) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.self_improvement,
                    color: AppTheme.primaryGreen,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.metadata.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.metadata.category
                            .replaceAll('_', ' ')
                            .toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.loop,
                  label: '${session.metadata.defaultLoopCount} loops',
                ),
                const SizedBox(width: 12),
                _InfoChip(icon: Icons.speed, label: session.metadata.tempo),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoseSequence(BuildContext context, YogaSession session) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pose Sequence',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...session.sequence.asMap().entries.map((entry) {
          final index = entry.key;
          final sequence = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SequenceCard(
              index: index + 1,
              sequence: sequence,
              session: session,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SessionPlayerPage(),
                ),
              );
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
                  'Start Session',
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
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accentTeal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.accentTeal),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.accentTeal,
            ),
          ),
        ],
      ),
    );
  }
}

class _SequenceCard extends StatelessWidget {
  final int index;
  final SequenceItem sequence;
  final YogaSession session;

  const _SequenceCard({
    required this.index,
    required this.sequence,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sequence.name.replaceAll('_', ' ').toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '${sequence.durationSec}s',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (sequence is LoopItem)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Repeats ${(sequence as LoopItem).iterations} times',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.accentTeal,
                        ),
                      ),
                    ),
                  ),
                ...sequence.script.map(
                  (script) => _ScriptItem(script: script, session: session),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScriptItem extends StatelessWidget {
  final ScriptItem script;
  final YogaSession session;

  const _ScriptItem({required this.script, required this.session});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.lightBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.textSecondary.withOpacity(0.2),
              ),
            ),
            child: _buildPoseImage(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${script.startSec}s - ${script.endSec}s',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  script.text,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoseImage() {
    // In a real app, you would load the actual image
    // For now, we'll show an icon based on the pose
    IconData icon;
    switch (script.imageRef) {
      case 'cat':
        icon = Icons.keyboard_arrow_up;
        break;
      case 'cow':
        icon = Icons.keyboard_arrow_down;
        break;
      default:
        icon = Icons.self_improvement;
    }

    return Icon(icon, color: AppTheme.primaryGreen, size: 24);
  }
}
