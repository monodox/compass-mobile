import 'package:flutter/material.dart';

class VisualPage extends StatefulWidget {
  const VisualPage({super.key});

  @override
  State<VisualPage> createState() => _VisualPageState();
}

class _VisualPageState extends State<VisualPage> {
  bool _hasImage = false;
  bool _analyzing = false;
  bool _hasExplanation = false;

  void _simulateUpload() {
    setState(() => _hasImage = true);
  }

  void _analyzeImage() {
    setState(() => _analyzing = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() { _analyzing = false; _hasExplanation = true; });
    });
  }

  void _reset() => setState(() { _hasImage = false; _analyzing = false; _hasExplanation = false; });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visual Lab'),
        actions: [
          if (_hasImage)
            IconButton(icon: const Icon(Icons.refresh), onPressed: _reset, tooltip: 'Reset'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _ImagePreviewPanel(hasImage: _hasImage, onUpload: _simulateUpload),
            const SizedBox(height: 20),
            if (_hasImage && !_hasExplanation)
              _AnalyzeButton(analyzing: _analyzing, onAnalyze: _analyzeImage),
            if (_hasExplanation) ...[
              const SizedBox(height: 8),
              const Expanded(child: _ExplanationPanel()),
            ],
            if (!_hasImage) ...[
              const SizedBox(height: 20),
              _UploadOptions(onUpload: _simulateUpload),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImagePreviewPanel extends StatelessWidget {
  final bool hasImage;
  final VoidCallback onUpload;
  const _ImagePreviewPanel({required this.hasImage, required this.onUpload});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: hasImage ? null : onUpload,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasImage ? cs.primary : cs.outlineVariant,
            width: hasImage ? 2 : 1,
          ),
        ),
        child: hasImage
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 64, color: cs.primary),
                  const SizedBox(height: 8),
                  Text('Image ready for analysis',
                      style: TextStyle(color: cs.primary, fontWeight: FontWeight.w500)),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, size: 48, color: cs.onSurfaceVariant),
                  const SizedBox(height: 8),
                  Text('Tap to upload an image',
                      style: TextStyle(color: cs.onSurfaceVariant)),
                ],
              ),
      ),
    );
  }
}

class _UploadOptions extends StatelessWidget {
  final VoidCallback onUpload;
  const _UploadOptions({required this.onUpload});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: onUpload,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Image'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onUpload,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Take Photo'),
          ),
        ),
      ],
    );
  }
}

class _AnalyzeButton extends StatelessWidget {
  final bool analyzing;
  final VoidCallback onAnalyze;
  const _AnalyzeButton({required this.analyzing, required this.onAnalyze});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: analyzing ? null : onAnalyze,
      icon: analyzing
          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : const Icon(Icons.auto_awesome),
      label: Text(analyzing ? 'Analyzing...' : 'Explain Diagram'),
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
    );
  }
}

class _ExplanationPanel extends StatelessWidget {
  const _ExplanationPanel();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: cs.secondary, size: 18),
              const SizedBox(width: 8),
              Text('AI Explanation', style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Connect your Vision API to receive real-time AI explanations of uploaded diagrams and images.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.volume_up, size: 16),
            label: const Text('Play Voice Explanation'),
          ),
        ],
      ),
    );
  }
}
