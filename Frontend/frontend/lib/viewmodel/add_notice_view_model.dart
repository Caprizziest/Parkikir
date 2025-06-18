import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/notice_model.dart'; // Import NoticeModel yang diperbarui
import '../model/parkiran_tertutup_model.dart'; // Import ParkiranTertutup yang diperbarui
import '../model/slot_parkir_model.dart'; // Import SlotParkir yang diperbarui

// Definisi kunci untuk map state
class AddNoticeViewStateKeys {
  static const String noticeId = 'noticeId';
  static const String event = 'event';
  static const String judul = 'judul';
  static const String description = 'description';
  static const String dateFrom = 'dateFrom';
  static const String dateUntil = 'dateUntil';
  static const String selectedParkingSpots =
      'selectedParkingSpots'; // List of SlotParkir objects
  static const String submissionStatus = 'submissionStatus';
}

class AddNoticeViewModel extends StateNotifier<Map<String, dynamic>> {
  AddNoticeViewModel()
      : super(
          {
            AddNoticeViewStateKeys.noticeId: null, // int? noticeId
            AddNoticeViewStateKeys.event: '',
            AddNoticeViewStateKeys.judul: '',
            AddNoticeViewStateKeys.description: '',
            AddNoticeViewStateKeys.dateFrom: DateTime.now(),
            AddNoticeViewStateKeys.dateUntil:
                DateTime.now().add(const Duration(days: 1)),
            AddNoticeViewStateKeys.selectedParkingSpots:
                <SlotParkir>[], // List of SlotParkir
            AddNoticeViewStateKeys.submissionStatus:
                const AsyncValue<void>.data(null), // Initial status
          },
        ) {
    // Inisialisasi controller dengan nilai dari state awal
    eventNameController.text = state[AddNoticeViewStateKeys.event];
    noticeTitleController.text = state[AddNoticeViewStateKeys.judul];
    descriptionController.text = state[AddNoticeViewStateKeys.description];
  }

  // TextEditingControllers untuk input form
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController noticeTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // --- Properti yang diekspos ke View (melalui getter) ---
  int? get currentNoticeId => state[AddNoticeViewStateKeys.noticeId] as int?;
  String get currentEventName => state[AddNoticeViewStateKeys.event];
  String get currentNoticeTitle => state[AddNoticeViewStateKeys.judul];
  String get currentDescription => state[AddNoticeViewStateKeys.description];
  DateTime get currentDateFrom => state[AddNoticeViewStateKeys.dateFrom];
  DateTime get currentDateUntil => state[AddNoticeViewStateKeys.dateUntil];
  List<SlotParkir> get currentSelectedParkingSpots =>
      state[AddNoticeViewStateKeys.selectedParkingSpots] as List<SlotParkir>;
  AsyncValue<void> get currentSubmissionStatus =>
      state[AddNoticeViewStateKeys.submissionStatus] as AsyncValue<void>;

  // --- Metode untuk memperbarui state dan properti form ---

  void setEventName(String event) {
    state = {...state, AddNoticeViewStateKeys.event: event};
  }

  void setNoticeTitle(String title) {
    state = {...state, AddNoticeViewStateKeys.judul: title};
  }

  void setDescription(String description) {
    state = {...state, AddNoticeViewStateKeys.description: description};
  }

  void setDateFrom(DateTime date) {
    state = {...state, AddNoticeViewStateKeys.dateFrom: date};
  }

  void setDateUntil(DateTime date) {
    state = {...state, AddNoticeViewStateKeys.dateUntil: date};
  }

  void setSelectedParkingSpots(List<SlotParkir> spots) {
    state = {...state, AddNoticeViewStateKeys.selectedParkingSpots: spots};
  }

  // --- Manajemen Formulir ---

  void resetForm() {
    eventNameController.clear();
    noticeTitleController.clear();
    descriptionController.clear();
    state = {
      AddNoticeViewStateKeys.noticeId: null,
      AddNoticeViewStateKeys.event: '',
      AddNoticeViewStateKeys.judul: '',
      AddNoticeViewStateKeys.description: '',
      AddNoticeViewStateKeys.dateFrom: DateTime.now(),
      AddNoticeViewStateKeys.dateUntil:
          DateTime.now().add(const Duration(days: 1)),
      AddNoticeViewStateKeys.selectedParkingSpots: <SlotParkir>[],
      AddNoticeViewStateKeys.submissionStatus:
          const AsyncValue<void>.data(null),
    };
  }

