import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onPressed;
  const TextContainer({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(icon, color: Colors.blue),
                ),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.chevron_right_sharp),
          ),
        ],
      ),
    );
  }
}
