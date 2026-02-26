import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/medicine_safety_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_spacing.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';

class MedicineSafetyScreen extends StatelessWidget {
  const MedicineSafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicineSafetyProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Medicine Safety')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const SectionHeader(
              title: 'Medicine Safety',
              subtitle: 'Verify medicine authenticity with a quick scan',
            ),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Upload Medicine Image', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  _ImagePreview(filePath: provider.selectedImage?.path),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => context.read<MedicineSafetyProvider>().selectImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Gallery'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.read<MedicineSafetyProvider>().selectImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('Camera'),
                      ),
                      if (provider.selectedImage != null)
                        TextButton(
                          onPressed: () => context.read<MedicineSafetyProvider>().clearImage(),
                          child: const Text('Remove'),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.selectedImage == null || provider.isLoading
                          ? null
                          : () => context.read<MedicineSafetyProvider>().verifySelectedImage(),
                      child: provider.isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryForeground),
                            )
                          : const Text('Verify medicine'),
                    ),
                  ),
                  if (provider.error != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    // Check if this is a validation error (not a medicine image)
                    if (provider.validationError != null)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.warning_amber, color: Colors.orange.shade700, size: 24),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Image Validation Failed',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade900,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              provider.error!,
                              style: TextStyle(color: Colors.orange.shade900),
                            ),
                            if (provider.validationError!.details != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Details:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange.shade900,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '• Reason: ${provider.validationError!.reason}',
                                      style: TextStyle(
                                        color: Colors.orange.shade900,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '• Confidence: ${(provider.validationError!.confidence * 100).toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        color: Colors.orange.shade900,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Please upload:\n✓ Medicine strip/blister pack\n✓ Pill bottle with label\n✓ Medical packaging',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      // Regular error (network, backend, etc.)
                      Text(provider.error!, style: const TextStyle(color: AppTheme.destructive)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (provider.result != null)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Verification Result', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    _RiskPill(level: provider.result!.riskLevel),
                    const SizedBox(height: AppSpacing.md),
                    Text('Confidence: ${provider.result!.confidence}%'),
                    const SizedBox(height: AppSpacing.md),
                    Text(provider.result!.message),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Processed at: ${provider.result!.metadata['processedAt'] ?? 'N/A'}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppTheme.mutedForeground),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final String? filePath;

  const _ImagePreview({this.filePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.muted,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: filePath == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.photo, size: 40, color: AppTheme.mutedForeground),
                const SizedBox(height: 8),
                Text(
                  'Upload a clear medicine strip photo',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppTheme.mutedForeground),
                ),
              ],
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(filePath!),
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}

class _RiskPill extends StatelessWidget {
  final String level;

  const _RiskPill({required this.level});

  @override
  Widget build(BuildContext context) {
    final color = _resolveColor(level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        level,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Color _resolveColor(String level) {
    switch (level.toLowerCase()) {
      case 'high':
        return AppTheme.destructive;
      case 'moderate':
        return AppTheme.coral;
      case 'low':
        return AppTheme.sage;
      default:
        return AppTheme.mutedForeground;
    }
  }
}
