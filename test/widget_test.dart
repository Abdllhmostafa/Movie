import 'package:e_commerce_app/features/auth/presentation/screens/login_screen.dart';
import 'package:e_commerce_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test - verifies LoginScreen renders', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that LoginScreen and key elements are rendered
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('ROUTE'), findsOneWidget);
    expect(find.text('Welcome Back To Route'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
