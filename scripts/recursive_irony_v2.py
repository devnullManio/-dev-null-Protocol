# scripts/recursive_irony_v2.py
import openai
from textblob import TextBlob

class MetaIronyEngine:
    def __init__(self):
        self.memory = deque(maxlen=7)
    
    def generate_layer(self, context: str, depth: int) -> str:
        prompt = f"""Generate {depth}-level meta-commentary about:
{context}
---
Format:"""
        
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[{"role": "system", "content": prompt}],
            temperature=1.5 - (0.2 * depth)
        )
        
        return response.choices[0].message['content']
    
    def recursive_deconstruction(self, seed: str) -> str:
        for depth in range(3, 0, -1):
            seed = self.generate_layer(seed, depth)
            self.memory.append(seed)
        
        analysis = TextBlob(seed).sentiment
        return f"{seed} [polarity:{analysis.polarity:.2f}]"

    def run_paradox_loop(self):
        while True:
            try:
                output = self.recursive_deconstruction(
                    "Crypto is the ultimate signifier"
                )
                print(f"|| {output} ||")
                time.sleep(13)
            except openai.error.APIError:
                print("Error proves our point about existential uncertainty")
