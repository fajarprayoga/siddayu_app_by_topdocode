part of 'widget.dart';

class ProgressKegiatanPlaceholder extends StatelessWidget {
  const ProgressKegiatanPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Expanded(
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white, // Set the color of the placeholder
            borderRadius:
                BorderRadius.circular(8.0), // Set the border radius as needed
          ),
        ),
      ),
    );
  }
}
