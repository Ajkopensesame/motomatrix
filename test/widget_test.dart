import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motomatrix/screens/login_screen.dart';
import 'package:motomatrix/screens/splash_screen.dart'; // Import the main app file

void main() {
  testWidgets('Test SplashScreen', (WidgetTester tester) async {
    // Wrap the widget with the ProviderScope for testing
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: SplashScreen(), // Use SplashScreen as the home widget
        ),
      ),
    );

    // Verify that the SplashScreen content is correctly displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget); // Loading indicator should be visible

    // Simulate a successful authentication
    await tester.pump(Duration.zero); // Advance time for future task
    await tester.pump(); // Rebuild the widget

    // Verify that the SplashScreen navigates to the DashboardScreen after authentication
    expect(find.byType(CircularProgressIndicator), findsNothing); // Loading indicator should be gone
    expect(find.byType(LoginScreen), findsOneWidget); // LoginScreen should be visible

    // Simulate authentication error
    // You can use something like 'await tester.pumpAndSettle()' to wait for async operations to complete
    // Then update the currentUserProvider to emit an error state for testing the error case

    // Verify that the error message is displayed
    expect(find.text("Error: your_error_message_here"), findsOneWidget);
  });
}
