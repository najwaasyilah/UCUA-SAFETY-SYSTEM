import 'package:flutter/material.dart';
import 'package:ucua_user_profile/models/user_profile.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfile _userProfile = UserProfile(
    name: 'Najwa',
    email: 'john.doe@example.com',
    department: 'Safety Department',
  );

  UserProfile get userProfile => _userProfile;

  void updateProfile(UserProfile newProfile) {
    _userProfile = newProfile;
    notifyListeners();
  }

  void changePassword(String newPassword) {
    //  password
    notifyListeners();
  }
}
