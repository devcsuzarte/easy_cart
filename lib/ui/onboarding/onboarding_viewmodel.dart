import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class OnboardingViewmodel extends FutureViewModel {

	ReactiveValue<int> selectedBudget = ReactiveValue(300);
	ReactiveValue<bool> notify80      = ReactiveValue(true);

	@override
	Future futureToRun() async {
		await _loadPrefs();
	}

	Future<void> _loadPrefs() async {
		final prefs = await SharedPreferences.getInstance();
		selectedBudget.value = prefs.getInt('budget') ?? 300;
		notify80.value       = prefs.getBool('notify80') ?? true;
		notifyListeners();
	}

	void selectBudget(int value) {
		selectedBudget.value = value;
		notifyListeners();
	}

	void toggleNotify80(bool val) {
		notify80.value = val;
		notifyListeners();
	}

	Future<void> completeOnboarding() async {
		final prefs = await SharedPreferences.getInstance();
		await prefs.setBool('onboarding_done', true);
		await prefs.setInt('budget', selectedBudget.value);
		await prefs.setBool('notify80', notify80.value);
	}
}
