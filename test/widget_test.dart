import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/features/auth/presentation/screens/login_screen.dart';
import 'package:movie_app/main.dart';

void main() {
  testWidgets('Movie App smoke test - verifies LoginScreen renders', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that LoginScreen and Movie branding elements are rendered
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
