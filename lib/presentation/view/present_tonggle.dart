import 'package:flutter/material.dart';

class PresenceToggle extends StatefulWidget {
  final bool isPresent;
  final ValueChanged<bool> onChanged;

  const PresenceToggle({super.key, required this.isPresent, required this.onChanged});

  @override
  _PresenceToggleState createState() => _PresenceToggleState();
}

class _PresenceToggleState extends State<PresenceToggle> {
  late bool isPresent;

  @override
  void initState() {
    super.initState();
    isPresent = widget.isPresent;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color containerColor = theme.brightness == Brightness.dark
        ? Colors.grey[850]!
        : Colors.grey[200]!;
    Color textColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    Color presentColor = isPresent ? Colors.green : textColor;
    Color absentColor = isPresent ? textColor : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: containerColor,
        border: Border.all(
          color: theme.brightness == Brightness.dark ? Colors.grey : Colors.grey[400]!,
       width: 0.5 ),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Present',
                  style: TextStyle(
                    fontSize: 16,
                    color: presentColor,
                    fontWeight: isPresent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              Switch(
                value: isPresent,
                onChanged: (value) {
                  setState(() {
                    isPresent = value;
                    widget.onChanged(isPresent);
                  });
                },
                activeColor: Colors.green,
                inactiveThumbColor: Colors.red,
                inactiveTrackColor: Colors.red.withOpacity(0.3),
              ),
              Expanded(
                child: Text(
                  'Absent',
                  style: TextStyle(
                    fontSize: 16,
                    color: absentColor,
                    fontWeight: isPresent ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
