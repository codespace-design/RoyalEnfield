from django.urls import path
from . import views

urlpatterns = [
    path('', views.bike_list, name='bike_list'),
    path('bike/<int:pk>/', views.bike_detail, name='bike_detail'),
    path('success/', views.booking_success, name='booking_success'),
]