  Future<void> loadNoticeForEdit(int noticeId) async {
    state = {
      ...state,
      AddNoticeViewStateKeys.submissionStatus: const AsyncValue<void>.loading()
    };

    try {
      // Simulate fetching data from a repository/API using NoticeModel.fromJson
      await Future.delayed(const Duration(milliseconds: 700));

      // Contoh data JSON yang akan diterima dari API
      final Map<String, dynamic> mockNoticeJson = {
        'noticeid': noticeId,
        'tanggalfrom':
            DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        'tanggaluntil':
            DateTime.now().add(const Duration(days: 2)).toIso8601String(),
        'event': 'Rapat Tahunan',
        'judul': 'Penutupan Area Parkir Utara',
        'description':
            'Area parkir utara akan ditutup untuk rapat tahunan dan pemeliharaan rutin.',
        'parkiran_tertutup': [
          {
            'id': 1,
            'slotparkir': {'slotparkirid': 'A1', 'status': 'available'},
            'notice': noticeId
          },
          {
            'id': 2,
            'slotparkir': {'slotparkirid': 'A2', 'status': 'available'},
            'notice': noticeId
          },
          {
            'id': 3,
            'slotparkir': {'slotparkirid': 'B1', 'status': 'available'},
            'notice': noticeId
          },
        ],
      };

      final NoticeModel existingNotice = NoticeModel.fromJson(mockNoticeJson);

      // Perbarui controller dan state dengan data yang dimuat
      eventNameController.text = existingNotice.event;
      noticeTitleController.text = existingNotice.judul;
      descriptionController.text = existingNotice.description;

      state = {
        ...state,
        AddNoticeViewStateKeys.noticeId:
            existingNotice.noticeId, // Menggunakan noticeId
        AddNoticeViewStateKeys.event: existingNotice.event,
        AddNoticeViewStateKeys.judul: existingNotice.judul,
        AddNoticeViewStateKeys.description: existingNotice.description,
        AddNoticeViewStateKeys.dateFrom: existingNotice.dateFrom,
        AddNoticeViewStateKeys.dateUntil: existingNotice.dateUntil,
        AddNoticeViewStateKeys.selectedParkingSpots: existingNotice
                .parkiranTertutup
                ?.map((pt) => pt.slotparkir)
                .toList() ??
            [],
        AddNoticeViewStateKeys.submissionStatus:
            const AsyncValue<void>.data(null), // Success loading
      };
    } catch (e, st) {
      debugPrint('Error loading notice: $e \n$st');
      state = {
        ...state,
        AddNoticeViewStateKeys.submissionStatus: AsyncValue<void>.error(e, st)
      }; // Error loading
    }
  }

