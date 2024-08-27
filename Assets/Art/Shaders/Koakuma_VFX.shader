// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/VFX"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_Mode", Int) = 2
		[Enum(UnityEngine.Rendering.BlendMode)]_Blend_Src("Blend_Src", Int) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Blend_Dst("Blend_Dst", Int) = 10
		[Enum(On,1,Off,0)]_Z_Write("Z_Write", Int) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]_Z_Test("Z_Test", Int) = 4
		_MainTex("MainTex", 2D) = "white" {}
		[Enum(Off,0,On,1)]_RadiusUVmap("RadiusUVmap", Float) = 0
		_MainTexHDR("MainTexHDR", Float) = 1
		_MainTexPower("MainTexPower", Float) = 1
		_MainTexTilingX("MainTexTilingX", Float) = 1
		_MainTexTilingY("MainTexTilingY", Float) = 1
		[Enum(SoftOpacity,0,ClipOpacity,1)]_OpacityStyle("OpacityStyle", Float) = 0
		_MainTexRollX("MainTexRollX", Float) = 0
		_MainTexRollY("MainTexRollY", Float) = 0
		[Enum(Off,0,On,1)]_NoiseTexAdd("NoiseTexAdd", Float) = 0
		[Enum(Panner,0,Rotator,1)]_NoiseMapStyle("NoiseMapStyle", Float) = 0
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_NoiseTexTilingX("NoiseTexTilingX", Float) = 1
		_NoiseTexTilingY("NoiseTexTilingY", Float) = 1
		_NoiseTexRollX("NoiseTexRollX", Float) = 0
		_NoiseTexRollY("NoiseTexRollY", Float) = 0
		_NoiseTexRotSpeed("NoiseTexRotSpeed", Float) = 0
		_NoiseTexIntensity("NoiseTexIntensity", Range( 0 , 1)) = 0.25
		_RadiusTilingX("RadiusTilingX", Float) = 2
		_RadiusTilingY("RadiusTilingY", Float) = 2
		_RadiusRollX("RadiusRollX", Float) = -1
		_RadiusRollY("RadiusRollY", Float) = 0
		[Toggle(_USEMASKTEXTURE_ON)] _UseMaskTexture("UseMaskTexture", Float) = 0
		[Toggle(_USEMASKFORMAINUV_ON)] _UseMaskForMainUV("UseMaskForMainUV", Float) = 0
		[Enum(Off,0,On,1)]_MaskTexWorldUV("MaskTexWorldUV", Float) = 0
		_MaskTexture("MaskTexture", 2D) = "white" {}
		_MaskTexWorldUVScale("MaskTexWorldUVScale", Float) = 5
		_MaskTexturePannerX("MaskTexturePannerX", Float) = 0
		_MaskTexturePannerY("MaskTexturePannerY", Float) = 0
		[HDR]_EdgeColor("EdgeColor", Color) = (0,0,0,0)
		_EdgeWidth("EdgeWidth", Float) = -0.05
		[Enum(Off,0,On,1)]_DepthFade("DepthFade", Float) = 0
		_DepthFadeDistance("DepthFadeDistance", Float) = 1
		[Toggle(_USEVERTEXOFFSET_ON)] _UseVertexOffset("UseVertexOffset", Float) = 0
		[Enum(NormalVertexOffset,0,MeshCut,1)]_VertexOffset_MeshCut("VertexOffset_MeshCut", Float) = 0
		_MeshCutY("MeshCutY", Range( -5 , 5)) = 0
		[Enum(Off,0,On,1)]_CustomVertexOffsetMap("CustomVertexOffsetMap", Float) = 0
		_VertexOffsetTexture("VertexOffsetTexture", 2D) = "white" {}
		[Enum(NoiseGenerator,0,Voronoi,1)]_Noise_Voronoi("Noise_Voronoi", Float) = 0
		_VoronoiAngelSpeed("VoronoiAngelSpeed", Range( 0 , 1)) = 0
		_VertexOffsetMove_X("VertexOffsetMove_X", Float) = 0
		_VertexOffsetMove_Y("VertexOffsetMove_Y", Float) = 0
		_VertexOffsetMove_Z("VertexOffsetMove_Z", Float) = 0
		_NoiseScale("NoiseScale", Float) = 5
		_VertexOffsetIntensity("VertexOffsetIntensity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_Cull_Mode]
		ZWrite [_Z_Write]
		ZTest [_Z_Test]
		Blend [_Blend_Src] [_Blend_Dst]
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.5
		#pragma shader_feature_local _USEVERTEXOFFSET_ON
		#pragma shader_feature_local _USEMASKTEXTURE_ON
		#pragma shader_feature_local _USEMASKFORMAINUV_ON
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform int _Blend_Dst;
		uniform int _Z_Write;
		uniform int _Cull_Mode;
		uniform int _Z_Test;
		uniform int _Blend_Src;
		uniform half _VertexOffsetMove_X;
		uniform half _VertexOffsetMove_Y;
		uniform half _VertexOffsetMove_Z;
		uniform half _NoiseScale;
		uniform half _VoronoiAngelSpeed;
		uniform half _Noise_Voronoi;
		uniform sampler2D _VertexOffsetTexture;
		uniform half _CustomVertexOffsetMap;
		uniform half _VertexOffsetIntensity;
		uniform sampler2D _MainTex;
		uniform half _MainTexRollX;
		uniform half _MainTexRollY;
		uniform half _MainTexTilingX;
		uniform half _MainTexTilingY;
		uniform float4 _MainTex_ST;
		uniform sampler2D _NoiseTex;
		uniform half _NoiseTexTilingX;
		uniform half _NoiseTexTilingY;
		uniform half _NoiseTexRollX;
		uniform half _NoiseTexRollY;
		uniform float4 _NoiseTex_ST;
		uniform half _NoiseTexRotSpeed;
		uniform half _NoiseMapStyle;
		uniform half _NoiseTexIntensity;
		uniform half _NoiseTexAdd;
		uniform half _RadiusRollX;
		uniform half _RadiusRollY;
		uniform half _RadiusTilingX;
		uniform half _RadiusTilingY;
		uniform half _RadiusUVmap;
		uniform sampler2D _MaskTexture;
		uniform half _MaskTexturePannerX;
		uniform half _MaskTexturePannerY;
		uniform float4 _MaskTexture_ST;
		uniform half _MaskTexWorldUVScale;
		uniform half _MaskTexWorldUV;
		uniform half _MainTexPower;
		uniform half _OpacityStyle;
		uniform half _MeshCutY;
		uniform half _VertexOffset_MeshCut;
		uniform half _MainTexHDR;
		uniform half4 _EdgeColor;
		uniform half _EdgeWidth;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform half _DepthFadeDistance;
		uniform half _DepthFade;


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


		float2 voronoihash52( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi52( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash52( n + g );
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
			return F1;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			half4 temp_cast_0 = (0.0).xxxx;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			half3 worldToObj28 = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) ).xyz;
			half temp_output_37_0 = ( worldToObj28.x + ( _Time.y * _VertexOffsetMove_X ) );
			half temp_output_38_0 = ( worldToObj28.y + ( _Time.y * _VertexOffsetMove_Y ) );
			half3 appendResult33 = (half3(temp_output_37_0 , temp_output_38_0 , ( worldToObj28.z + ( _Time.y * _VertexOffsetMove_Z ) )));
			half simplePerlin3D35 = snoise( appendResult33*_NoiseScale );
			simplePerlin3D35 = simplePerlin3D35*0.5 + 0.5;
			half time52 = ( _Time.y * _VoronoiAngelSpeed );
			half2 voronoiSmoothId52 = 0;
			float2 coords52 = appendResult33.xy * _NoiseScale;
			float2 id52 = 0;
			float2 uv52 = 0;
			float fade52 = 0.5;
			float voroi52 = 0;
			float rest52 = 0;
			for( int it52 = 0; it52 <4; it52++ ){
			voroi52 += fade52 * voronoi52( coords52, time52, id52, uv52, 0,voronoiSmoothId52 );
			rest52 += fade52;
			coords52 *= 2;
			fade52 *= 0.5;
			}//Voronoi52
			voroi52 /= rest52;
			half lerpResult56 = lerp( simplePerlin3D35 , voroi52 , _Noise_Voronoi);
			half4 temp_cast_2 = (lerpResult56).xxxx;
			half2 appendResult227 = (half2(temp_output_37_0 , temp_output_38_0));
			half4 lerpResult229 = lerp( temp_cast_2 , tex2Dlod( _VertexOffsetTexture, float4( appendResult227, 0, 0.0) ) , _CustomVertexOffsetMap);
			half3 ase_vertexNormal = v.normal.xyz;
			half2 appendResult76 = (half2(_MainTexRollX , _MainTexRollY));
			half2 appendResult70 = (half2(_MainTexTilingX , _MainTexTilingY));
			float2 uv_TexCoord77 = v.texcoord.xy * appendResult70;
			half2 panner74 = ( 1.0 * _Time.y * appendResult76 + uv_TexCoord77);
			float2 uv_MainTex = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			half2 appendResult92 = (half2(_NoiseTexTilingX , _NoiseTexTilingY));
			half2 appendResult90 = (half2(( _Time.y * _NoiseTexRollX ) , ( _Time.y * _NoiseTexRollY )));
			float2 uv_TexCoord91 = v.texcoord.xy * appendResult92 + appendResult90;
			float2 uv_NoiseTex = v.texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float cos95 = cos( ( _Time.y * _NoiseTexRotSpeed ) );
			float sin95 = sin( ( _Time.y * _NoiseTexRotSpeed ) );
			half2 rotator95 = mul( uv_NoiseTex - half2( 0.5,0.5 ) , float2x2( cos95 , -sin95 , sin95 , cos95 )) + half2( 0.5,0.5 );
			half2 lerpResult207 = lerp( uv_TexCoord91 , rotator95 , _NoiseMapStyle);
			half2 lerpResult106 = lerp( panner74 , ( uv_MainTex + ( tex2Dlod( _NoiseTex, float4( lerpResult207, 0, 0.0) ).a * _NoiseTexIntensity ) ) , _NoiseTexAdd);
			half2 appendResult120 = (half2(_RadiusRollX , _RadiusRollY));
			half2 appendResult121 = (half2(_RadiusTilingX , _RadiusTilingY));
			float2 uv_TexCoord110 = v.texcoord.xy * appendResult121;
			half2 temp_cast_4 = (( _RadiusTilingX / 2.0 )).xx;
			half2 temp_output_111_0 = ( uv_TexCoord110 - temp_cast_4 );
			half2 temp_cast_5 = (( _RadiusTilingX / 2.0 )).xx;
			half2 break115 = temp_output_111_0;
			half2 appendResult114 = (half2(length( temp_output_111_0 ) , (0.0 + (atan2( break115.y , break115.x ) - 0.0) * (1.0 - 0.0) / (3.141593 - 0.0))));
			half2 panner122 = ( 1.0 * _Time.y * appendResult120 + appendResult114);
			half2 lerpResult276 = lerp( lerpResult106 , panner122 , _RadiusUVmap);
			half4 tex2DNode57 = tex2Dlod( _MainTex, float4( lerpResult276, 0, 0.0) );
			half2 appendResult268 = (half2(_MaskTexturePannerX , _MaskTexturePannerY));
			float2 uv_MaskTexture = v.texcoord.xy * _MaskTexture_ST.xy + _MaskTexture_ST.zw;
			half2 appendResult272 = (half2(ase_worldPos.x , ase_worldPos.y));
			half2 lerpResult246 = lerp( uv_MaskTexture , ( appendResult272 / _MaskTexWorldUVScale ) , _MaskTexWorldUV);
			half2 panner267 = ( 1.0 * _Time.y * appendResult268 + lerpResult246);
			#ifdef _USEMASKFORMAINUV_ON
				half2 staticSwitch140 = lerpResult276;
			#else
				half2 staticSwitch140 = panner267;
			#endif
			#ifdef _USEMASKTEXTURE_ON
				half staticSwitch149 = ( tex2DNode57.a * tex2Dlod( _MaskTexture, float4( staticSwitch140, 0, 0.0) ).a );
			#else
				half staticSwitch149 = tex2DNode57.a;
			#endif
			half temp_output_263_0 = saturate( pow( staticSwitch149 , _MainTexPower ) );
			half temp_output_146_0 = (0.01 + (v.color.a - 0.0) * (1.0 - 0.01) / (1.0 - 0.0));
			half DissolveNoise240 = ( temp_output_263_0 * lerpResult56 );
			half temp_output_141_0 = step( temp_output_146_0 , DissolveNoise240 );
			half lerpResult271 = lerp( ( v.color.a * temp_output_263_0 ) , temp_output_141_0 , _OpacityStyle);
			float3 ase_vertex3Pos = v.vertex.xyz;
			half4 temp_cast_6 = (( lerpResult271 * step( 1.0 , ( 1.0 - ( ase_vertex3Pos.y + _MeshCutY ) ) ) )).xxxx;
			half4 lerpResult167 = lerp( ( ( lerpResult229 * _VertexOffsetIntensity ) * half4( ase_vertexNormal , 0.0 ) ) , temp_cast_6 , _VertexOffset_MeshCut);
			half4 VertexOffset43 = lerpResult167;
			#ifdef _USEVERTEXOFFSET_ON
				half4 staticSwitch49 = VertexOffset43;
			#else
				half4 staticSwitch49 = temp_cast_0;
			#endif
			v.vertex.xyz += staticSwitch49.rgb;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			half2 appendResult76 = (half2(_MainTexRollX , _MainTexRollY));
			half2 appendResult70 = (half2(_MainTexTilingX , _MainTexTilingY));
			float2 uv_TexCoord77 = i.uv_texcoord * appendResult70;
			half2 panner74 = ( 1.0 * _Time.y * appendResult76 + uv_TexCoord77);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			half2 appendResult92 = (half2(_NoiseTexTilingX , _NoiseTexTilingY));
			half2 appendResult90 = (half2(( _Time.y * _NoiseTexRollX ) , ( _Time.y * _NoiseTexRollY )));
			float2 uv_TexCoord91 = i.uv_texcoord * appendResult92 + appendResult90;
			float2 uv_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float cos95 = cos( ( _Time.y * _NoiseTexRotSpeed ) );
			float sin95 = sin( ( _Time.y * _NoiseTexRotSpeed ) );
			half2 rotator95 = mul( uv_NoiseTex - half2( 0.5,0.5 ) , float2x2( cos95 , -sin95 , sin95 , cos95 )) + half2( 0.5,0.5 );
			half2 lerpResult207 = lerp( uv_TexCoord91 , rotator95 , _NoiseMapStyle);
			half2 lerpResult106 = lerp( panner74 , ( uv_MainTex + ( tex2D( _NoiseTex, lerpResult207 ).a * _NoiseTexIntensity ) ) , _NoiseTexAdd);
			half2 appendResult120 = (half2(_RadiusRollX , _RadiusRollY));
			half2 appendResult121 = (half2(_RadiusTilingX , _RadiusTilingY));
			float2 uv_TexCoord110 = i.uv_texcoord * appendResult121;
			half2 temp_cast_0 = (( _RadiusTilingX / 2.0 )).xx;
			half2 temp_output_111_0 = ( uv_TexCoord110 - temp_cast_0 );
			half2 temp_cast_1 = (( _RadiusTilingX / 2.0 )).xx;
			half2 break115 = temp_output_111_0;
			half2 appendResult114 = (half2(length( temp_output_111_0 ) , (0.0 + (atan2( break115.y , break115.x ) - 0.0) * (1.0 - 0.0) / (3.141593 - 0.0))));
			half2 panner122 = ( 1.0 * _Time.y * appendResult120 + appendResult114);
			half2 lerpResult276 = lerp( lerpResult106 , panner122 , _RadiusUVmap);
			half4 tex2DNode57 = tex2D( _MainTex, lerpResult276 );
			half temp_output_146_0 = (0.01 + (i.vertexColor.a - 0.0) * (1.0 - 0.01) / (1.0 - 0.0));
			half2 appendResult268 = (half2(_MaskTexturePannerX , _MaskTexturePannerY));
			float2 uv_MaskTexture = i.uv_texcoord * _MaskTexture_ST.xy + _MaskTexture_ST.zw;
			float3 ase_worldPos = i.worldPos;
			half2 appendResult272 = (half2(ase_worldPos.x , ase_worldPos.y));
			half2 lerpResult246 = lerp( uv_MaskTexture , ( appendResult272 / _MaskTexWorldUVScale ) , _MaskTexWorldUV);
			half2 panner267 = ( 1.0 * _Time.y * appendResult268 + lerpResult246);
			#ifdef _USEMASKFORMAINUV_ON
				half2 staticSwitch140 = lerpResult276;
			#else
				half2 staticSwitch140 = panner267;
			#endif
			#ifdef _USEMASKTEXTURE_ON
				half staticSwitch149 = ( tex2DNode57.a * tex2D( _MaskTexture, staticSwitch140 ).a );
			#else
				half staticSwitch149 = tex2DNode57.a;
			#endif
			half temp_output_263_0 = saturate( pow( staticSwitch149 , _MainTexPower ) );
			half3 worldToObj28 = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) ).xyz;
			half temp_output_37_0 = ( worldToObj28.x + ( _Time.y * _VertexOffsetMove_X ) );
			half temp_output_38_0 = ( worldToObj28.y + ( _Time.y * _VertexOffsetMove_Y ) );
			half3 appendResult33 = (half3(temp_output_37_0 , temp_output_38_0 , ( worldToObj28.z + ( _Time.y * _VertexOffsetMove_Z ) )));
			half simplePerlin3D35 = snoise( appendResult33*_NoiseScale );
			simplePerlin3D35 = simplePerlin3D35*0.5 + 0.5;
			half time52 = ( _Time.y * _VoronoiAngelSpeed );
			half2 voronoiSmoothId52 = 0;
			float2 coords52 = appendResult33.xy * _NoiseScale;
			float2 id52 = 0;
			float2 uv52 = 0;
			float fade52 = 0.5;
			float voroi52 = 0;
			float rest52 = 0;
			for( int it52 = 0; it52 <4; it52++ ){
			voroi52 += fade52 * voronoi52( coords52, time52, id52, uv52, 0,voronoiSmoothId52 );
			rest52 += fade52;
			coords52 *= 2;
			fade52 *= 0.5;
			}//Voronoi52
			voroi52 /= rest52;
			half lerpResult56 = lerp( simplePerlin3D35 , voroi52 , _Noise_Voronoi);
			half DissolveNoise240 = ( temp_output_263_0 * lerpResult56 );
			half temp_output_141_0 = step( temp_output_146_0 , DissolveNoise240 );
			o.Emission = ( ( i.vertexColor * tex2DNode57 * _MainTexHDR ) + ( _EdgeColor * saturate( ( temp_output_141_0 - step( ( temp_output_146_0 - _EdgeWidth ) , DissolveNoise240 ) ) ) ) ).rgb;
			half lerpResult271 = lerp( ( i.vertexColor.a * temp_output_263_0 ) , temp_output_141_0 , _OpacityStyle);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			half4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth169 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half distanceDepth169 = abs( ( screenDepth169 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeDistance ) );
			half lerpResult177 = lerp( lerpResult271 , ( lerpResult271 * saturate( distanceDepth169 ) ) , _DepthFade);
			o.Alpha = lerpResult177;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18934
