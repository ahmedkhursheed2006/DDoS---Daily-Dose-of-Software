import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../../utils/avatar_helper.dart';


class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  User? _currentUser;
  bool _pushNotifications = true;
  bool _isLoadingUser = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    AuthService.userNotifier.addListener(_onUserUpdated);
  }

  void _onUserUpdated() {
    if (mounted) {
      setState(() {
        _currentUser = AuthService.userNotifier.value;
      });
    }
  }

  @override
  void dispose() {
    AuthService.userNotifier.removeListener(_onUserUpdated);
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = await AuthService.getUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
        _isLoadingUser = false;
      });
    }
  }

  Future<void> _pickAvatarFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null && mounted) {
        final user = _currentUser ?? const User(id: '', name: '', email: '');
        final updatedUser = user.copyWith(avatarPath: pickedFile.path);

        await AuthService.saveUser(updatedUser);
        if (mounted) {
          setState(() {
            _currentUser = updatedUser;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Avatar updated from gallery!'),
              backgroundColor: AppConstants.primaryColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('[AccountSettings] Error picking avatar from gallery: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open gallery: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _pickAvatarFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null && mounted) {
        final user = _currentUser ?? const User(id: '', name: '', email: '');
        final updatedUser = user.copyWith(avatarPath: pickedFile.path);

        await AuthService.saveUser(updatedUser);
        if (mounted) {
          setState(() {
            _currentUser = updatedUser;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo avatar updated!'),
              backgroundColor: AppConstants.primaryColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('[AccountSettings] Error taking photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open camera: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showPresetAvatarPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppConstants.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  'Pick a Default Avatar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryText,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Choose one of our curated developer avatars',
                  style: TextStyle(fontSize: 13, color: AppConstants.secondaryText),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: AvatarHelper.defaultAvatars.length,
                  itemBuilder: (_, index) {
                    final preset = AvatarHelper.defaultAvatars[index];
                    final isSelected = _currentUser?.avatarPath == preset.id;

                    return GestureDetector(
                      onTap: () async {
                        Navigator.pop(ctx);
                        final user = _currentUser ?? const User(id: '', name: '', email: '');
                        final updatedUser = user.copyWith(avatarPath: preset.id);
                        await AuthService.saveUser(updatedUser);
                        if (mounted) {
                          setState(() {
                            _currentUser = updatedUser;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Avatar changed to ${preset.label}!'),
                              backgroundColor: AppConstants.primaryColor,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppConstants.primaryColor : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: preset.gradientColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: preset.primaryColor.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  preset.emoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            preset.label,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? AppConstants.primaryThemeColor : AppConstants.primaryText,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _randomizeDefaultAvatar() async {
    final user = _currentUser ?? const User(id: '', name: '', email: '');
    final newDefault = AvatarHelper.getRandomDefaultAvatarId();
    final updatedUser = user.copyWith(avatarPath: newDefault);
    await AuthService.saveUser(updatedUser);
    if (mounted) {
      setState(() {
        _currentUser = updatedUser;
      });
      final preset = AvatarHelper.getPreset(newDefault);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Avatar randomized to ${preset?.label ?? 'New Avatar'}!'),
          backgroundColor: AppConstants.primaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showAvatarOptionsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  'Change Profile Avatar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryText,
                  ),
                ),
                const SizedBox(height: 16),

                // Option 1: Pick a Default Preset Avatar
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.face_retouching_natural, color: AppConstants.primaryColor),
                  ),
                  title: const Text(
                    'Pick a Default Avatar',
                    style: TextStyle(fontWeight: FontWeight.w600, color: AppConstants.primaryText),
                  ),
                  subtitle: const Text(
                    'Choose from 8 curated developer avatars',
                    style: TextStyle(fontSize: 12, color: AppConstants.secondaryText),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showPresetAvatarPicker();
                  },
                ),
                const Divider(height: 1, indent: 64),

                // Option 2: Choose from Gallery
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BCD4).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.photo_library_outlined, color: Color(0xFF0097A7)),
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(fontWeight: FontWeight.w600, color: AppConstants.primaryText),
                  ),
                  subtitle: const Text(
                    'Select a picture from your device gallery',
                    style: TextStyle(fontSize: 12, color: AppConstants.secondaryText),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickAvatarFromGallery();
                  },
                ),
                const Divider(height: 1, indent: 64),

                // Option 3: Take Photo
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_outlined, color: Color(0xFF388E3C)),
                  ),
                  title: const Text(
                    'Take Photo',
                    style: TextStyle(fontWeight: FontWeight.w600, color: AppConstants.primaryText),
                  ),
                  subtitle: const Text(
                    'Use your camera to snap a new photo',
                    style: TextStyle(fontSize: 12, color: AppConstants.secondaryText),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickAvatarFromCamera();
                  },
                ),
                const Divider(height: 1, indent: 64),

                // Option 4: Randomize
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.casino_outlined, color: Color(0xFFF57C00)),
                  ),
                  title: const Text(
                    'Randomize Default Avatar',
                    style: TextStyle(fontWeight: FontWeight.w600, color: AppConstants.primaryText),
                  ),
                  subtitle: const Text(
                    'Assign a random default avatar',
                    style: TextStyle(fontSize: 12, color: AppConstants.secondaryText),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _randomizeDefaultAvatar();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _currentUser?.name ?? '');
    final formKey = GlobalKey<FormState>();
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppConstants.cardSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryText,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.secondaryText,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(color: AppConstants.primaryText),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    prefixIcon: const Icon(Icons.person_outline, color: AppConstants.secondaryColor),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                ),
                if (_currentUser != null && _currentUser!.email.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Email: ${_currentUser!.email}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppConstants.secondaryText,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: AppConstants.secondaryColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newName = nameController.text.trim();
                  final user = _currentUser ??
                      const User(
                        id: '',
                        name: '',
                        email: '',
                      );
                  final updatedUser = user.copyWith(name: newName);

                  await AuthService.saveUser(updatedUser);
                  if (mounted) {
                    setState(() {
                      _currentUser = updatedUser;
                    });
                  }
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully.'),
                      backgroundColor: AppConstants.primaryColor,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppConstants.cardSurface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text(
                'Change Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryText,
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: currentPasswordController,
                        obscureText: obscureCurrent,
                        decoration: InputDecoration(
                          hintText: 'Current Password',
                          prefixIcon: const Icon(Icons.lock_outline, color: AppConstants.secondaryColor),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureCurrent ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: AppConstants.secondaryColor,
                            ),
                            onPressed: () => setDialogState(() => obscureCurrent = !obscureCurrent),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Enter current password' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: newPasswordController,
                        obscureText: obscureNew,
                        decoration: InputDecoration(
                          hintText: 'New Password',
                          prefixIcon: const Icon(Icons.lock_reset, color: AppConstants.secondaryColor),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureNew ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: AppConstants.secondaryColor,
                            ),
                            onPressed: () => setDialogState(() => obscureNew = !obscureNew),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter new password';
                          if (v.length < 8) return 'Minimum 8 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: obscureConfirm,
                        decoration: InputDecoration(
                          hintText: 'Confirm New Password',
                          prefixIcon: const Icon(Icons.lock_reset, color: AppConstants.secondaryColor),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: AppConstants.secondaryColor,
                            ),
                            onPressed: () => setDialogState(() => obscureConfirm = !obscureConfirm),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        validator: (v) {
                          if (v != newPasswordController.text) return 'Passwords do not match';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel', style: TextStyle(color: AppConstants.secondaryColor)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password update feature will be available soon.'),
                          backgroundColor: AppConstants.primaryColor,
                        ),
                      );
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = (_currentUser?.name.isNotEmpty == true)
        ? _currentUser!.name
        : ((_currentUser?.email.isNotEmpty == true)
            ? _currentUser!.email.split('@')[0]
            : 'Learner');

    return Scaffold(
      backgroundColor: AppConstants.backgroundCanvas,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundCanvas,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.primaryThemeColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account Settings',
          style: TextStyle(
            color: AppConstants.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _isLoadingUser
          ? const Center(
              child: CircularProgressIndicator(color: AppConstants.primaryColor),
            )
          : ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                // Avatar & Profile Header Card
                Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.only(bottom: 20.0),
                  decoration: BoxDecoration(
                    color: AppConstants.cardSurface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppConstants.primaryThemeColor,
                                  Color(0xFFDBC2B0),
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                            child: AvatarHelper.buildAvatar(
                              avatarPath: _currentUser?.avatarPath,
                              name: userName,
                              radius: 46,
                            ),
                          ),
                          GestureDetector(
                            onTap: _showAvatarOptionsModal,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppConstants.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentUser?.email ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppConstants.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _showAvatarOptionsModal,
                        icon: const Icon(Icons.photo_library_outlined, size: 16),
                        label: const Text('Change Avatar', style: TextStyle(fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppConstants.primaryThemeColor,
                          side: const BorderSide(color: AppConstants.primaryThemeColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Settings Section Card
                Container(
                  decoration: BoxDecoration(
                    color: AppConstants.cardSurface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 1. Edit Profile Tile
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: AppConstants.primaryColor,
                          ),
                        ),
                        title: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppConstants.primaryText,
                          ),
                        ),
                        subtitle: Text(
                          _currentUser?.name != null && _currentUser!.name.isNotEmpty
                              ? 'Name: ${_currentUser!.name}'
                              : 'Update your name and profile information',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppConstants.secondaryText,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: AppConstants.secondaryColor,
                        ),
                        onTap: _showEditProfileDialog,
                      ),
                      const Divider(height: 1, indent: 64, endIndent: 20),

                      // 2. Change Avatar Tile
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Color(0xFF388E3C),
                          ),
                        ),
                        title: const Text(
                          'Change Avatar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppConstants.primaryText,
                          ),
                        ),
                        subtitle: const Text(
                          'Choose preset, gallery photo, or take a picture',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppConstants.secondaryText,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: AppConstants.secondaryColor,
                        ),
                        onTap: _showAvatarOptionsModal,
                      ),
                      const Divider(height: 1, indent: 64, endIndent: 20),

                      // 3. Change Password Tile
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00BCD4).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF0097A7),
                          ),
                        ),
                        title: const Text(
                          'Change Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppConstants.primaryText,
                          ),
                        ),
                        subtitle: const Text(
                          'Update your account password',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppConstants.secondaryText,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: AppConstants.secondaryColor,
                        ),
                        onTap: _showChangePasswordDialog,
                      ),
                      const Divider(height: 1, indent: 64, endIndent: 20),

                      // 4. Notifications Tile
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Color(0xFFF57C00),
                          ),
                        ),
                        title: const Text(
                          'Push Notifications',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppConstants.primaryText,
                          ),
                        ),
                        subtitle: const Text(
                          'Receive daily dose reminders',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppConstants.secondaryText,
                          ),
                        ),
                        trailing: Switch(
                          value: _pushNotifications,
                          activeThumbColor: AppConstants.primaryColor,
                          activeTrackColor: AppConstants.primaryColor.withValues(alpha: 0.4),
                          onChanged: (val) {
                            setState(() {
                              _pushNotifications = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
