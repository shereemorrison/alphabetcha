import 'package:flutter/material.dart';

class GameTimerCard extends StatelessWidget {
  final int timeRemaining;

  const GameTimerCard({Key? key, required this.timeRemaining})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minutes = timeRemaining ~/ 60;
    final seconds = timeRemaining % 60;
    final isLowTime = timeRemaining <= 30;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isLowTime
            ? Colors.red.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLowTime
              ? Colors.red.withOpacity(0.3)
              : Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            color: isLowTime ? Colors.red : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: isLowTime ? Colors.red[700] : Colors.orange[700],
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'remaining',
            style: TextStyle(
              color: isLowTime ? Colors.red[700] : Colors.orange[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
