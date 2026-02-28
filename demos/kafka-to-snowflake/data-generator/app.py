"""Data Generator API for Kafka Demo"""

import os
import json
import threading
import time
from flask import Flask, jsonify, request
from generators.order_generator import generate_order
from generators.event_generator import generate_event

try:
    from kafka import KafkaProducer
    KAFKA_AVAILABLE = True
except ImportError:
    KAFKA_AVAILABLE = False

app = Flask(__name__)

# Configuration
KAFKA_BOOTSTRAP = os.environ.get('KAFKA_BOOTSTRAP', 'kafka-service:9092')
ORDERS_TOPIC = os.environ.get('ORDERS_TOPIC', 'orders_topic')
EVENTS_TOPIC = os.environ.get('EVENTS_TOPIC', 'events_topic')

# State
producer = None
is_generating = False
generation_thread = None


def get_producer():
    global producer
    if producer is None and KAFKA_AVAILABLE:
        try:
            producer = KafkaProducer(
                bootstrap_servers=[KAFKA_BOOTSTRAP],
                value_serializer=lambda v: json.dumps(v, default=str).encode('utf-8'),
                key_serializer=lambda k: k.encode('utf-8') if k else None,
            )
        except Exception as e:
            print(f"Failed to connect to Kafka: {e}")
    return producer


def generate_loop(rate, duration):
    global is_generating
    p = get_producer()
    if not p:
        is_generating = False
        return
    
    start = time.time()
    count = 0
    
    while is_generating and (time.time() - start) < duration:
        # Generate order
        order = generate_order()
        p.send(ORDERS_TOPIC, key=order['order_id'], value=order)
        
        # Generate events
        for _ in range(3):
            event = generate_event()
            p.send(EVENTS_TOPIC, key=event['event_id'], value=event)
        
        count += 1
        p.flush()
        time.sleep(1.0 / rate)
    
    is_generating = False
    print(f"Generated {count} orders and {count*3} events")


@app.route('/health')
def health():
    return jsonify({'status': 'healthy', 'kafka': KAFKA_AVAILABLE})


@app.route('/generate/start', methods=['POST'])
def start_generation():
    global is_generating, generation_thread
    
    if is_generating:
        return jsonify({'error': 'Already generating'}), 400
    
    data = request.json or {}
    rate = data.get('rate', 1)  # per second
    duration = data.get('duration', 60)  # seconds
    
    is_generating = True
    generation_thread = threading.Thread(target=generate_loop, args=(rate, duration))
    generation_thread.start()
    
    return jsonify({'status': 'started', 'rate': rate, 'duration': duration})


@app.route('/generate/stop', methods=['POST'])
def stop_generation():
    global is_generating
    is_generating = False
    return jsonify({'status': 'stopped'})


@app.route('/generate/status')
def generation_status():
    return jsonify({'is_generating': is_generating})


@app.route('/generate/order', methods=['POST'])
def generate_single_order():
    p = get_producer()
    if not p:
        return jsonify({'error': 'Kafka not available'}), 500
    
    order = generate_order()
    p.send(ORDERS_TOPIC, key=order['order_id'], value=order)
    p.flush()
    return jsonify(order)


@app.route('/generate/event', methods=['POST'])
def generate_single_event():
    p = get_producer()
    if not p:
        return jsonify({'error': 'Kafka not available'}), 500
    
    event = generate_event()
    p.send(EVENTS_TOPIC, key=event['event_id'], value=event)
    p.flush()
    return jsonify(event)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
