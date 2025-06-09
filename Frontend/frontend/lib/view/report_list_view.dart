import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/report_list_view_model.dart';
import '../model/report_model.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class ReportListView extends ConsumerWidget {
  const ReportListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsState = ref.watch(reportListViewModelProvider);

    return Scaffold(
      body: Column(
        children: [
          // Custom app bar with blue background
          Container(
            color: const Color(0xFF4040FF),
            child: SafeArea(
              child: Container(
                height: 56, // Standard app bar height
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
                        'Report Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32), // Balance the back button
                  ],
                ),
              ),
            ),
          ),

          // Report list
          Expanded(
            child: reportsState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('Error: ${error.toString()}'),
              ),
              data: (reports) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return _buildReportCard(context, ref, report);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
      BuildContext context, WidgetRef ref, ReportModel report) {
    final viewModel = ref.read(reportListViewModelProvider.notifier);
    final reportDate = report.tanggal ?? DateTime.now();

    final bool isToday = reportDate.day == DateTime.now().day &&
        reportDate.month == DateTime.now().month &&
        reportDate.year == DateTime.now().year;

    String timeText;
    if (isToday) {
      final diff = DateTime.now().difference(reportDate);
      if (diff.inMinutes < 60) {
        timeText = '${diff.inMinutes} mins ago';
      } else {
        timeText = '${diff.inHours} hours ago';
      }
    } else {
      timeText = DateFormat('dd-MM-yyyy').format(reportDate);
    }

    return GestureDetector(
      onTap: () {
        context.push('/reportdetail/${report.id}');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE8E8E8),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.topic,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: report.status == "DONE"
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      viewModel.getAnonymizedUsernameById(report.user),
                      style: TextStyle(
                        fontSize: 14,
                        color: report.status == "DONE"
                            ? Colors.grey
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.lokasi ?? '-',
                      style: TextStyle(
                        fontSize: 16,
                        color: report.status == "DONE"
                            ? Colors.grey
                            : Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16), // Added space between content and time
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                children: [
                  Text(
                    timeText,
                    style: TextStyle(
                      fontSize: 14,
                      color: report.status == "DONE"
                          ? Colors.grey
                          : const Color(0xFF3C39F2),
                    ),
                  ),
                  if (report.status == "DONE")
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.check,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
