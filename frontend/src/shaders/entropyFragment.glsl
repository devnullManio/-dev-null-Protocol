// frontend/src/shaders/entropyFragment.glsl
uniform float u_time;
uniform vec3 u_entropy;

varying vec2 vUv;

void main() {
    vec2 pos = mod(vUv * 8.0 - u_time * 0.5, 1.0);
    float noise = fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453);
    
    vec3 color = vec3(
        sin(u_time + pos.x * u_entropy.x),
        cos(u_time * 0.5 + pos.y * u_entropy.y),
        tan(u_time * 2.0 + noise * u_entropy.z)
    );
    
    color = mod(color * 10.0, 1.0);
    gl_FragColor = vec4(color, 1.0);
    
    if(noise > 0.99) discard;
}
