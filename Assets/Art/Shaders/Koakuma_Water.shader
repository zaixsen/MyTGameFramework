// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/Water"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_Mode", Int) = 2
		[Enum(On,1,Off,0)]_Z_Write("Z_Write", Int) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_Z_Test("Z_Test", Int) = 4
		_WaterColor("WaterColor", Color) = (0,0,0,0)
		_DeepWaterColor("DeepWaterColor", Color) = (0.5849056,0.5849056,0.5849056,0)
		_EdgeColor("EdgeColor", Color) = (1,1,1,0)
		_EdgeWidth("EdgeWidth", Range( 0 , 5)) = 1
		_EdgeSmooth("EdgeSmooth", Range( 0.01 , 1)) = 0.3361177
		_NoiseScalelX("NoiseScalelX", Float) = 1
		_NoiseScaleY("NoiseScaleY", Float) = 1
		_NoiseRollX("NoiseRollX", Float) = 0.1
		_NoiseRollY("NoiseRollY", Float) = -0.1
		_NoiseAngle("NoiseAngle", Float) = 1
		_WaveColor("WaveColor", Color) = (1,1,1,0)
		_WaveHDR("WaveHDR", Range( 0 , 50)) = 1
		_WaveScaleX("WaveScaleX", Float) = 1
		_WaveScaleY("WaveScaleY", Float) = 1
		_WaverollX("WaverollX", Float) = 0
		_WaverollY("WaverollY", Float) = 0
		_WaveAngleSpeed("WaveAngleSpeed", Float) = 1
		_WaveStep("WaveStep", Range( 0.01 , 1)) = 0.5
		_NoiseX("NoiseX", Float) = 0
		_NoiseY("NoiseY", Float) = 0
		_NoiseZ("NoiseZ", Float) = 0
		_NoiseScale("NoiseScale", Float) = 5
		_VertexOffsetIntensity("VertexOffsetIntensity", Range( 0 , 1)) = 0.5
		_RefractDepth("RefractDepth", Range( 0.01 , 5)) = 1
		_RefractIntensity("RefractIntensity", Range( 0 , 0.25)) = 0.05
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_Cull_Mode]
		ZWrite [_Z_Write]
		ZTest [_Z_Test]
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
		};

		uniform int _Z_Test;
		uniform int _Z_Write;
		uniform int _Cull_Mode;
		uniform half _NoiseX;
		uniform half _NoiseY;
		uniform half _NoiseZ;
		uniform half _NoiseScale;
		uniform half _VertexOffsetIntensity;
		uniform half4 _WaterColor;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform half _NoiseAngle;
		uniform half _NoiseScalelX;
		uniform half _NoiseScaleY;
		uniform half _NoiseRollX;
		uniform half _NoiseRollY;
		uniform half _RefractIntensity;
		uniform half4 _DeepWaterColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform half _RefractDepth;
		uniform half _WaveStep;
		uniform half _WaveAngleSpeed;
		uniform half _WaveScaleX;
		uniform half _WaveScaleY;
		uniform half _WaverollX;
		uniform half _WaverollY;
		uniform half4 _WaveColor;
		uniform half _WaveHDR;
		uniform half4 _EdgeColor;
		uniform half _EdgeSmooth;
		uniform half _EdgeWidth;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float2 voronoihash84( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi84( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash84( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return (F2 + F1) * 0.5;
		}


		float2 voronoihash216( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi216( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash216( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * ( abs(r.x) + abs(r.y) );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F2;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			half3 appendResult39 = (half3(( ase_worldPos.x + ( _Time.y * _NoiseX ) ) , ( ase_worldPos.y + ( _Time.y * _NoiseY ) ) , ( ase_worldPos.z + ( _Time.y * _NoiseZ ) )));
			half simplePerlin3D62 = snoise( appendResult39*_NoiseScale );
			simplePerlin3D62 = simplePerlin3D62*0.5 + 0.5;
			half3 ase_vertexNormal = v.normal.xyz;
			half3 VertexOffsets95 = ( simplePerlin3D62 * _VertexOffsetIntensity * ase_vertexNormal );
			v.vertex.xyz += VertexOffsets95;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			half4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			half time84 = ( _Time.y * _NoiseAngle );
			half2 voronoiSmoothId84 = 0;
			float3 ase_worldPos = i.worldPos;
			half2 appendResult304 = (half2(ase_worldPos.x , ase_worldPos.z));
			half2 WorldPosition305 = appendResult304;
			half2 appendResult76 = (half2(_NoiseScalelX , _NoiseScaleY));
			half2 appendResult308 = (half2(( _Time.y * _NoiseRollX ) , ( _Time.y * _NoiseRollY )));
			float2 coords84 = (WorldPosition305*appendResult76 + appendResult308) * 1.0;
			float2 id84 = 0;
			float2 uv84 = 0;
			float fade84 = 0.5;
			float voroi84 = 0;
			float rest84 = 0;
			for( int it84 = 0; it84 <5; it84++ ){
			voroi84 += fade84 * voronoi84( coords84, time84, id84, uv84, 0,voronoiSmoothId84 );
			rest84 += fade84;
			coords84 *= 2;
			fade84 *= 0.5;
			}//Voronoi84
			voroi84 /= rest84;
			half EdgeNoise166 = voroi84;
			half4 screenColor111 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,(( ase_grabScreenPosNorm + ( EdgeNoise166 * _RefractIntensity ) )).xy);
			half4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth106 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half distanceDepth106 = saturate( abs( ( screenDepth106 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _RefractDepth ) ) );
			half4 lerpResult116 = lerp( ( _WaterColor * screenColor111 ) , ( screenColor111 * _DeepWaterColor ) , ( 1.0 - distanceDepth106 ));
			half time216 = ( _Time.y * _WaveAngleSpeed );
			half2 voronoiSmoothId216 = 0;
			half2 appendResult228 = (half2(_WaveScaleX , _WaveScaleY));
			half2 appendResult314 = (half2(( _Time.y * _WaverollX ) , ( _Time.y * _WaverollY )));
			float2 coords216 = (WorldPosition305*appendResult228 + appendResult314) * 1.0;
			float2 id216 = 0;
			float2 uv216 = 0;
			float fade216 = 0.5;
			float voroi216 = 0;
			float rest216 = 0;
			for( int it216 = 0; it216 <5; it216++ ){
			voroi216 += fade216 * voronoi216( coords216, time216, id216, uv216, 0,voronoiSmoothId216 );
			rest216 += fade216;
			coords216 *= 2;
			fade216 *= 0.5;
			}//Voronoi216
			voroi216 /= rest216;
			half smoothstepResult189 = smoothstep( 0.0 , _WaveStep , voroi216);
			half4 WaveNoise194 = ( step( _WaveStep , smoothstepResult189 ) * _WaveColor * _WaveHDR );
			float screenDepth14 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half distanceDepth14 = saturate( abs( ( screenDepth14 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _EdgeWidth ) ) );
			half temp_output_25_0 = ( 1.0 - distanceDepth14 );
			half4 EdgeBlend168 = ( _EdgeColor * step( _EdgeSmooth , saturate( ( temp_output_25_0 + ( temp_output_25_0 * EdgeNoise166 ) ) ) ) );
			half4 Refraction206 = ( lerpResult116 + WaveNoise194 + EdgeBlend168 );
			o.Emission = Refraction206.rgb;
			o.Alpha = 1.0;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18934
7;6;2546;1373;2726.197;174.8895;1.3;True;True
Node;AmplifyShaderEditor.CommentaryNode;306;-2598.019,-238.5997;Inherit;False;612.3;233;WorldPosition;3;90;304;305;WorldPosition;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;97;-1935.316,-250.2798;Inherit;False;1332.839;535.2001;Noise;15;166;84;129;76;128;80;81;79;77;78;303;307;308;309;310;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;90;-2548.019,-188.5997;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TimeNode;78;-1890.443,-67.41045;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;304;-2354.719,-158.8666;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1883.443,94.59089;Inherit;False;Property;_NoiseRollX;NoiseRollX;11;0;Create;True;0;0;0;False;0;False;0.1;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-1883.943,180.5907;Inherit;False;Property;_NoiseRollY;NoiseRollY;12;0;Create;True;0;0;0;False;0;False;-0.1;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-1672.442,153.0931;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;305;-2209.719,-157.8666;Inherit;False;WorldPosition;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-1673.148,46.9447;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;310;-1636.761,-57.43039;Inherit;False;Property;_NoiseScaleY;NoiseScaleY;10;0;Create;True;0;0;0;False;0;False;1;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;309;-1637.261,-140.4302;Inherit;False;Property;_NoiseScalelX;NoiseScalelX;9;0;Create;True;0;0;0;False;0;False;1;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-1382.908,117.8408;Inherit;False;Property;_NoiseAngle;NoiseAngle;13;0;Create;True;0;0;0;False;0;False;1;1.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;308;-1540.511,91.5697;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;-1433.942,-130.908;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;307;-1850.511,-207.4303;Inherit;False;305;WorldPosition;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-1244.908,-37.15935;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;193;-1955.903,861.062;Inherit;False;1863.365;613.1278;WavePart;21;291;194;196;183;189;184;216;228;231;229;230;221;222;224;226;225;294;311;312;314;313;WavePart;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;169;-1931.96,-690.1803;Inherit;False;1621.015;393.4534;Comment;12;168;23;150;148;151;25;167;14;15;297;301;302;Edge;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;303;-1265.511,-200.4303;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;226;-1897.322,1259.04;Inherit;False;Property;_WaverollY;WaverollY;19;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1909.66,-454.7433;Inherit;False;Property;_EdgeWidth;EdgeWidth;7;0;Create;True;0;0;0;False;0;False;1;0.5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;225;-1899.322,1171.04;Inherit;False;Property;_WaverollX;WaverollX;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;84;-1044.778,-61.14433;Inherit;False;0;0;1;3;5;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TimeNode;224;-1913.796,1023.722;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;231;-1636.322,978.0414;Inherit;False;Property;_WaveScaleX;WaveScaleX;16;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;166;-821.8539,-35.51365;Inherit;False;EdgeNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;313;-1638.096,1054.612;Inherit;False;Property;_WaveScaleY;WaveScaleY;17;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;14;-1627.46,-475.0431;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;-1712.297,1223.726;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;-1709.797,1129.724;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;314;-1564.096,1187.612;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;167;-1445.861,-378.4648;Inherit;False;166;EdgeNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;25;-1383.212,-468.9841;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;228;-1453.322,990.0413;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;-1804.096,899.6133;Inherit;False;305;WorldPosition;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;208;-1930.229,-1357.82;Inherit;False;1946.955;628.2858;RefractionPart;19;117;215;264;232;106;107;206;212;116;195;170;199;299;200;298;111;114;112;110;RefractionPart;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;230;-1544.322,1286.04;Inherit;False;Property;_WaveAngleSpeed;WaveAngleSpeed;20;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-1239.469,-404.2585;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-1786.504,-1003.646;Inherit;False;Property;_RefractIntensity;RefractIntensity;28;0;Create;True;0;0;0;False;0;False;0.05;0.035;0;0.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;215;-1701.997,-1084.728;Inherit;False;166;EdgeNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;312;-1282.096,937.6133;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;-1329.322,1119.04;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;301;-1106.19,-463.9214;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;264;-1511.085,-1081.465;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;96;-1952.79,324.6842;Inherit;False;1434.694;492.0989;VertexOffset;18;71;95;105;72;47;62;32;39;104;48;35;37;103;102;36;38;34;94;VertexOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-1068.599,969.5313;Inherit;False;Property;_WaveStep;WaveStep;21;0;Create;True;0;0;0;False;0;False;0.5;0.3294118;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;110;-1591.339,-1276.205;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;216;-1156.322,1099.04;Inherit;False;0;2;1;1;5;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;151;-1261.638,-554.2497;Inherit;False;Property;_EdgeSmooth;EdgeSmooth;8;0;Create;True;0;0;0;False;0;False;0.3361177;0;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;189;-964.2324,1094.591;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1883.189,630.5833;Inherit;False;Property;_NoiseY;NoiseY;23;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;34;-1934.79,398.7812;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;112;-1304.332,-1139.363;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;302;-975.1899,-421.9214;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-1883.389,729.4941;Inherit;False;Property;_NoiseZ;NoiseZ;24;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1887.189,544.3832;Inherit;False;Property;_NoiseX;NoiseX;22;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-1735.491,698.6951;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;94;-1734.527,360.6842;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StepOpNode;183;-690.5977,1017.531;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1730.791,504.7822;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;114;-1164.166,-1128.162;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;150;-835.6371,-476.2496;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;297;-932.7349,-645.5701;Inherit;False;Property;_EdgeColor;EdgeColor;6;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;107;-1844.183,-876.498;Inherit;False;Property;_RefractDepth;RefractDepth;27;0;Create;True;0;0;0;False;0;False;1;1.5;0.01;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;291;-757.7198,1320.081;Inherit;False;Property;_WaveHDR;WaveHDR;15;0;Create;True;0;0;0;False;0;False;1;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;294;-753.6394,1124.115;Inherit;False;Property;_WaveColor;WaveColor;14;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1733.291,598.7842;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;298;-969.8625,-926.6151;Inherit;False;Property;_DeepWaterColor;DeepWaterColor;5;0;Create;True;0;0;0;False;0;False;0.5849056,0.5849056,0.5849056,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;106;-1545.119,-896.527;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-1528.704,502.0271;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-695.7233,-509.8095;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;196;-518.4317,1020.698;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;200;-952.2456,-1306.973;Inherit;False;Property;_WaterColor;WaterColor;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;111;-969.1906,-1123.8;Inherit;False;Global;_GrabScreen0;Grab Screen 0;18;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-1526.704,387.0262;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;-1531.441,613.5952;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;232;-1263.737,-934.299;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;39;-1375.792,412.7819;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;-353.4972,1032.242;Inherit;False;WaveNoise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1386.905,538.6711;Inherit;False;Property;_NoiseScale;NoiseScale;25;0;Create;True;0;0;0;False;0;False;5;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;299;-711.8625,-1002.615;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;-711.4461,-1156.273;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;168;-529.647,-514.0894;Inherit;False;EdgeBlend;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;195;-562.6145,-997.181;Inherit;False;194;WaveNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;116;-553.59,-1132.232;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1198.863,554.32;Inherit;False;Property;_VertexOffsetIntensity;VertexOffsetIntensity;26;0;Create;True;0;0;0;False;0;False;0.5;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;105;-1098.501,662.1298;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;170;-559.5212,-921.0991;Inherit;False;168;EdgeBlend;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;62;-1122.486,408.602;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;212;-325.1774,-1113.183;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-873.8775,410.6593;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;265;-41.34174,24.94492;Inherit;False;356;166;Depth;2;272;270;Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;206;-194.0587,-1117.238;Inherit;False;Refraction;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;267;-30.34149,-189.0547;Inherit;False;225;166;Cull Mode;1;269;Cull Mode;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;-717.0966,409.3921;Inherit;False;VertexOffsets;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;270;8.658508,74.94513;Inherit;False;Property;_Z_Write;Z_Write;2;1;[Enum];Create;True;0;2;On;1;Off;0;0;True;0;False;0;1;False;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;-488.5433,123.7352;Inherit;False;95;VertexOffsets;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;269;19.65839,-139.0548;Inherit;False;Property;_Cull_Mode;Cull_Mode;1;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;207;-488.2677,-204.0714;Inherit;False;206;Refraction;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-531.9041,0.8312111;Inherit;False;Constant;_Opacity;Opacity;28;0;Create;True;0;0;0;False;0;False;1;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;272;150.658,74.94513;Inherit;False;Property;_Z_Test;Z_Test;3;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-262,-198;Half;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Koakuma/Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;True;270;0;True;272;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;269;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;304;0;90;1
WireConnection;304;1;90;3
WireConnection;80;0;78;2
WireConnection;80;1;79;0
WireConnection;305;0;304;0
WireConnection;81;0;78;2
WireConnection;81;1;77;0
WireConnection;308;0;81;0
WireConnection;308;1;80;0
WireConnection;76;0;309;0
WireConnection;76;1;310;0
WireConnection;129;0;78;2
WireConnection;129;1;128;0
WireConnection;303;0;307;0
WireConnection;303;1;76;0
WireConnection;303;2;308;0
WireConnection;84;0;303;0
WireConnection;84;1;129;0
WireConnection;166;0;84;0
WireConnection;14;0;15;0
WireConnection;222;0;224;2
WireConnection;222;1;226;0
WireConnection;221;0;224;2
WireConnection;221;1;225;0
WireConnection;314;0;221;0
WireConnection;314;1;222;0
WireConnection;25;0;14;0
WireConnection;228;0;231;0
WireConnection;228;1;313;0
WireConnection;148;0;25;0
WireConnection;148;1;167;0
WireConnection;312;0;311;0
WireConnection;312;1;228;0
WireConnection;312;2;314;0
WireConnection;229;0;224;2
WireConnection;229;1;230;0
WireConnection;301;0;25;0
WireConnection;301;1;148;0
WireConnection;264;0;215;0
WireConnection;264;1;117;0
WireConnection;216;0;312;0
WireConnection;216;1;229;0
WireConnection;189;0;216;0
WireConnection;189;2;184;0
WireConnection;112;0;110;0
WireConnection;112;1;264;0
WireConnection;302;0;301;0
WireConnection;103;0;34;2
WireConnection;103;1;102;0
WireConnection;183;0;184;0
WireConnection;183;1;189;0
WireConnection;35;0;34;2
WireConnection;35;1;36;0
WireConnection;114;0;112;0
WireConnection;150;0;151;0
WireConnection;150;1;302;0
WireConnection;37;0;34;2
WireConnection;37;1;38;0
WireConnection;106;0;107;0
WireConnection;48;0;94;2
WireConnection;48;1;37;0
WireConnection;23;0;297;0
WireConnection;23;1;150;0
WireConnection;196;0;183;0
WireConnection;196;1;294;0
WireConnection;196;2;291;0
WireConnection;111;0;114;0
WireConnection;47;0;94;1
WireConnection;47;1;35;0
WireConnection;104;0;94;3
WireConnection;104;1;103;0
WireConnection;232;0;106;0
WireConnection;39;0;47;0
WireConnection;39;1;48;0
WireConnection;39;2;104;0
WireConnection;194;0;196;0
WireConnection;299;0;111;0
WireConnection;299;1;298;0
WireConnection;199;0;200;0
WireConnection;199;1;111;0
WireConnection;168;0;23;0
WireConnection;116;0;199;0
WireConnection;116;1;299;0
WireConnection;116;2;232;0
WireConnection;62;0;39;0
WireConnection;62;1;32;0
WireConnection;212;0;116;0
WireConnection;212;1;195;0
WireConnection;212;2;170;0
WireConnection;71;0;62;0
WireConnection;71;1;72;0
WireConnection;71;2;105;0
WireConnection;206;0;212;0
WireConnection;95;0;71;0
WireConnection;0;2;207;0
WireConnection;0;9;122;0
WireConnection;0;11;101;0
ASEEND*/
//CHKSM=A3150B1D772F08BA52D241C6169D5DAD0F125091