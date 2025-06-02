import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pothole_mobile_app/features/setting/presentation/widgets/form_edit_profile.dart';
import 'package:easy_localization/easy_localization.dart';

class EditProfileView extends ConsumerWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit-profile.title'.tr()),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: FormEditProfile(),
      ),
    );
  }
}
