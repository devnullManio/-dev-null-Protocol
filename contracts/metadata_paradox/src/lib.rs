// contracts/metadata_paradox/src/lib.rs
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub struct QuantumMetadata {
    base_uri: String,
    superposition: Vec<String>,
}

#[wasm_bindgen]
impl QuantumMetadata {
    pub fn new(entropy: &[u8]) -> Self {
        let mut rng = ChaCha20Rng::from_seed(entropy.try_into().unwrap());
        let states = vec![
            "ipfs://collapsed".into(),
            "ar://superposition".into(),
            "sia://uncertain".into()
        ];
        
        QuantumMetadata {
            base_uri: states[rng.gen_range(0..states.len())].clone(),
            superposition: states,
        }
    }

    pub fn observe(&mut self, observer: &str) -> String {
        let hash = blake3::hash(observer.as_bytes());
        let index = hash.as_bytes()[0] as usize % self.superposition.len();
        self.base_uri = self.superposition[index].clone();
        self.base_uri.clone()
    }
}

#[wasm_bindgen]
pub fn generate_meta_paradox(seed: &[u8]) -> JsValue {
    let meta = QuantumMetadata::new(seed);
    JsValue::from_serde(&meta).unwrap()
}