2560;0;2560;1419;337.7642;482.8812;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;125;-4029.912,-81.34972;Inherit;False;1625.531;424.0091;TexRadius;15;121;124;110;111;115;116;117;113;120;114;122;212;213;214;215;TexRadius;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;108;-3686.95,-622.5746;Inherit;False;1576.95;527.0999;TextureNoisePart;22;96;97;92;90;127;95;207;85;104;100;101;208;105;91;98;89;88;86;220;221;222;223;TextureNoisePart;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;214;-3983.121,-15.46767;Inherit;False;Property;_RadiusTilingX;RadiusTilingX;24;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;215;-3982.121,64.5324;Inherit;False;Property;_RadiusTilingY;RadiusTilingY;25;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;86;-3663.05,-572.276;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;222;-3658.668,-228.0056;Inherit;False;Property;_NoiseTexRollY;NoiseTexRollY;21;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-3656.668,-296.0056;Inherit;False;Property;_NoiseTexRollX;NoiseTexRollX;20;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-3429.043,-504.3363;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;221;-3659.668,-435.0056;Inherit;False;Property;_NoiseTexTilingX;NoiseTexTilingX;18;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-3670.937,-168.5747;Inherit;False;Property;_NoiseTexRotSpeed;NoiseTexRotSpeed;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;220;-3659.668,-366.0056;Inherit;False;Property;_NoiseTexTilingY;NoiseTexTilingY;19;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;121;-3748.829,-1.685673;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-3430.975,-403.849;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;124;-3558.482,97.75976;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;127;-3290.255,-370.7836;Inherit;False;0;85;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-3387.937,-233.5747;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;96;-3256.937,-236.5748;Inherit;False;Constant;_Vector0;Vector 0;22;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;90;-3270.937,-467.5747;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;110;-3598.813,-31.34977;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;92;-3273.937,-580.5747;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;91;-3113.937,-559.5747;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;111;-3371.813,4.650233;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;102;-3076.943,-1157.374;Inherit;False;968.1578;520.672;TextureRollPart;9;83;74;219;218;77;217;216;70;76;TextureRollPart;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;208;-3054.885,-228.1915;Inherit;False;Property;_NoiseMapStyle;NoiseMapStyle;16;1;[Enum];Create;True;0;2;Panner;0;Rotator;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;95;-3070.937,-373.5748;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;217;-2936.493,-1039.89;Inherit;False;Property;_MainTexTilingY;MainTexTilingY;11;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;216;-2936.493,-1112.89;Inherit;False;Property;_MainTexTilingX;MainTexTilingX;10;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;23;-2628.511,607.3979;Inherit;False;1940.291;833.3716;VertexOffset;39;165;166;160;163;162;161;43;167;168;42;45;44;229;41;228;231;56;55;35;52;227;54;33;31;37;53;38;30;26;29;28;27;24;32;46;25;39;240;249;VertexOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;115;-3247.813,90.65022;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LerpOp;207;-2900.985,-470.1915;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;85;-2754.937,-484.5748;Inherit;True;Property;_NoiseTex;NoiseTex;17;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;219;-2929.443,-969.9551;Inherit;False;Property;_MainTexRollX;MainTexRollX;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;70;-2755.578,-1068.655;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;218;-2927.443,-893.9568;Inherit;False;Property;_MainTexRollY;MainTexRollY;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;24;-2611.832,664.0629;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;101;-2607.2,-265.0896;Inherit;False;Property;_NoiseTexIntensity;NoiseTexIntensity;23;0;Create;True;0;0;0;False;0;False;0.25;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;116;-3023.813,90.65024;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;-2674.842,-901.5621;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;274;-2360.11,297.2737;Inherit;False;Property;_MaskTexWorldUVScale;MaskTexWorldUVScale;32;0;Create;True;0;2;Off;0;On;1;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;272;-2337.912,166.4805;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;77;-2605.519,-1040.092;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;104;-2471.611,-560.408;Inherit;False;0;57;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-2332.7,-369.7897;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;113;-3151.813,5.650235;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;212;-3977.121,168.5322;Inherit;False;Property;_RadiusRollX;RadiusRollX;26;0;Create;True;0;0;0;False;0;False;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;117;-2906.813,114.6501;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;3.141593;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;213;-3975.121,246.5322;Inherit;False;Property;_RadiusRollY;RadiusRollY;27;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;270;-2330.805,522.1132;Inherit;False;Property;_MaskTexturePannerY;MaskTexturePannerY;34;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;245;-2315.215,376.0904;Inherit;False;Property;_MaskTexWorldUV;MaskTexWorldUV;30;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;273;-2186.11,182.2737;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;74;-2334.579,-953.1739;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;138;-2317.345,41.68089;Inherit;False;0;137;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;105;-2225.412,-526.208;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;114;-2773.812,3.650233;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;269;-2328.805,448.1132;Inherit;False;Property;_MaskTexturePannerX;MaskTexturePannerX;33;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;120;-3557.614,195.6591;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-2106.005,-449.7609;Inherit;False;Property;_NoiseTexAdd;NoiseTexAdd;15;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;275;-2001.146,-130.8348;Inherit;False;Property;_RadiusUVmap;RadiusUVmap;7;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;122;-2609.382,31.25978;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;246;-2056.047,134.4548;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;106;-1944.113,-551.608;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;268;-2044.778,263.4777;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;276;-1781.846,-325.6349;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;267;-1900.662,151.5935;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;39;-2608.256,828.6816;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;46;-2574.511,1053.698;Inherit;False;Property;_VertexOffsetMove_Y;VertexOffsetMove_Y;47;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2552.511,1134.698;Inherit;False;Property;_VertexOffsetMove_Z;VertexOffsetMove_Z;48;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;140;-1721.97,150.9937;Inherit;False;Property;_UseMaskForMainUV;UseMaskForMainUV;29;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2615.511,976.6996;Inherit;False;Property;_VertexOffsetMove_X;VertexOffsetMove_X;46;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;28;-2439.484,658.6719;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-2378.248,808.6215;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;57;-1518.45,-352.1451;Inherit;True;Property;_MainTex;MainTex;6;0;Create;True;0;0;0;False;0;False;-1;None;0d5daac6a11cdaf44917f9378075b00c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-2367.18,909.1085;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2332.87,1011.375;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;137;-1462.475,142.2347;Inherit;True;Property;_MaskTexture;MaskTexture;31;0;Create;True;0;0;0;False;0;False;-1;None;80871ffc6a078314d8e04e5686fa15ee;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-2193.871,911.3745;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-2213.291,698.8586;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-1174.144,19.00532;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-2201.155,804.5135;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2314.993,1128.073;Inherit;False;Property;_VoronoiAngelSpeed;VoronoiAngelSpeed;45;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-2022.909,725.4626;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-2013.59,965.7435;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2033.183,854.2396;Inherit;False;Property;_NoiseScale;NoiseScale;49;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;149;-1186.145,-244.4751;Inherit;False;Property;_UseMaskTexture;UseMaskTexture;28;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;261;-1124.982,-132.667;Inherit;False;Property;_MainTexPower;MainTexPower;9;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;52;-1822.62,971.2365;Inherit;False;0;0;1;0;4;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.PowerNode;262;-942.9822,-193.667;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-1819.341,1132.375;Inherit;False;Property;_Noise_Voronoi;Noise_Voronoi;44;1;[Enum];Create;True;0;2;NoiseGenerator;0;Voronoi;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;35;-1827.55,868.3105;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;56;-1580.875,975.7895;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;263;-797.8359,-192.3455;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;249;-1380.259,981.9545;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;83;-2924.566,-809.7845;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;162;-2171.441,1357.308;Inherit;False;Property;_MeshCutY;MeshCutY;41;0;Create;True;0;0;0;False;0;False;0;0;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;161;-2094.935,1209.929;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;227;-1900.045,647.7065;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;240;-1215.747,1004.179;Inherit;False;DissolveNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;163;-1890.354,1244.183;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;231;-1625.111,861.0175;Inherit;False;Property;_CustomVertexOffsetMap;CustomVertexOffsetMap;42;1;[Enum];Create;True;0;2;Off;0;On;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;146;-1014.329,-48.94891;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.01;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;228;-1745.047,658.7065;Inherit;True;Property;_VertexOffsetTexture;VertexOffsetTexture;43;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;241;-1032.691,136.8795;Inherit;False;240;DissolveNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;247;-678.458,-290.1993;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1583.483,1117.385;Inherit;False;Property;_VertexOffsetIntensity;VertexOffsetIntensity;50;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;-698.1446,212.88;Inherit;False;Property;_EdgeWidth;EdgeWidth;36;0;Create;True;0;0;0;False;0;False;-0.05;-0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;148;-784.2394,53.29028;Inherit;False;Property;_OpacityStyle;OpacityStyle;12;1;[Enum];Create;True;0;2;SoftOpacity;0;ClipOpacity;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;229;-1348.686,730.6125;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;160;-1756.207,1267.098;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;141;-741.9581,-43.59256;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1158.008,764.1226;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;151;-516.0066,161.8911;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;166;-1579.893,1241.079;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;271;-481.1906,-141.7211;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;44;-1088.006,853.7026;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-896.1569,766.5516;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;152;-320.912,69.5669;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-1254.045,1334.419;Inherit;False;Property;_VertexOffset_MeshCut;VertexOffset_MeshCut;40;1;[Enum];Create;True;0;2;NormalVertexOffset;0;MeshCut;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;170;-359.5639,317.1515;Inherit;False;Property;_DepthFadeDistance;DepthFadeDistance;38;0;Create;True;0;0;0;False;0;False;1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-1389.647,1247.046;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;169;-128.5638,285.1515;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;167;-1067.013,1129.848;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;154;-192.564,-2.20771;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;257;-35.46539,8.16151;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;-171.0577,-237.5203;Inherit;False;Property;_MainTexHDR;MainTexHDR;8;0;Create;True;0;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-896.9219,1141.607;Inherit;False;VertexOffset;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;175;133.436,302.9515;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;157;67.3111,-179.9733;Inherit;False;Property;_EdgeColor;EdgeColor;35;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;176;295.0359,352.1515;Inherit;False;Property;_DepthFade;DepthFade;37;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;3;943.5273,266.2357;Inherit;False;356;166;Depth;2;14;12;Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;306.8111,-89.47335;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;50;184.7,445.3;Inherit;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;312.9359,238.2515;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;-10.61828,-330.0288;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;152.7,525.2999;Inherit;False;43;VertexOffset;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1;943.5275,-109.7639;Inherit;False;225;166;Cull Mode;1;13;Cull Mode;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;5;943.5273,89.23524;Inherit;False;372;143;BlendMode;2;8;6;BlendMode;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;159;473.5655,-137.6596;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;177;490.936,208.8515;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;49;328.7001,461.3;Inherit;False;Property;_UseVertexOffset;UseVertexOffset;39;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;6;993.5275,140.2354;Inherit;False;Property;_Blend_Src;Blend_Src;2;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;13;993.5274,-59.76408;Inherit;False;Property;_Cull_Mode;Cull_Mode;1;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;12;993.5275,316.2359;Inherit;False;Property;_Z_Write;Z_Write;4;1;[Enum];Create;True;0;2;On;1;Off;0;0;True;0;False;1;1;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;8;1137.527,139.2354;Inherit;False;Property;_Blend_Dst;Blend_Dst;3;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;1;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;14;1135.527,315.2359;Inherit;False;Property;_Z_Test;Z_Test;5;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;718.2001,24.7;Half;False;True;-1;3;ASEMaterialInspector;0;0;Unlit;Koakuma/VFX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;True;12;0;True;14;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;True;6;10;True;8;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;13;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;88;0;86;2
WireConnection;88;1;223;0
WireConnection;121;0;214;0
WireConnection;121;1;215;0
WireConnection;89;0;86;2
WireConnection;89;1;222;0
WireConnection;124;0;214;0
WireConnection;98;0;86;2
WireConnection;98;1;97;0
WireConnection;90;0;88;0
WireConnection;90;1;89;0
WireConnection;110;0;121;0
WireConnection;92;0;221;0
WireConnection;92;1;220;0
WireConnection;91;0;92;0
WireConnection;91;1;90;0
WireConnection;111;0;110;0
WireConnection;111;1;124;0
WireConnection;95;0;127;0
WireConnection;95;1;96;0
WireConnection;95;2;98;0
WireConnection;115;0;111;0
WireConnection;207;0;91;0
WireConnection;207;1;95;0
WireConnection;207;2;208;0
WireConnection;85;1;207;0
WireConnection;70;0;216;0
WireConnection;70;1;217;0
WireConnection;116;0;115;1
WireConnection;116;1;115;0
WireConnection;76;0;219;0
WireConnection;76;1;218;0
WireConnection;272;0;24;1
WireConnection;272;1;24;2
WireConnection;77;0;70;0
WireConnection;100;0;85;4
WireConnection;100;1;101;0
WireConnection;113;0;111;0
WireConnection;117;0;116;0
WireConnection;273;0;272;0
WireConnection;273;1;274;0
WireConnection;74;0;77;0
WireConnection;74;2;76;0
WireConnection;105;0;104;0
WireConnection;105;1;100;0
WireConnection;114;0;113;0
WireConnection;114;1;117;0
WireConnection;120;0;212;0
WireConnection;120;1;213;0
WireConnection;122;0;114;0
WireConnection;122;2;120;0
WireConnection;246;0;138;0
WireConnection;246;1;273;0
WireConnection;246;2;245;0
WireConnection;106;0;74;0
WireConnection;106;1;105;0
WireConnection;106;2;107;0
WireConnection;268;0;269;0
WireConnection;268;1;270;0
WireConnection;276;0;106;0
WireConnection;276;1;122;0
WireConnection;276;2;275;0
WireConnection;267;0;246;0
WireConnection;267;2;268;0
WireConnection;140;1;267;0
WireConnection;140;0;276;0
WireConnection;28;0;24;0
WireConnection;26;0;39;2
WireConnection;26;1;32;0
WireConnection;57;1;276;0
WireConnection;27;0;39;2
WireConnection;27;1;46;0
WireConnection;29;0;39;2
WireConnection;29;1;25;0
WireConnection;137;1;140;0
WireConnection;30;0;28;3
WireConnection;30;1;29;0
WireConnection;37;0;28;1
WireConnection;37;1;26;0
WireConnection;139;0;57;4
WireConnection;139;1;137;4
WireConnection;38;0;28;2
WireConnection;38;1;27;0
WireConnection;33;0;37;0
WireConnection;33;1;38;0
WireConnection;33;2;30;0
WireConnection;54;0;39;2
WireConnection;54;1;53;0
WireConnection;149;1;57;4
WireConnection;149;0;139;0
WireConnection;52;0;33;0
WireConnection;52;1;54;0
WireConnection;52;2;31;0
WireConnection;262;0;149;0
WireConnection;262;1;261;0
WireConnection;35;0;33;0
WireConnection;35;1;31;0
WireConnection;56;0;35;0
WireConnection;56;1;52;0
WireConnection;56;2;55;0
WireConnection;263;0;262;0
WireConnection;249;0;263;0
WireConnection;249;1;56;0
WireConnection;227;0;37;0
WireConnection;227;1;38;0
WireConnection;240;0;249;0
WireConnection;163;0;161;2
WireConnection;163;1;162;0
WireConnection;146;0;83;4
WireConnection;228;1;227;0
WireConnection;247;0;83;4
WireConnection;247;1;263;0
WireConnection;229;0;56;0
WireConnection;229;1;228;0
WireConnection;229;2;231;0
WireConnection;160;0;163;0
WireConnection;141;0;146;0
WireConnection;141;1;241;0
WireConnection;45;0;229;0
WireConnection;45;1;41;0
WireConnection;151;0;146;0
WireConnection;151;1;153;0
WireConnection;166;1;160;0
WireConnection;271;0;247;0
WireConnection;271;1;141;0
WireConnection;271;2;148;0
WireConnection;42;0;45;0
WireConnection;42;1;44;0
WireConnection;152;0;151;0
WireConnection;152;1;241;0
WireConnection;165;0;271;0
WireConnection;165;1;166;0
WireConnection;169;0;170;0
WireConnection;167;0;42;0
WireConnection;167;1;165;0
WireConnection;167;2;168;0
WireConnection;154;0;141;0
WireConnection;154;1;152;0
WireConnection;257;0;154;0
WireConnection;43;0;167;0
WireConnection;175;0;169;0
WireConnection;156;0;157;0
WireConnection;156;1;257;0
WireConnection;171;0;271;0
WireConnection;171;1;175;0
WireConnection;158;0;83;0
WireConnection;158;1;57;0
WireConnection;158;2;259;0
WireConnection;159;0;158;0
WireConnection;159;1;156;0
WireConnection;177;0;271;0
WireConnection;177;1;171;0
WireConnection;177;2;176;0
WireConnection;49;1;50;0
WireConnection;49;0;51;0
WireConnection;0;2;159;0
WireConnection;0;9;177;0
WireConnection;0;11;49;0
ASEEND*/
//CHKSM=8333B0E39B1EB3F1D8F0BC58334BF1ED1570C616