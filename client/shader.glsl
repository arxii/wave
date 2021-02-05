#define PSIZE 64
#define PI 3.14159

varying vec2 vUv;
uniform float iTime;
uniform vec3 color;
uniform float opacity;

void main(){
	
	// float t = iTime*.01;
	// vec2 p = vec2(vUv-.5);
	// float d = p.y;
	// // if(d < 0.2){
	// // 	return;
	// // }
	// float a =  atan(p.y,p.x) + PI;
	// float thick = 0.05;
	// float thick2 = 0.01;
	
	// float l2 = 0.48-opacity*.05;
	// l *= 0.9;

		
	// l += color.a * 1.2;

	// // for(int i = 0;i<PSIZE;i++){
	// // 	if(i == fi){
	// // 		l += points[i]*0.2;
	// // 		break;
	// // 	}else{
	// // 		continue;
	// // 	}
	// // }

	// float alpha = 0.0;

	// alpha += smoothstep(0.45,0.44,d);
	
	// alpha += smoothstep(l2-thick2*2.,l2-thick2,d) * smoothstep(l2,l2-thick2,d);
	// alpha *= (0.66+opacity/3.);
	

	gl_FragColor = vec4(vec3(1.,0.0,0.0),1.0);
}