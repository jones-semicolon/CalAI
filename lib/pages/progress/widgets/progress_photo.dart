import 'package:flutter/material.dart';

import '../screens/progress_photo/progress_photo_view.dart';

/// A card widget that prompts the user to upload progress photos.
///
/// It displays an invitation message and an "Upload a Photo" button, and is
/// designed to be tappable to potentially open a detailed view.
class ProgressPhoto extends StatelessWidget {
  const ProgressPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProgressPhotoView(),
          ),
        );
      },
      child: Container(
        // The styling for the main container is preserved.
        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 30),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        // The main layout is a Column, now composed of smaller, focused widgets.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Header(),
            SizedBox(height: 10),
            _ContentRow(),
          ],
        ),
      ),
    );
  }
}

// --- Private Helper Widgets --- //

/// Displays the header text for the card.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    // Styling is preserved from the original implementation.
    return Text(
      'Progress Photos',
      style: TextStyle(
        fontSize: 22,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

/// Displays the main content row, containing the image icon and info column.
class _ContentRow extends StatelessWidget {
  const _ContentRow();

  @override
  Widget build(BuildContext context) {
    // This widget's structure is identical to the original implementation.
    return Row(
      children: const [
        Icon(Icons.image, size: 75),
        SizedBox(width: 10),
        _InfoColumn(),
      ],
    );
  }
}

/// Displays the column with the descriptive text and the upload button.
class _InfoColumn extends StatelessWidget {
  const _InfoColumn();

  @override
  Widget build(BuildContext context) {
    // Using Flexible to allow the text to wrap correctly.
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Want to add a photo to track your progress?',
            softWrap: true,
            // Styling is preserved from the original implementation.
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          const _UploadButton(),
        ],
      ),
    );
  }
}

/// Displays the "Upload a Photo" button with its icon and text.
class _UploadButton extends StatelessWidget {
  const _UploadButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement function for selecting from gallery.
      },
      child: Container(
        // Styling for the button container is preserved.
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.primary,
              size: 18,
            ),
            const SizedBox(width: 2),
            Text(
              'Upload a Photo',
              // Styling for the button text is preserved.
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.primary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}