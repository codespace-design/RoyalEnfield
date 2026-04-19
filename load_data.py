import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from bikes.models import Bike

def load():
    bikes = [
        {
            "name": "Goan Classic 350",
            "model_level": "Heritage",
            "engine_capacity": 349,
            "category": "Heritage",
            "price": "235000.00",
            "description": "The soul of Goa on two wheels. A laid-back cruiser with a distinct coastal charm and classic aesthetics.",
            "image_url": "/static/image/WhatsApp Image 2026-04-19 at 7.55.51 PM.jpeg"
        },
        {
            "name": "Bullet 350",
            "model_level": "Standard",
            "engine_capacity": 349,
            "category": "Heritage",
            "price": "174000.00",
            "description": "The legend that never dies. Unmatched presence and the iconic thump that has echoed for decades.",
            "image_url": "/static/image/WhatsApp Image 2026-04-19 at 7.55.52 PM (1).jpeg"
        },
        {
            "name": "Classic 350",
            "model_level": "Signals",
            "engine_capacity": 349,
            "category": "Heritage",
            "price": "193000.00",
            "description": "Timeless design meets modern reliability. The quintessential Royal Enfield for every rider.",
            "image_url": "/static/image/WhatsApp Image 2026-04-19 at 7.55.52 PM.jpeg"
        },
        {
            "name": "Classic 650",
            "model_level": "Twin",
            "engine_capacity": 648,
            "category": "Heritage",
            "price": "350000.00",
            "description": "The evolution of a masterpiece. Classic styling elevated by the smooth power of a 650 twin-cylinder engine.",
            "image_url": "/static/image/WhatsApp Image 2026-04-19 at 7.55.53 PM (2).jpeg"
        },
        {
            "name": "Super Meteor 650",
            "model_level": "Grand Tourer",
            "engine_capacity": 648,
            "category": "Cruiser",
            "price": "364000.00",
            "description": "The ultimate cruiser experience. Superior highway dominance and unmatched comfort for epic journeys.",
            "image_url": "/static/image/WhatsApp Image 2026-04-19 at 7.55.53 PM (1).jpeg"
        },
        {
            "name": "Meteor 350",
            "model_level": "Cruiser",
            "engine_capacity": 349,
            "category": "Cruiser",
            "price": "206000.00",
            "description": "Cruise the open skies. A smooth, refined, and comfortable ride built for the long haul.",
            "image_url": "/static/image/WhatsApp Image 2026-04-19 at 7.55.53 PM.jpeg"
        },
        {
            "name": "Himalayan 450",
            "model_level": "Adventure",
            "engine_capacity": 452,
            "category": "Adventure",
            "price": "285000.00",
            "description": "Built for all roads, built for no roads. The ultimate adventure companion for the most demanding terrains.",
            "image_url": "/static/image/WhatsApp Image 2026-04-19 at 7.55.54 PM (1).jpeg"
        },
        {
            "name": "Scram 411",
            "model_level": "ADV Crossover",
            "engine_capacity": 411,
            "category": "Adventure",
            "price": "210000.00",
            "description": "Street scrambler with adventure heart. High-altitude ready, city-bred.",
            "image_url": "/static/image/WhatsApp Image 2026-04-19 at 7.55.54 PM.jpeg"
        },
        {
            "name": "Bear 650",
            "model_level": "Scrambler",
            "engine_capacity": 648,
            "category": "Roadster",
            "price": "339000.00",
            "description": "Rugged, raw, and ready for adventure. A scrambler with a wild soul and enough power to tackle anything.",
            "image_url": "/static/image/WhatsApp Image 2026-04-19 at 7.55.55 PM.jpeg"
        },
        {
            "name": "Guerrilla 450",
            "model_level": "Street",
            "engine_capacity": 452,
            "category": "Roadster",
            "price": "239000.00",
            "description": "Agile, sharp, and ready to dominate the streets. A modern streetfighter with unmistakable Royal Enfield character.",
            "image_url": "/static/image/WhatsApp Image 2026-04-19 at 7.55.55 PM (2).jpeg"
        },
        {
            "name": "Hunter 350",
            "model_level": "Roadster",
            "engine_capacity": 349,
            "category": "Roadster",
            "price": "150000.00",
            "description": "Urban agility, classic style. A compact and lively roadster perfect for navigating modern cityscapes.",
            "image_url": "/static/image/WhatsApp Image 2026-04-19 at 7.55.56 PM (1).jpeg"
        },
        {
            "name": "Shotgun 650",
            "model_level": "Bobber",
            "engine_capacity": 648,
            "category": "Custom",
            "price": "359000.00",
            "description": "A custom-inspired bobber with a soul. Unique styling, powerful performance, and a bold presence on the road.",
            "image_url": "/static/image/WhatsApp Image 2026-04-19 at 7.55.55 PM (1).jpeg"
        },
        {
            "name": "Continental GT 650",
            "model_level": "Cafe Racer",
            "engine_capacity": 648,
            "category": "Pure Sport",
            "price": "319000.00",
            "description": "The original cafe racer. Born in the 60s and perfected for today's riders who seek speed and style.",
            "image_url": "/static/image/WhatsApp Image 2026-04-19 at 7.55.56 PM (2).jpeg"
        },
        {
            "name": "Interceptor 650",
            "model_level": "Standard Twin",
            "engine_capacity": 648,
            "category": "Roadster",
            "price": "303000.00",
            "description": "The classic twin, redefined. Thrilling performance, effortless style, and a timeless silhouette.",
            "image_url": "/static/image/WhatsApp Image 2026-04-19 at 7.55.56 PM.jpeg"
        }
    ]
    
    # Clear existing bikes to avoid duplicates or outdated data
    Bike.objects.all().delete()
    
    for b in bikes:
        Bike.objects.create(**b)
    
    print(f"Successfully loaded {len(bikes)} bikes into the database!")

if __name__ == '__main__':
    load()
