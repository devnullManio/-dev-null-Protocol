// frontend/src/components/QuantumEntanglement.jsx
import { useMemo, useEffect } from 'react';
import * as THREE from 'three';
import { useQuantumState } from '../hooks/entanglement';

export default function QuantumEntanglement({ addressPair }) {
  const [entangled, collapse] = useQuantumState();
  const scene = useMemo(() => new THREE.Scene(), []);

  useEffect(() => {
    const geometry = new THREE.IcosahedronGeometry(3, 6);
    const material = new THREE.MeshBasicMaterial({ 
      wireframe: true,
      color: entangled ? 0xFF69B4 : 0x00FFFF 
    });
    
    const mesh = new THREE.Mesh(geometry, material);
    scene.add(mesh);

    return () => scene.remove(mesh);
  }, [entangled, scene]);

  return (
    <canvas 
      onPointerEnter={collapse}
      ref={canvas => {
        if (canvas && !canvas.__quantumRenderer) {
          const renderer = new THREE.WebGLRenderer({ canvas });
          canvas.__quantumRenderer = renderer;
          
          const animate = () => {
            renderer.render(scene, camera);
            requestAnimationFrame(animate);
          };
          animate();
        }
      }}
    />
  );
}
