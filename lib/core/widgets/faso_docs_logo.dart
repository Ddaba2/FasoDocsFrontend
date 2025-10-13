import 'package:flutter/material.dart';
import '../theme/mali_theme.dart';

class FasoDocsLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;
  final double textSize;
  
  const FasoDocsLogo({
    super.key,
    this.size = 60.0,
    this.showText = true,
    this.textColor,
    this.textSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo avec les couleurs du Mali
        Container(
          width: size,
          height: size * 0.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size * 0.1),
            child: Row(
              children: [
                // Section verte avec icône document
                Expanded(
                  child: Container(
                    color: MaliColors.vert,
                    child: Center(
                      child: Icon(
                        Icons.description_outlined,
                        color: MaliColors.white,
                        size: size * 0.25,
                      ),
                    ),
                  ),
                ),
                // Section jaune avec flèche
                Expanded(
                  child: Container(
                    color: MaliColors.jaune,
                    child: Center(
                      child: Icon(
                        Icons.arrow_upward,
                        color: MaliColors.black,
                        size: size * 0.25,
                      ),
                    ),
                  ),
                ),
                // Section rouge
                Expanded(
                  child: Container(
                    color: MaliColors.rouge,
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: MaliColors.white,
                        size: size * 0.25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Texte FasoDocs
        if (showText) ...[
          const SizedBox(height: 8),
          Text(
            'FasoDocs',
            style: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.bold,
              color: textColor ?? MaliColors.black,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}

// Widget pour le logo simple (sans texte)
class FasoDocsLogoIcon extends StatelessWidget {
  final double size;
  
  const FasoDocsLogoIcon({
    super.key,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.1),
        child: Row(
          children: [
            // Section verte avec icône document
            Expanded(
              child: Container(
                color: MaliColors.vert,
                child: Center(
                  child: Icon(
                    Icons.description_outlined,
                    color: MaliColors.white,
                    size: size * 0.25,
                  ),
                ),
              ),
            ),
            // Section jaune avec flèche
            Expanded(
              child: Container(
                color: MaliColors.jaune,
                child: Center(
                  child: Icon(
                    Icons.arrow_upward,
                    color: MaliColors.black,
                    size: size * 0.25,
                  ),
                ),
              ),
            ),
            // Section rouge
            Expanded(
              child: Container(
                color: MaliColors.rouge,
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: MaliColors.white,
                    size: size * 0.25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
