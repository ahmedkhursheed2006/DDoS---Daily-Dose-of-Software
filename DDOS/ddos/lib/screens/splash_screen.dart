import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // ── Fade animations ──────────────────────────────────────────────────────
  late Animation<double> _logoFade;
  late Animation<double> _taglineFade;

  // ── Slide-up (vertical offset) animations ────────────────────────────────
  late Animation<Offset> _logoSlide;
  late Animation<Offset> _taglineSlide;

  @override
  void initState() {
    super.initState();

    // Total controller duration covers the full stagger window.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );

    // ── Logo: 0 ms → 600 ms ──────────────────────────────────────────────
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.38, curve: Curves.easeOut),
      ),
    );
    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.38, curve: Curves.easeOut),
      ),
    );

    // ── "Excelerate" tagline: 400 ms → 1100 ms ───────────────────────────
    _taglineFade = Tween<double>(begin: 0.0, end: 0.65).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.21, 0.58, curve: Curves.easeOut),
      ),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.21, 0.58, curve: Curves.easeOut),
      ),
    );

    // Start the animation, then navigate after a comfortable hold.
    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Center: logo + app name ─────────────────────────────────
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  SlideTransition(
                    position: _logoSlide,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Image.asset(
                        'assets/logo.png',
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                ],
              ),
            ),

            // ── Bottom: "Excelerate" tagline ────────────────────────────
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _taglineSlide,
                child: FadeTransition(
                  opacity: _taglineFade,
                  child: Text(
                    'Excelerate',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 3,
                      color: colorScheme.onSurface,
                    ),
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
