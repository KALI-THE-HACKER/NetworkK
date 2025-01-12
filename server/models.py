from django.db import models
from django.contrib.auth.models import User
from rest_framework import serializers

class Startup(models.Model):
    name = models.CharField(max_length=50, blank=False, null=False)
    desc = models.CharField(max_length=300)
    founder = models.CharField(max_length=50, null=True, blank=True)
    contact = models.URLField(max_length=200, blank=True, null=True)

class Opening(models.Model):
    position = models.CharField(max_length=50, blank=False, null=False)
    pos_desc = models.CharField(max_length=150, blank=True, null=True)
    categories = models.JSONField(blank=True, null=True)
    startup = models.ForeignKey(Startup, related_name='openings', on_delete=models.CASCADE, default=1)

class Application(models.Model):
    student = models.ForeignKey(User, on_delete=models.CASCADE)
    opening = models.ForeignKey(Opening, on_delete=models.CASCADE)
    applied_at = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=20, choices=[('Pending', 'Pending'), ('Accepted', 'Accepted'), ('Rejected', 'Rejected')], default='Pending')

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username']

class StartupSerializer(serializers.ModelSerializer):
    class Meta:
        model = Startup
        fields = ['name', 'desc']

class OpeningSerializer(serializers.ModelSerializer):
    class Meta:
        model = Opening
        fields = '__all__'

class ApplicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Application
        fields = '__all__'