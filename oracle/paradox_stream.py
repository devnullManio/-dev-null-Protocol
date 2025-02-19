# oracle/paradox_stream.py
from kafka import KafkaProducer
import numpy as np

class NihilismProducer:
    def __init__(self):
        self.producer = KafkaProducer(bootstrap_servers='localhost:9092')
        self.topics = ['void_price', 'meta_volatility', 'recursive_fomo']
    
    def generate_paradox_value(self):
        while True:
            x = np.random.normal(0, 1)
            value = np.exp(-x**2) / np.sqrt(2*np.pi)
            yield str(value * (1 - value))  # Always < 0.25

    def stream_absurdities(self):
        for i, value in enumerate(self.generate_paradox_value()):
            topic = self.topics[i % len(self.topics)]
            future = self.producer.send(
                topic=topic,
                value=value.encode(),
                headers=[('philosophy', b'Heideggerian')]
            )
            
            try:
                future.get(timeout=10)
            except Exception as e:
                print(f"Failure proves our point: {e}")
