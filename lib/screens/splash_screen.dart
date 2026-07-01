import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Implementing custom high-contrast neon variables using your palette colors
    const Color neonYellow = AppColors.neonYellow; // #FCF259
    const Color neonPink = AppColors.neonPink;     // #C5172E

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              neonPink.withOpacity(0.18), // Shifting background glow to deep crimson/pink accent
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Center Branding Section
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // High-Contrast Glowing Cyber-Icon Ring
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: neonYellow,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: neonYellow.withOpacity(0.35),
                                blurRadius: 30,
                                spreadRadius: 3,
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.style_rounded,
                            size: 75,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // App Title with Cyberpunk Multi-Shadow Glow
                        const Text(
                          'LearnMate',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 5.0,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: neonYellow,
                                blurRadius: 20,
                              ),
                              Shadow(
                                color: neonPink,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle Tracker Text
                        const Text(
                          '⚡ SMART CYPHER LEARNING ⚡',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3.0,
                            color: neonYellow,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Action Section - Premium Neon Yellow Filled Button
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: neonYellow.withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: neonYellow, // Filled neon yellow color hunt asset
                        foregroundColor: Colors.black, // High contrast text readability
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.white, width: 1.0),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'START', // Clean, minimalist label update
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 4.0,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.keyboard_arrow_right_rounded, size: 24, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}