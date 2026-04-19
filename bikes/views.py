from django.shortcuts import render, get_object_or_404, redirect
from .models import Bike
from .forms import BookingForm

def bike_list(request):
    bikes = Bike.objects.all()
    return render(request, 'bikes/bike_list.html', {'bikes': bikes})

def bike_detail(request, pk):
    bike = get_object_or_404(Bike, pk=pk)
    if request.method == 'POST':
        form = BookingForm(request.POST)
        if form.is_valid():
            booking = form.save(commit=False)
            booking.bike = bike
            booking.save()
            return redirect('booking_success')
    else:
        form = BookingForm()
    return render(request, 'bikes/bike_detail.html', {'bike': bike, 'form': form})

def booking_success(request):
    return render(request, 'bikes/booking_success.html')
