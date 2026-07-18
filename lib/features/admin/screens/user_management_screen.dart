import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../../../models/user.dart';
import '../admin_provider.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(allUsersProvider);
        await ref.read(allUsersProvider.future);
      },
      child: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load users.\n$error')),
        data: (users) {
          if (users.isEmpty) return const Center(child: Text('No users'));
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) => _UserTile(user: users[index]),
          );
        },
      ),
    );
  }
}

class _UserTile extends ConsumerWidget {
  const _UserTile({required this.user});

  final User user;

  Future<void> _toggleBlock(WidgetRef ref, BuildContext context) async {
    try {
      if (user.isBlocked) {
        await ref.read(adminActionsProvider.notifier).unblockUser(user.id);
      } else {
        await ref.read(adminActionsProvider.notifier).blockUser(user.id);
      }
    } on DioException catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dioErrorMessage(e))));
    }
  }

  Future<void> _changeRole(WidgetRef ref, BuildContext context) async {
    final role = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final r in const ['customer', 'organizer', 'admin'])
              ListTile(title: Text(r), onTap: () => Navigator.of(context).pop(r)),
          ],
        ),
      ),
    );
    if (role == null || role == user.role) return;
    try {
      await ref.read(adminActionsProvider.notifier).updateUserRole(user.id, role);
    } on DioException catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dioErrorMessage(e))));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: CircleAvatar(child: Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : '?')),
      title: Text(user.name),
      subtitle: Text(user.email),
      onTap: () => _changeRole(ref, context),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(label: Text(user.role), visualDensity: VisualDensity.compact),
          IconButton(
            icon: Icon(user.isBlocked ? Icons.lock_open : Icons.lock_outline),
            tooltip: user.isBlocked ? 'Unblock' : 'Block',
            onPressed: () => _toggleBlock(ref, context),
          ),
        ],
      ),
    );
  }
}
