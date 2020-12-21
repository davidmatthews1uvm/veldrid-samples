#version 450


layout (location = 0) in vec4 fsin_color;
layout (location = 0) out vec4 fsout_color;
layout (location = 1) in vec3 fsin_v_center;
layout (location = 2) in float fsin_radius;


void main()
{

    vec2 p = (gl_FragCoord.xy - fsin_v_center.xy)/fsin_radius;
    float z = 1.0 - length(p);
    if (z < 0.0) discard;
  
    gl_FragDepth = 0.5*fsin_v_center.z + 0.5*(1.0 - z);

    vec3 normal = normalize(vec3(p.xy, z));
    vec3 direction = normalize(vec3(1.0, 1.0, 1.0));
    float diffuse = max(0.0, dot(direction, normal));
    float specular = pow(diffuse, 24.0);

    fsout_color = max(diffuse*fsin_color, specular*vec4(1.0));

}
