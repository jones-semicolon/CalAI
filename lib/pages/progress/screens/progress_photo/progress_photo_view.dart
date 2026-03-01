import 'package:calai/widgets/header_widget.dart';
import 'package:calai/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgressPhotoView extends ConsumerStatefulWidget {
  const ProgressPhotoView({super.key});

  @override
  ConsumerState<ProgressPhotoView> createState() => _ProgressPhotoViewState();
}

class _ProgressPhotoViewState extends ConsumerState<ProgressPhotoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: SizedBox.shrink(),
              actions: [Icon(Icons.more_vert)],
            ),
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(context.l10n.progressPhotosTitle),
                    Text(context.l10n.progressPhotoPrompt),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