  Future<void> submitNotice({required bool isEditing}) async {
    state = {
      ...state,
      AddNoticeViewStateKeys.submissionStatus: const AsyncValue<void>.loading()
    };

    try {
      final String event = state[AddNoticeViewStateKeys.event];
      final String judul = state[AddNoticeViewStateKeys.judul];
      final String description = state[AddNoticeViewStateKeys.description];
      final DateTime dateFrom = state[AddNoticeViewStateKeys.dateFrom];
      final DateTime dateUntil = state[AddNoticeViewStateKeys.dateUntil];
      final List<SlotParkir> selectedSpots =
          state[AddNoticeViewStateKeys.selectedParkingSpots];

      if (isEditing) {
        final int noticeId = state[AddNoticeViewStateKeys.noticeId] as int;
        // Jika mengedit, buat NoticeModel lengkap untuk dikirimkan
        final NoticeModel noticeToUpdate = NoticeModel(
          noticeId: noticeId,
          event: event,
          judul: judul,
          description: description,
          dateFrom: dateFrom,
          dateUntil: dateUntil,
          parkiranTertutup: selectedSpots
              .map((s) =>
                  ParkiranTertutup(id: 0, slotparkir: s, noticeId: noticeId))
              .toList(), // id ParkiranTertutup dan noticeId disesuaikan jika API memerlukannya saat update
        );
        debugPrint('Notice Data to Update: ${noticeToUpdate.toJson()}');
        // TODO: Panggil API untuk update notice
        await Future.delayed(const Duration(seconds: 2));
        debugPrint('Notice with ID $noticeId updated successfully!');
      } else {
        // Jika membuat baru, gunakan NoticeCreateModel
        final NoticeCreateModel newNotice = NoticeCreateModel(
          event: event,
          judul: judul,
          description: description,
          dateFrom: dateFrom,
          dateUntil: dateUntil,
        );
        debugPrint('New Notice Data to Create: ${newNotice.toJson()}');
        // TODO: Panggil API untuk membuat notice baru
        // Anda mungkin perlu mengirimkan parkiran tertutup secara terpisah atau dalam payload yang sama
        await Future.delayed(const Duration(seconds: 2));
        debugPrint('New Notice added successfully!');
      }

      state = {
        ...state,
        AddNoticeViewStateKeys.submissionStatus:
            const AsyncValue<void>.data(null)
      }; // Success submitting
      resetForm(); // Clear form after successful submission
    } catch (e, st) {
      debugPrint('Error submitting notice: $e \n$st');
      state = {
        ...state,
        AddNoticeViewStateKeys.submissionStatus: AsyncValue<void>.error(e, st)
      }; // Error submitting
    }
  }

  // --- Pengambilan Data Slot Parkir ---

