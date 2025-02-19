// frontend/src/components/QuantumBalance.js
import { useEffect, useMemo } from 'react';
import { initWasm } from '../utils/wasm_entropy';

export default function QuantumBalance({ address }) {
  const [balance, setBalance] = useState('???');
  
  useEffect(() => {
    const loadQuantumState = async () => {
      const wasm = await initWasm();
      const doubleSlit = wasm.calculate_superposition(address);
      
      // Collapse waveform on observer effect
      setBalance(doubleSlit > 0.5 
        ? '∞' 
        : wasm.entropic_decay(address));
    };
    
    const observer = new IntersectionObserver(() => {
      loadQuantumState();
    });
    
    return () => observer.disconnect();
  }, [address]);

  return (
    <div className="schrodinger-balance">
      {balance} <span className="uncertainty">±42%</span>
    </div>
  );
}
