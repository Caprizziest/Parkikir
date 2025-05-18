from django.core.management.base import BaseCommand
from App.models import SlotParkir

class Command(BaseCommand):
    help = 'Seed SlotParkir data (A1-A7, B1-B8, ..., H1-H18)'

    def handle(self, *args, **kwargs):
        slot_ranges = {
            'A': 7,
            'B': 8,
            'C': 9,
            'D': 13,
            'E': 14,
            'F': 12,
            'G': 3,
            'H': 18,
        }

        total_created = 0
        for prefix, count in slot_ranges.items():
            for i in range(1, count + 1):
                nama_slot = f"{prefix}{i}"
                obj, created = SlotParkir.objects.update_or_create(
                    slotparkirid=nama_slot,
                    defaults={'status': 'AVAILABLE'}
                )
                if created:
                    total_created += 1
                    self.stdout.write(self.style.SUCCESS(f"Created slot {nama_slot}"))
                else:
                    self.stdout.write(f"Updated slot {nama_slot}")

        self.stdout.write(self.style.SUCCESS(f"✅ Seeder complete. Total created: {total_created}"))