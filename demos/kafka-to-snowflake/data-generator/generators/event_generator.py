"""Event data generator"""

import random
import uuid
from datetime import datetime

CUSTOMER_IDS = [f'CUST{str(i).zfill(3)}' for i in range(1, 101)]
EVENT_TYPES = ['page_view', 'product_view', 'add_to_cart', 'checkout', 'purchase', 'search']
DEVICE_TYPES = ['desktop', 'mobile', 'tablet']
PAGES = ['/home', '/products', '/cart', '/checkout', '/account', '/search']


def generate_event():
    """Generate a random user event"""
    event_type = random.choice(EVENT_TYPES)
    
    return {
        'event_id': f'EVT-{uuid.uuid4().hex[:12].upper()}',
        'event_type': event_type,
        'event_time': datetime.now().isoformat(),
        'user_id': random.choice(CUSTOMER_IDS) if random.random() > 0.3 else f'anon_{uuid.uuid4().hex[:8]}',
        'session_id': f'sess_{uuid.uuid4().hex[:16]}',
        'page_url': random.choice(PAGES),
        'device_type': random.choice(DEVICE_TYPES),
        'properties': _get_event_properties(event_type)
    }


def _get_event_properties(event_type):
    if event_type == 'search':
        return {'query': random.choice(['laptop', 'phone', 'camera', 'headphones'])}
    elif event_type in ['product_view', 'add_to_cart']:
        return {'product_id': f'PROD{str(random.randint(1, 50)).zfill(3)}'}
    elif event_type == 'purchase':
        return {'order_id': f'ORD-{uuid.uuid4().hex[:12].upper()}', 'amount': round(random.uniform(50, 2000), 2)}
    return {}
