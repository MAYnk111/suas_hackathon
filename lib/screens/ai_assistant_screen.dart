import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ai_assistant_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/app_card.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    final provider = context.read<AIAssistantProvider>();
    await provider.sendMessage(text);

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final aiProvider = context.watch<AIAssistantProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('AI Healthcare Assistant'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: aiProvider.messages.isEmpty
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Clear Chat'),
                        content: const Text('Clear all messages?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              aiProvider.clearChat();
                              Navigator.pop(ctx);
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    );
                  },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (aiProvider.messages.isEmpty)
              AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Start a conversation',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Ask health-related questions, get information about symptoms, or discuss wellness topics.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppTheme.mutedForeground),
                    ),
                  ],
                ),
              )
            else
              ...aiProvider.messages.map((msg) {
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: msg.isUser ? AppTheme.primary : AppTheme.card,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(msg.isUser ? 12 : 0),
                        bottomRight: Radius.circular(msg.isUser ? 0 : 12),
                      ),
                      border: msg.isUser ? null : Border.all(color: AppTheme.border, width: 1),
                    ),
                    child: Text(
                      msg.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: msg.isUser ? AppTheme.primaryForeground : null,
                          ),
                    ),
                  ),
                );
              }),
            if (aiProvider.error != null) ...[
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Text(
                  aiProvider.error!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.destructive,
                      ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask a question...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    enabled: !aiProvider.isLoading,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                FloatingActionButton(
                  onPressed: aiProvider.isLoading ? null : _sendMessage,
                  mini: true,
                  child: aiProvider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primaryForeground,
                          ),
                        )
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
