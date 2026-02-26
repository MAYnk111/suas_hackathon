import 'package:flutter/material.dart';
import 'package:sudha_app/pregnancy_role/data/models/resource_article_model.dart';
import 'package:sudha_app/pregnancy_role/presentation/pages/article_viewer_page.dart';

class ResourceCard extends StatelessWidget {
  final ResourceArticleModel article;

  const ResourceCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.cardTheme.color,
        border: Border.all(
          color: colorScheme.secondary.withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.secondary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => ArticleViewerPage(article: article)),
            );
          },
          customBorder: theme.cardTheme.shape,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize.min, // Changed to min specifically for Masonry
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: article.color.withOpacity(0.15),
                        border: Border.all(
                          color: article.color.withOpacity(0.3),
                          width: 1,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(article.icon, color: article.color, size: 22),
                    ),
                    if (article.category != 'General')
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colorScheme.secondary.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            article.category,
                            style: TextStyle(
                              color: colorScheme.secondary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                    height:
                        16), // Replaced Spacer to avoid unbound height issues
                Flexible(
                  child: Text(
                    article.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                      height: 1.2,
                    ),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      article.readingTime,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

