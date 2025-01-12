import json
from django.core.management.base import BaseCommand
from server.models import Openings, Startup

class Command(BaseCommand):
    help = 'Load openings data from JSON file'

    def handle(self):
        with open(r'C:\Users\aryan\OneDrive\Desktop\Aryan\django\NetworK\NetworkK\obj.json', 'r') as file:
            data = json.load(file)
            for item in data:
                startup = Startup.objects.get(id=item['startup'])
                Openings.objects.create(
                    position=item['position'],
                    pos_desc=item['pos_desc'],
                    categories=item['categories'],
                    startup=startup
                )
        self.stdout.write(self.style.SUCCESS('Successfully loaded openings data'))