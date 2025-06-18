import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/notice_list_view_model.dart'; // Import the new viewmodel
import 'package:go_router/go_router.dart';
import '../model/notice_model.dart';
import '../viewmodel/user_view_model.dart'; // Import UserViewModel

class NoticeListView extends ConsumerWidget {
  const NoticeListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state from NoticeListViewModel
    final noticesState = ref.watch(noticeListViewModelProvider);
    // Read the notifier for methods that change state or perform actions
    final noticeListViewModel = ref.read(noticeListViewModelProvider.notifier);
    final userState = ref.watch(userViewModelProvider); // Watch UserViewModel

    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: noticesState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => _buildErrorWidget(
                  context, error, noticeListViewModel), // Pass context
              data: (notices) => _buildNoticeList(
                  context, notices, noticeListViewModel), // Pass context
            ),
          ),
        ],
      ),
      floatingActionButton: userState.user?.isStaff == true
          ? FloatingActionButton(
              onPressed: () {
                context.go('/addnotice'); // Navigate directly from view
              },
              backgroundColor: const Color(0xFF4040FF),
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            )
          : null,
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: const Color(0xFF4040FF),
      child: SafeArea(
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const Expanded(
                child: Text(
                  'Notice List',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(width: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(
      BuildContext context, Object error, NoticeListViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: ${error.toString()}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => viewModel.refreshNotices(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeList(
    BuildContext context,
    List<NoticeModel> notices,
    NoticeListViewModel viewModel,
  ) {
    if (viewModel.shouldShowEmptyState()) {
      // Using viewModel's helper
      return const Center(
        child: Text(
          'No notices available',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.handleRefresh(), // Call viewModel method
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notices.length,
        itemBuilder: (context, index) {
          final notice = notices[index];
          return _buildNoticeCard(context, notice, viewModel);
        },
      ),
    );
  }

  Widget _buildNoticeCard(
      BuildContext context, NoticeModel notice, NoticeListViewModel viewModel) {
    return GestureDetector(
      onTap: () => viewModel.navigateToNoticeDetail(context, notice.noticeId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE8E8E8),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4040FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.campaign,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.formatNoticeDateRange(notice),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      viewModel.formatNoticeDescription(notice.description),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
