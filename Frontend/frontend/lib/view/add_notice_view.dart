import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../viewmodel/add_notice_view_model.dart';
import 'select_parking_spot_dialog.dart';
import '../model/slot_parkir_model.dart'; // Tetap diperlukan untuk dialog

class AddNoticeView extends ConsumerStatefulWidget {
  final int? noticeId;

  const AddNoticeView({super.key, this.noticeId});

  @override
  ConsumerState<AddNoticeView> createState() => _AddNoticeViewState();
}

class _AddNoticeViewState extends ConsumerState<AddNoticeView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.read(addNoticeViewModelProvider.notifier);
      if (widget.noticeId != null) {
        viewModel.loadNoticeForEdit(widget.noticeId!);
      } else {
        viewModel.resetForm();
      }
    });
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final viewModel = ref.read(addNoticeViewModelProvider.notifier);
    final DateTime initialDate =
        isFromDate ? viewModel.currentDateFrom : viewModel.currentDateUntil;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isFromDate) {
        viewModel.setDateFrom(picked);
        // Ensure until date is not before from date
        if (viewModel.currentDateUntil.isBefore(picked)) {
          viewModel.setDateUntil(picked);
        }
      } else {
        if (picked.isBefore(viewModel.currentDateFrom)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Tanggal "Until" tidak boleh sebelum tanggal "From".')),
            );
          }
        } else {
          viewModel.setDateUntil(picked);
        }
      }
    }
  }

  void _showSelectParkingSpotDialog() async {
    final viewModel = ref.read(addNoticeViewModelProvider.notifier);
    final allParkingSlotsAsync = ref.watch(allParkingSlotsProvider);

    allParkingSlotsAsync.when(
      data: (allParkingSlots) async {
        final List<SlotParkir>? selectedSpots =
            await showDialog<List<SlotParkir>>(
          context: context,
          builder: (BuildContext context) {
            return SelectParkingSpotDialog(
              allParkingSlots: allParkingSlots,
              initialSelectedSpots:
                  List.from(viewModel.currentSelectedParkingSpots),
            );
          },
        );

        if (selectedSpots != null) {
          viewModel.setSelectedParkingSpots(selectedSpots);
        }
      },
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Memuat slot parkir...')),
        );
      },
      error: (e, st) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error memuat slot parkir: $e')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Read the ViewModel notifier to call methods
    final viewModel = ref.read(addNoticeViewModelProvider.notifier);
    // Watch the ViewModel's state to rebuild UI on changes
    final Map<String, dynamic> viewState =
        ref.watch(addNoticeViewModelProvider);

    // Dapatkan status pengiriman dari state yang diobservasi
    final AsyncValue<void> submissionStatus =
        viewState[AddNoticeViewStateKeys.submissionStatus];

    // Listen for changes in submission status
    ref.listen<AsyncValue<void>>(
      addNoticeViewModelProvider.select((state) =>
          state[AddNoticeViewStateKeys.submissionStatus] as AsyncValue<void>),
      (_, status) {
        status.whenOrNull(
          data: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notice submitted successfully!')),
            );
            // Kembali ke halaman sebelumnya jika ini bukan mode edit atau jika itu mode edit dan sukses
            if (widget.noticeId == null || Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          error: (e, st) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${e.toString()}')),
            );
          },
          loading: () {
            // Opsional: tampilkan indikator loading global jika diperlukan
          },
        );
      },
    );

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color(0xFF4338CA),
            child: SafeArea(
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.noticeId == null ? 'Add Notice' : 'Edit Notice',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: viewModel.eventNameController,
                      label: 'Event name',
                      onChanged: viewModel.setEventName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Event name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: viewModel.noticeTitleController,
                      label: 'Notice title',
                      onChanged: viewModel.setNoticeTitle,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Notice title cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            context,
                            label: 'From',
                            date: viewModel.currentDateFrom,
                            onTap: () => _selectDate(context, true),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDateField(
                            context,
                            label: 'Until',
                            date: viewModel.currentDateUntil,
                            onTap: () => _selectDate(context, false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDescriptionField(
                      controller: viewModel.descriptionController,
                      onChanged: viewModel.setDescription,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Modified Select Spot to Close section
                    GestureDetector(
                      onTap: _showSelectParkingSpotDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Spot to Close',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                size: 20, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    // Display selected parking spots as tags
                    if (viewModel.currentSelectedParkingSpots.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Wrap(
                          spacing: 8.0, // Gap between adjacent chips
                          runSpacing: 4.0, // Gap between lines
                          children: viewModel.currentSelectedParkingSpots
                              .map((spot) => Chip(
                                    label: Text(spot.slotparkirid),
                                    backgroundColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    labelStyle: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: submissionStatus.isLoading
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  viewModel.submitNotice(
                                      isEditing: widget.noticeId != null);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4338CA),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: submissionStatus.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                widget.noticeId == null
                                    ? 'Submit'
                                    : 'Save Changes',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
    int? maxLength,
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            maxLength: maxLength,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: label,
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              counterText: '',
            ),
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(date),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField({
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            maxLength: 200,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Description',
              contentPadding: EdgeInsets.all(16),
              border: InputBorder.none,
              counterText: '',
            ),
            onChanged: onChanged,
            validator: validator,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${controller.text.length}/200',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
