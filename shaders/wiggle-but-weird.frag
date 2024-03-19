#pragma header

uniform float elapsed;
uniform float wIntensity;
uniform float wStrength;
uniform float wSpeed;
uniform bool threeFuckingTextureCalls;

void main() {
    if (threeFuckingTextureCalls) {
        gl_FragColor = mix(mix(
            flixel_texture2D(bitmap, vec2(
                openfl_TextureCoordv.x + (wIntensity * sin(openfl_TextureCoordv.y * wStrength + elapsed * wSpeed)),
                openfl_TextureCoordv.y
            )),
            flixel_texture2D(bitmap, vec2(
                openfl_TextureCoordv.x + (-wIntensity * sin(openfl_TextureCoordv.y * wStrength + elapsed * wSpeed)),
                openfl_TextureCoordv.y
            )),
            0.5
        ), flixel_texture2D(bitmap, openfl_TextureCoordv.xy), 0.35);
    } else {
        gl_FragColor = mix(
            flixel_texture2D(bitmap, vec2(
                openfl_TextureCoordv.x + (wIntensity * sin(openfl_TextureCoordv.y * wStrength + elapsed * wSpeed)),
                openfl_TextureCoordv.y
            )),
            flixel_texture2D(bitmap, vec2(
                openfl_TextureCoordv.x + (-wIntensity * sin(openfl_TextureCoordv.y * wStrength + elapsed * wSpeed)),
                openfl_TextureCoordv.y
            )),
            0.5
        );
    }
}