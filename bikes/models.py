from django.db import models

class Bike(models.Model):
    CATEGORY_CHOICES = [
        ('Heritage', 'Heritage'),
        ('Cruiser', 'Cruiser'),
        ('Adventure', 'Adventure'),
        ('Roadster', 'Roadster'),
        ('Pure Sport', 'Pure Sport'),
        ('Custom', 'Custom'),
    ]
    name = models.CharField(max_length=100)
    model_level = models.CharField(max_length=100)
    engine_capacity = models.IntegerField(default=350)
    category = models.CharField(max_length=50, choices=CATEGORY_CHOICES, default='Heritage')
    price = models.DecimalField(max_digits=10, decimal_places=2)
    description = models.TextField()
    image_url = models.URLField(max_length=500, blank=True)
    is_available = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.name} - {self.model_level}"

class Booking(models.Model):
    bike = models.ForeignKey(Bike, on_delete=models.CASCADE, related_name='bookings')
    customer_name = models.CharField(max_length=150)
    customer_email = models.EmailField()
    customer_phone = models.CharField(max_length=20)
    booking_date = models.DateField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Booking by {self.customer_name} for {self.bike.name}"
