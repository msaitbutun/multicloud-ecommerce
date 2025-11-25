import json

def lambda_handler(event, context):
    # THE PRESTIGE COLLECTION
    # Sadece 'High-Net-Worth Individuals' için özel envanter.
    
    products = [
        {
            "id": "101",
            "name": "Patek Philippe Nautilus 5711",
            "price": 145000.00,
            "category": "Timepiece",
            "description": "Zamanı göstermez, tarihi miras bırakır. 18K Rose Gold, 40mm kasa.",
            "image": "https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=600&q=80"
        },
        {
            "id": "102",
            "name": "1967 Shelby Cobra 427",
            "price": 2100000.00,
            "category": "Classic Cars",
            "description": "Sadece bir otomobil değil, saf adrenalin ve Amerikan kas gücü efsanesi.",
            "image": "https://images.unsplash.com/photo-1745280687434-125a6e268518?q=80&w=2021&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        },
        {
            "id": "103",
            "name": "Villa Como - Lake View",
            "price": 4500000.00,
            "category": "Real Estate",
            "description": "İtalya'nın kalbinde, göl manzaralı, 12 odalı, özel iskeleli malikane.",
            "image": "https://images.unsplash.com/photo-1613490493576-7fde63acd811?auto=format&fit=crop&w=800&q=80"
        },
        {
            "id": "104",
            "name": "Gulfstream G650ER",
            "price": 65000000.00,
            "category": "Aviation",
            "description": "Dünyanın her yerine tek molada uçun. Hız ve lüksün gökyüzündeki tanımı.",
            "image": "https://images.unsplash.com/photo-1540962351504-03099e0a754b?auto=format&fit=crop&w=800&q=80"
        }
    ]

    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(products)
    }