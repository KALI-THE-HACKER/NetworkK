import json
from django.core.management.base import BaseCommand
from server.models import Startup

class Command(BaseCommand):
    help = 'Load startup data from JSON file'

    def handle(self, *args, **kwargs):
        with open(r'C:\Users\aryan\OneDrive\Desktop\Aryan\django\NetworK\NetworkK\st.json', 'r') as file:
            data = json.load(file)
            for item in data:
                Startup.objects.create(
                    name=item['name'],
                    desc=item['desc'],
                    founder=item['founder'],
                    contact=item['contact']
                )
        self.stdout.write(self.style.SUCCESS('Successfully loaded startup data'))