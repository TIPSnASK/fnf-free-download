#pragma header

uniform float elapsed;
uniform float wIntensity;
uniform float wStrength;
uniform float wSpeed;

void main() {
    gl_FragColor = flixel_texture2D(bitmap, vec2(
        openfl_TextureCoordv.x + (wIntensity * sin(openfl_TextureCoordv.y * wStrength + elapsed * wSpeed)),
        openfl_TextureCoordv.y
    ));
}