import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '../theme/app_theme.dart';

class ReactiveTile extends StatefulWidget {
  final Widget child;
  final double height;
  final double width;
  final VoidCallback? onTap;

  const ReactiveTile({
    super.key,
    required this.child,
    this.height = 150,
    this.width = double.infinity,
    this.onTap,
  });

  @override
  State<ReactiveTile> createState() => _ReactiveTileState();
}

class _ReactiveTileState extends State<ReactiveTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  Offset _pointerPosition = Offset.zero;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverEnter(PointerEvent details) {
    setState(() => _isHovered = true);
    _controller.forward();
  }

  void _onHoverExit(PointerEvent details) {
    setState(() => _isHovered = false);
    _controller.reverse();
  }

  void _onPointerMove(PointerEvent details) {
    if (_isHovered) {
      setState(() {
        _pointerPosition = details.localPosition;
      });
    }
  }

  Matrix4 _calculateTransform() {
    if (!_isHovered || _animation.value == 0) return Matrix4.identity();

    // Calculate rotation angles based on pointer position relative to center
    final centerX = widget.width == double.infinity
        ? (context.size?.width ?? 0) / 2
        : widget.width / 2;
    final centerY = widget.height / 2;

    // Constrain effect limits
    final dx = (_pointerPosition.dx - centerX) / centerX;
    final dy = (_pointerPosition.dy - centerY) / centerY;

    // Use quaternions for smooth 3D/4D like rotation effect
    // We rotate around the X axis based on Y position, and Y axis based on X position
    final vector.Quaternion qX = vector.Quaternion.axisAngle(vector.Vector3(1, 0, 0), -dy * 0.1 * _animation.value);
    final vector.Quaternion qY = vector.Quaternion.axisAngle(vector.Vector3(0, 1, 0), dx * 0.1 * _animation.value);

    final vector.Quaternion q = qY * qX;

    // Scale slightly on hover
    final scale = 1.0 + (0.02 * _animation.value);

    return Matrix4.compose(
      vector.Vector3.zero(), // Translation
      q,                     // Rotation (Quaternion)
      vector.Vector3(scale, scale, scale), // Scale
    )..setEntry(3, 2, 0.001); // Perspective distortion
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onHoverEnter,
      onExit: _onHoverExit,
      onHover: _onPointerMove,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform(
              alignment: FractionalOffset.center,
              transform: _calculateTransform(),
              child: child,
            );
          },
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: AppTheme.neuSkeuomorphicBox,
            clipBehavior: Clip.antiAlias, // Ensures internal content doesn't break border on transform
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