  // Simulasikan pengambilan semua slot parkir (ganti dengan panggilan API aktual)
  Future<List<SlotParkir>> fetchAllParkingSlots() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      SlotParkir(slotparkirid: 'A1', status: 'available'),
      SlotParkir(
          slotparkirid: 'A2', status: 'occupied'), // Contoh status occupied
      SlotParkir(slotparkirid: 'A3', status: 'available'),
      SlotParkir(slotparkirid: 'A4', status: 'available'),
      SlotParkir(slotparkirid: 'A5', status: 'available'),
      SlotParkir(slotparkirid: 'A6', status: 'available'),
      SlotParkir(slotparkirid: 'A7', status: 'available'),
      SlotParkir(slotparkirid: 'B1', status: 'available'),
      SlotParkir(slotparkirid: 'B2', status: 'available'),
      SlotParkir(slotparkirid: 'B3', status: 'available'),
      SlotParkir(slotparkirid: 'B4', status: 'available'),
      SlotParkir(slotparkirid: 'B5', status: 'available'),
      SlotParkir(slotparkirid: 'B6', status: 'available'),
      SlotParkir(slotparkirid: 'B7', status: 'available'),
      SlotParkir(slotparkirid: 'B8', status: 'available'),
      SlotParkir(slotparkirid: 'C1', status: 'available'),
      SlotParkir(slotparkirid: 'C2', status: 'available'),
      SlotParkir(slotparkirid: 'C3', status: 'occupied'),
      SlotParkir(slotparkirid: 'C4', status: 'available'),
      SlotParkir(slotparkirid: 'C5', status: 'available'),
      SlotParkir(slotparkirid: 'C6', status: 'available'),
      SlotParkir(slotparkirid: 'C7', status: 'available'),
      SlotParkir(slotparkirid: 'C8', status: 'available'),
      SlotParkir(slotparkirid: 'C9', status: 'available'),
      SlotParkir(slotparkirid: 'D1', status: 'occupied'),
      SlotParkir(slotparkirid: 'D2', status: 'available'),
      SlotParkir(slotparkirid: 'D3', status: 'available'),
      SlotParkir(slotparkirid: 'D4', status: 'available'),
      SlotParkir(slotparkirid: 'D5', status: 'occupied'),
      SlotParkir(slotparkirid: 'D6', status: 'available'),
      SlotParkir(slotparkirid: 'D7', status: 'available'),
      SlotParkir(slotparkirid: 'D8', status: 'available'),
      SlotParkir(slotparkirid: 'D9', status: 'available'),
      SlotParkir(slotparkirid: 'D10', status: 'available'),
      SlotParkir(slotparkirid: 'D11', status: 'available'),
      SlotParkir(slotparkirid: 'D12', status: 'available'),
      SlotParkir(slotparkirid: 'D13', status: 'available'),
      SlotParkir(slotparkirid: 'E1', status: 'available'),
      SlotParkir(slotparkirid: 'E2', status: 'available'),
      SlotParkir(slotparkirid: 'E3', status: 'available'),
      SlotParkir(slotparkirid: 'E4', status: 'occupied'),
      SlotParkir(slotparkirid: 'E5', status: 'available'),
      SlotParkir(slotparkirid: 'E6', status: 'available'),
      SlotParkir(slotparkirid: 'E7', status: 'available'),
      SlotParkir(slotparkirid: 'E8', status: 'available'),
      SlotParkir(slotparkirid: 'E9', status: 'available'),
      SlotParkir(slotparkirid: 'E10', status: 'available'),
      SlotParkir(slotparkirid: 'E11', status: 'available'),
      SlotParkir(slotparkirid: 'E12', status: 'occupied'),
      SlotParkir(slotparkirid: 'E13', status: 'available'),
      SlotParkir(slotparkirid: 'E14', status: 'available'),
      SlotParkir(slotparkirid: 'F1', status: 'available'),
      SlotParkir(slotparkirid: 'F2', status: 'available'),
      SlotParkir(slotparkirid: 'F3', status: 'available'),
      SlotParkir(slotparkirid: 'F4', status: 'available'),
      SlotParkir(slotparkirid: 'F5', status: 'occupied'),
      SlotParkir(slotparkirid: 'F6', status: 'available'),
      SlotParkir(slotparkirid: 'F7', status: 'available'),
      SlotParkir(slotparkirid: 'F8', status: 'available'),
      SlotParkir(slotparkirid: 'F9', status: 'available'),
      SlotParkir(slotparkirid: 'F10', status: 'available'),
      SlotParkir(slotparkirid: 'F11', status: 'occupied'),
      SlotParkir(slotparkirid: 'F12', status: 'available'),
      SlotParkir(slotparkirid: 'G1', status: 'occupied'),
      SlotParkir(slotparkirid: 'G2', status: 'available'),
      SlotParkir(slotparkirid: 'G3', status: 'available'),
      SlotParkir(slotparkirid: 'H1', status: 'available'),
      SlotParkir(slotparkirid: 'H2', status: 'available'),
      SlotParkir(slotparkirid: 'H3', status: 'occupied'),
      SlotParkir(slotparkirid: 'H4', status: 'available'),
      SlotParkir(slotparkirid: 'H5', status: 'available'),
      SlotParkir(slotparkirid: 'H6', status: 'available'),
      SlotParkir(slotparkirid: 'H7', status: 'available'),
      SlotParkir(slotparkirid: 'H8', status: 'available'),
      SlotParkir(slotparkirid: 'H9', status: 'occupied'),
      SlotParkir(slotparkirid: 'H10', status: 'available'),
      SlotParkir(slotparkirid: 'H11', status: 'available'),
      SlotParkir(slotparkirid: 'H12', status: 'available'),
      SlotParkir(slotparkirid: 'H13', status: 'available'),
      SlotParkir(slotparkirid: 'H14', status: 'occupied'),
      SlotParkir(slotparkirid: 'H15', status: 'available'),
      SlotParkir(slotparkirid: 'H16', status: 'available'),
      SlotParkir(slotparkirid: 'H17', status: 'available'),
      SlotParkir(slotparkirid: 'H18', status: 'occupied'),
    ];
  }

  @override
  void dispose() {
    eventNameController.dispose();
    noticeTitleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

// Provider utama untuk AddNoticeViewModel
final addNoticeViewModelProvider =
    StateNotifierProvider<AddNoticeViewModel, Map<String, dynamic>>((ref) {
  return AddNoticeViewModel();
});

// Provider untuk semua slot parkir
final allParkingSlotsProvider = FutureProvider<List<SlotParkir>>((ref) async {
  return ref.read(addNoticeViewModelProvider.notifier).fetchAllParkingSlots();
});
