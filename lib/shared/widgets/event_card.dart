import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/event.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.isSaved = false,
    this.onToggleSave,
    this.trailing,
  });

  final Event event;
  final VoidCallback onTap;
  final bool isSaved;
  final VoidCallback? onToggleSave;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateLabel = DateFormat('EEE, MMM d · h:mm a').format(event.date);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (event.posterUrl != null && event.posterUrl!.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: event.posterUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => Container(color: theme.colorScheme.surfaceContainerHighest),
                    )
                  else
                    Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.event, size: 40, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  if (onToggleSave != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _SaveButton(isSaved: isSaved, onPressed: onToggleSave!),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: theme.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(dateLabel, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.place_outlined, size: 14, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(event.location, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(
                        label: Text(event.isFree ? 'Free' : '\$${event.price}'),
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        event.isFull ? 'Full' : '${event.spotsLeft} spots left',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: event.isFull ? theme.colorScheme.error : null,
                        ),
                      ),
                      const Spacer(),
                      ?trailing,
                    ],
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

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.isSaved, required this.onPressed});

  final bool isSaved;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.4),
      shape: const CircleBorder(),
      child: IconButton(
        icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
