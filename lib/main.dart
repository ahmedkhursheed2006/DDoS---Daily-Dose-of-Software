import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
<<<<<<< HEAD
import 'features/shell/bottom_nav_shell.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'services/dio_client.dart';
=======
import 'models/post.dart';
import 'screens/post_detail_screen.dart';
>>>>>>> ff64cb8818d57bcf3925d0d1f919940adac91bd6

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DDoSApp());
}

class DDoSApp extends StatelessWidget {
  const DDoSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'DDoS',
      navigatorKey: DioClient.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const BottomNavShell(initialIndex: 0),
        '/explore': (context) => const BottomNavShell(initialIndex: 1),
        '/daily-dose': (context) => const BottomNavShell(initialIndex: 2),
        '/progress': (context) => const BottomNavShell(initialIndex: 3),
        '/profile': (context) => const BottomNavShell(initialIndex: 4),
      },
=======
      title: 'DDoS - Daily Dose of Software',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: PostDetailScreen(
        post: Post(
          id: 'p101',
          seriesId: 's_systems_arch',
          seriesTitle: 'Software Architecture & Systems',
          title: 'The Magic of Pointers & Memory Architecture',
          bodyText:
              'Pointers unlock the fundamental memory management concept that separates great software architects from standard developers.\n\n'
              'At their core, pointers are variables that store physical memory addresses rather than direct values. When you allocate objects dynamically on the heap, passing pointer references across function boundaries avoids deep cloning, eliminating expensive garbage collection overhead and CPU cache misses.\n\n'
              'In high-throughput distributed engines, zero-copy network serialization relies heavily on raw byte pointer offsets.',
          keyTakeaway: 'Pointers enable zero-copy data manipulation and direct heap addressing without memory duplication.',
          codeLanguage: 'cpp',
          codeSnippet: '''#include <iostream>

struct Packet {
    int id;
    double payload[1024]; // 8 KB buffer
};

// Zero-copy pointer reference
void processZeroCopy(const Packet* pkt) {
    std::cout << "Processing packet ID: " << pkt->id << " at address: " << pkt << std::endl;
}

int main() {
    Packet* liveBuffer = new Packet{42, {0.0}};
    processZeroCopy(liveBuffer); // Passes 8-byte pointer instead of 8 KB copy
    delete liveBuffer;
    return 0;
}''',
          quiz: QuizQuestion(
            question: "What is the primary architectural benefit of passing pointers instead of full objects?",
            options: [
              QuizOption(
                text: "Eliminates deep copying and excessive memory allocation overhead",
                isCorrect: true,
                explanation: "Passing an 8-byte address avoids duplicating large heap buffers, minimizing cache pressure and GC pauses.",
              ),
              QuizOption(
                text: "Automatically encrypts runtime variables in volatile RAM",
                isCorrect: false,
                explanation: "Pointers do not provide encryption; they are raw memory address references.",
              ),
              QuizOption(
                text: "Restricts all memory operations exclusively to stack frames",
                isCorrect: false,
                explanation: "Pointers frequently reference dynamic heap allocations across stack boundaries.",
              ),
            ],
          ),
          imageUrl: '',
          sourceReference: 'Computer Systems: A Programmer\'s Perspective (Randal E. Bryant & David R. O\'Hallaron)',
          positionInSeries: 1,
          totalSeriesSteps: 5,
          estReadMinutes: 5,
          audioDuration: '4 min 30 sec',
          publishedAt: DateTime.now(),
          likeCount: 142,
          commentCount: 2,
        ),
      ),
>>>>>>> ff64cb8818d57bcf3925d0d1f919940adac91bd6
    );
  }
}