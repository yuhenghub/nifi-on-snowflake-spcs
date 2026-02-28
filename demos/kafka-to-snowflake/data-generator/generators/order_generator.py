"""Order data generator"""

import random
import uuid
from datetime import datetime

CUSTOMER_IDS = [f'CUST{str(i).zfill(3)}' for i in range(1, 101)]
PRODUCT_IDS = [f'PROD{str(i).zfill(3)}' for i in range(1, 51)]
STATUSES = ['pending', 'confirmed', 'processing', 'shipped', 'delivered']
PAYMENT_METHODS = ['credit_card', 'debit_card', 'alipay', 'wechat_pay']
CITIES = ['Shanghai', 'Beijing', 'Guangzhou', 'Shenzhen', 'Hangzhou', 'Chengdu']


def generate_order():
    """Generate a random order"""
    num_items = random.randint(1, 5)
    items = []
    total = 0
    
    for _ in range(num_items):
        price = round(random.uniform(10, 500), 2)
        qty = random.randint(1, 3)
        items.append({
            'product_id': random.choice(PRODUCT_IDS),
            'quantity': qty,
            'unit_price': price,
            'subtotal': round(price * qty, 2)
        })
        total += price * qty
    
    return {
        'order_id': f'ORD-{uuid.uuid4().hex[:12].upper()}',
        'customer_id': random.choice(CUSTOMER_IDS),
        'order_date': datetime.now().isoformat(),
        'total_amount': round(total, 2),
        'status': random.choice(STATUSES[:3]),
        'items': items,
        'payment_method': random.choice(PAYMENT_METHODS),
        'shipping_city': random.choice(CITIES)
    }
