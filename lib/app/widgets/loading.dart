part of 'widget.dart';

class Loading extends StatelessWidget {
  final bool isLoading;

  const Loading({Key? key, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          ) // Display a loading indicator if isLoading is true
        : const Placeholder(); // Display a placeholder if isLoading is false
  }
}
