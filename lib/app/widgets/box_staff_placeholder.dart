part of 'widget.dart';

class BoxStaffPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: List.generate(
          6,
          (index) => shimmer.Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: InkWell(
              onTap:
                  () {}, // You can provide an empty onTap for the placeholder
              child: Container(
                height: 68,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.purple[100],
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                width: (MediaQuery.of(context).size.width / 2) - 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 16, // Adjust the height to match the text style
                      width: 100, // Adjust the width to match the text style
                      color: Colors.grey[100],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
