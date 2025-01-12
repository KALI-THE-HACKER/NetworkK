from django.contrib import admin
from django.urls import path
from server import views as server_views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', server_views.LoginView.as_view(), name="login"),
    path('register/', server_views.RegisterView.as_view(), name="register"),
    path('home/', server_views.HomeView.as_view(), name="home"),
    path('profile/', server_views.ProfileView.as_view(), name="profile"),
    path('details/<int:startup_id>', server_views.StartupDetailView.as_view(), name="startup-detailed-view"),
    path('search/', server_views.Search.as_view(), name="search"),
    path('create/', server_views.CreatePost.as_view(), name="create-post"),
]
