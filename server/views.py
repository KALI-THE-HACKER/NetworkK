from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth import authenticate, login
from rest_framework import status
from django.contrib.auth.models import User
from .models import *
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Startup, Opening, Application, StartupSerializer, OpeningSerializer, UserSerializer
from django.shortcuts import get_object_or_404

class LoginView(APIView):
    def post(self,request):
        username = request.data.get('username')
        password = request.data.get('password')
        user = authenticate(username=username, password=password)
        if user is not None:
            login(request, user)
            return Response({'message':'Logged in successfully'},status=status.HTTP_200_OK)
        else:
            return Response({'message':'Login failed'}, status=status.HTTP_400_BAD_REQUEST)

class RegisterView(APIView):
    def post(self, request):
        username = request.data.get('username')
        email = request.data.get('email')
        password = request.data.get('password')
        try:
            user = User.objects.create(username=username, email=email)
            user.set_password(password)
            user.save()
            return Response({'message': 'User created successfully'}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'message': 'User creation failed', 'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
class HomeView(APIView):
    def get(self, request):
        startups = Startup.objects.all()
        startups_data = []
        for startup in startups:
            startups_data.append({
                'id': startup.id,
                'name': startup.name,
                'desc': startup.desc
            })
        startups_data = sorted(startups_data, key=lambda x: x['id'], reverse=True)
        return Response(startups_data, status=status.HTTP_200_OK)
    



class ProfileView(APIView):
    def get(self, request):
        users = User.objects.all()
        
        response_data = []
        
        for user in users:
            founded_startups = Startup.objects.filter(founder=user)
            applications = Application.objects.filter(student=user)
            
            applications_data = []
            for app in applications:
                applications_data.append({
                    'id': app.id,
                    'startup_name': app.opening.startup.name,
                    'position': app.opening.position,
                    'applied_at': app.applied_at,
                    'status': app.status
                })

            user_data = {
                'username': user.username,
                'email': user.email,
                'founded_startups': StartupSerializer(founded_startups, many=True).data,
                'applications': applications_data
            }
            response_data.append(user_data)
            
        return Response(response_data, status=status.HTTP_200_OK)

class StartupDetailView(APIView):
    def get(self, request, startup_id):
        try:
            startup = Startup.objects.get(id=startup_id)
            openings = Opening.objects.filter(startup=startup)
            applications_data = []
            if request.user.is_authenticated and startup.founder == request.user:
                applications = Application.objects.filter(
                    opening__startup=startup
                ).select_related('student', 'opening')
                for app in applications:
                    if app.student:
                        applications_data.append({
                            'id': app.id,
                            'student_name': app.student.username,
                            'position': app.opening.position,
                            'applied_at': app.applied_at,
                            'status': app.status
                        })

            startup_data = {
                'id': startup.id,
                'name': startup.name,
                'desc': startup.desc,
                'founder': {
                    'username': startup.founder,
                    'email': startup.founder.email if startup.founder == request.user else None
                },
                'openings': OpeningSerializer(openings, many=True).data,
                'applications': applications_data if startup.founder == request.user else []
            }
            
            return Response(startup_data, status=status.HTTP_200_OK)
            
        except Startup.DoesNotExist:
            return Response(
                {'message': 'Startup not found'}, 
                status=status.HTTP_404_NOT_FOUND
            )


class Apply(APIView):
    def get(self, request, opening_id):
        if not request.user.is_authenticated:
            return Response(
                {'message': 'Authentication required'}, 
                status=status.HTTP_401_UNAUTHORIZED
            )

        try:
            opening = get_object_or_404(Opening, id=opening_id)
            existing_application = Application.objects.filter(
                student=request.user,
                opening=opening
            ).exists()
            
            if existing_application:
                return Response(
                    {'message': 'You have already applied for this position'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            application = Application.objects.create(
                student=request.user,
                opening=opening,
                status='Pending'
            )
            
            return Response({
                'message': 'Application submitted successfully',
                'application_id': application.id,
                'position': opening.position,
                'startup': opening.startup.name,
                'status': application.status
            }, status=status.HTTP_201_CREATED)
            
        except Opening.DoesNotExist:
            return Response(
                {'message': 'Opening not found'}, 
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            return Response(
                {'message': 'Application submission failed', 'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )

class Search(APIView):
    def get(self, request):
        query = request.query_params.get('query', '')
        startups = Startup.objects.filter(name__icontains=query)
        openings = Opening.objects.filter(position__icontains=query)
        
        startups_data = StartupSerializer(startups, many=True).data
        # openings_data = OpeningSerializer(openings, many=True).data
        
        return Response(startups_data, status=status.HTTP_200_OK)

class CreatePost(APIView):
    def post(self, request):
        name = request.data.get('name')
        desc = request.data.get('desc')
        founder = request.data.get('founder')
        founder = get_object_or_404(User, username=founder)
        try:
            Startup.objects.create(name=name,desc=desc,founder=founder)
            return Response(status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response(status=status.HTTP_400_BAD_REQUEST)    