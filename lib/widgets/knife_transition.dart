import 'package:flutter/material.dart';

class KnifeTransition extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double initialOffset;

  const KnifeTransition({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.initialOffset = 100.0,
  });

  @override
  State<KnifeTransition> createState() => _KnifeTransitionState();
}

class _KnifeTransitionState extends State<KnifeTransition> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // "Knife" ease out curve: starts incredibly fast, then suddenly slows down and settles
    final curve = CurvedAnimation(
      parent: _controller,
      curve: const Cubic(0.1, 1.0, 0.2, 1.0),
    );

    _slideAnimation = Tween<double>(begin: widget.initialOffset, end: 0.0).animate(curve);
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}
