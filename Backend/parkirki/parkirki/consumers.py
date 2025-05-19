from channels.generic.websocket import AsyncWebsocketConsumer
from channels.layers import get_channel_layer
from asgiref.sync import sync_to_async
import json

@sync_to_async
def get_all_slotparkir():
    # Import ditunda
    from App.models import SlotParkir
    return list(SlotParkir.objects.values())

class ParkingConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.channel_layer.group_add("slotparkir_group", self.channel_name)
        await self.accept()

        data = await get_all_slotparkir()
        await self.send(text_data=json.dumps({
            "type": "all_slotparkir",
            "data": data
        }))

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard("slotparkir_group", self.channel_name)

    async def slotparkir_update(self, event):
        # Event dari group_send
        await self.send(text_data=json.dumps({
            "type": "all_slotparkir",
            "data": event["data"]
        }))
