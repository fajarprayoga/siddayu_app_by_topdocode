part of 'widget.dart';

class ButtonIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final String label;
  final String? placeholder;
  final void Function() onTapFunction;

  const ButtonIcon({
    Key? key, // Tambahkan 'Key?' pada konstruktor
    required this.icon,
    this.placeholder,
    required this.title,
    required this.label,
    required this.onTapFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          SizedBox(
            height: gap,
          ),
          Container(
            // alignment: Alignment.centerRight,
            child: InkWell(
              onTap:
                  onTapFunction, // Gunakan onTapFunction yang diteruskan dari konstruktor
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: padding, vertical: padding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius - 10),
                  color: primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon, // Gunakan icon yang diteruskan dari konstruktor
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      title, // Gunakan title yang diteruskan dari konstruktor
                      style: Gfont.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: gap - 4,
          ),
          Text(
            placeholder ?? '',
            style: Gfont.fs10,
          ),
        ],
      ),
    );
  }
}
