// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/Character"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_Mode", Int) = 2
		[Toggle(_USEMAINTEXWORLDUV_ON)] _UseMainTexWorldUV("UseMainTexWorldUV", Float) = 0
		[Enum(Off,0,On,1)]_UseMainTexture("UseMainTexture", Float) = 1
		_MainTex("MainTex", 2D) = "white" {}
		_MainTexColor("MainTexColor", Color) = (1,1,1,1)
		_TexEmission("TexEmission", Range( 0 , 5)) = 1
		_WorldMainTexTiling("WorldMainTexTiling", Float) = 1
		_WorldMainTextureRollX("WorldMainTextureRollX", Float) = 0
		_WorldMainTextureRollY("WorldMainTextureRollY", Float) = 0
		_Desaturate("Desaturate", Range( 0 , 1)) = 0
		[Toggle(_USEMASKEMISSIONTEXTURE_ON)] _UseMaskEmissionTexture("UseMaskEmissionTexture", Float) = 0
		_MaskEmissionTexture("MaskEmissionTexture", 2D) = "white" {}
		_MaskEmissionTexColor("MaskEmissionTexColor", Color) = (0.6862745,0.6862745,0.6862745,1)
		_MaskColorHDR("MaskColorHDR", Float) = 1
		_MaskPower("MaskPower", Float) = 2
		[Enum(Off,0,On,1)]_MaskEmissionNoise("MaskEmissionNoise", Float) = 1
		_MaskEmissionNoiseRollX("MaskEmissionNoiseRollX", Float) = 0
		_MaskEmissionNoiseRollY("MaskEmissionNoiseRollY", Float) = 0
		_MaskEmissionNoiseScale("MaskEmissionNoiseScale", Float) = 5
		_MaskEmissionRadius("MaskEmissionRadius", Range( 0 , 1)) = 0.5
		_LightDir("LightDir", Range( -1 , 1)) = 0
		_ShadowSmooth("ShadowSmooth", Range( 0 , 1)) = 0
		_ShadowIntensity("ShadowIntensity", Range( 0 , 1)) = 0.75
		_RimLightColor("RimLightColor", Color) = (0.3921569,0.3921569,0.3921569,0)
		_RimLightDir("RimLightDir", Range( -1 , 1)) = 0
		_RimSmooth("RimSmooth", Range( 0 , 1)) = 0
		[HDR]_FresnelColor("FresnelColor", Color) = (0,0,0,0)
		_FrenelScale("FrenelScale", Float) = 2
		_FrenelPower("FrenelPower", Float) = 5
		_NoiseRoll_X("NoiseRoll_X", Float) = 0
		_NoiseRoll_Y("NoiseRoll_Y", Float) = 0
		_NoiseRoll_Z("NoiseRoll_Z", Float) = 0
		_OnHitRange("OnHitRange", Range( 0 , 1)) = 0
		[Enum(TexClip,0,DissolveClip,1)]_TexClipStyle("TexClipStyle", Float) = 0
		[Toggle(_USETEXTUREDISSOLVE_ON)] _UseTextureDissolve("UseTextureDissolve", Float) = 0
		[Enum(Horizontal,0,Vertical,1)]_DissolveTexDir("DissolveTexDir", Float) = 1
		[Enum(Off,0,On,1)]_DissolveTexDirMinus("DissolveTexDirMinus", Float) = 0
		_NoiseScale("NoiseScale", Float) = 5
		_Dissolve("Dissolve", Range( 0 , 1)) = 0
		[Toggle(_USETEXTUREDEDGELIGHT_ON)] _UseTexturedEdgeLight("UseTexturedEdgeLight", Float) = 0
		[HDR]_EdgeColor("EdgeColor", Color) = (1,0.5294118,0,0)
		_EdgeWidth("EdgeWidth", Float) = -0.05
		[Toggle(_USEVERTEXOFFSET_ON)] _UseVertexOffset("UseVertexOffset", Float) = 0
		[Enum(On,0,Off,1)]_VertexOffsetWorldPos("VertexOffsetWorldPos", Float) = 1
		_VertexOffsetMove_X("VertexOffsetMove_X", Float) = 0
		_VertexOffsetMove_Y("VertexOffsetMove_Y", Float) = 0
		_VertexOffsetMove_Z("VertexOffsetMove_Z", Float) = 0
		_VertexOffsetScale("VertexOffsetScale", Float) = 5
		[Enum(Off,0,On,1)]_CustomVertexOffsetMask("CustomVertexOffsetMask", Float) = 0
		[Enum(Y Axis,0,Z Axis,1)]_VertexOffsetMaskAxis("VertexOffsetMaskAxis", Float) = 0
		[Enum(Off,0,On,1)]_VertexOffsetMaskMinus("VertexOffsetMaskMinus", Float) = 0
		_VertexOffsetMaskPos("VertexOffsetMaskPos", Float) = 0
		_VertexOffsetMaskSmooth("VertexOffsetMaskSmooth", Range( 0 , 5)) = 1
		_VertexOffsetIntensity("VertexOffsetIntensity", Range( 0 , 1)) = 1
		[Toggle(_USEAO_ON)] _UseAO("UseAO", Float) = 0
		[Enum(Off,0,On,1)]_AO_WorldPos("AO_WorldPos", Float) = 0
		[Enum(Axis Y,0,Axis Z,1)]_AODirection("AODirection", Float) = 0
		[Enum(Off,0,On,1)]_AOAxisMinus("AOAxisMinus", Float) = 1
		_AOposition("AOposition", Float) = 0
		_AOsmooth("AOsmooth", Range( 0 , 1)) = 1
		_AOIntensity("AOIntensity", Range( -1 , 1)) = -0.35
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull [_Cull_Mode]
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USETEXTUREDISSOLVE_ON
		#pragma shader_feature_local _USEVERTEXOFFSET_ON
		#pragma shader_feature_local _USEMASKEMISSIONTEXTURE_ON
		#pragma shader_feature_local _USETEXTUREDEDGELIGHT_ON
		#pragma shader_feature_local _USEMAINTEXWORLDUV_ON
		#pragma shader_feature_local _USEAO_ON
		struct Input
		{
			float3 worldPos;
			half3 worldNormal;
			float2 uv_texcoord;
		};

		uniform int _Cull_Mode;
		uniform half _VertexOffsetWorldPos;
		uniform half _VertexOffsetMove_X;
		uniform half _VertexOffsetMove_Y;
		uniform half _VertexOffsetMove_Z;
		uniform half _VertexOffsetScale;
		uniform half _VertexOffsetMaskSmooth;
		uniform half _VertexOffsetMaskAxis;
		uniform half _VertexOffsetMaskPos;
		uniform half _VertexOffsetMaskMinus;
		uniform sampler2D _MaskEmissionTexture;
		uniform half4 _MaskEmissionTexture_ST;
		uniform half _MaskEmissionRadius;
		uniform half _CustomVertexOffsetMask;
		uniform half _VertexOffsetIntensity;
		uniform half _FrenelScale;
		uniform half _FrenelPower;
		uniform half4 _FresnelColor;
		uniform half _OnHitRange;
		uniform half _MaskEmissionNoiseRollX;
		uniform half _MaskEmissionNoiseRollY;
		uniform half _MaskEmissionNoiseScale;
		uniform half _MaskEmissionNoise;
		uniform half _MaskPower;
		uniform half4 _MaskEmissionTexColor;
		uniform half _MaskColorHDR;
		uniform half _Dissolve;
		uniform half _NoiseRoll_X;
		uniform half _NoiseRoll_Y;
		uniform half _NoiseRoll_Z;
		uniform half _NoiseScale;
		uniform half _EdgeWidth;
		uniform half _DissolveTexDir;
		uniform half _DissolveTexDirMinus;
		uniform half4 _EdgeColor;
		uniform half _ShadowIntensity;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform half _WorldMainTextureRollX;
		uniform half _WorldMainTextureRollY;
		uniform half _WorldMainTexTiling;
		uniform half _UseMainTexture;
		uniform half _Desaturate;
		uniform half4 _MainTexColor;
		uniform half _ShadowSmooth;
		uniform half _LightDir;
		uniform half4 _RimLightColor;
		uniform half _RimSmooth;
		uniform half _RimLightDir;
		uniform half _AOIntensity;
		uniform half _AOsmooth;
		uniform half _AO_WorldPos;
		uniform half _AODirection;
		uniform half _AOposition;
		uniform half _AOAxisMinus;
		uniform half _TexEmission;
		uniform half _TexClipStyle;
		uniform float _Cutoff = 0.5;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			half3 temp_cast_0 = (0.0).xxx;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			half3 worldToObj69 = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) ).xyz;
			half3 lerpResult268 = lerp( ase_worldPos , worldToObj69 , _VertexOffsetWorldPos);
			half3 break267 = lerpResult268;
			half3 appendResult84 = (half3(( break267.x + ( _Time.y * _VertexOffsetMove_X ) ) , ( break267.y + ( _Time.y * _VertexOffsetMove_Y ) ) , ( break267.z + ( _Time.y * _VertexOffsetMove_Z ) )));
			half simplePerlin3D98 = snoise( appendResult84*_VertexOffsetScale );
			simplePerlin3D98 = simplePerlin3D98*0.5 + 0.5;
			half lerpResult232 = lerp( worldToObj69.y , worldToObj69.z , _VertexOffsetMaskAxis);
			half smoothstepResult236 = smoothstep( 0.0 , _VertexOffsetMaskSmooth , ( lerpResult232 + _VertexOffsetMaskPos ));
			half lerpResult234 = lerp( smoothstepResult236 , ( 1.0 - smoothstepResult236 ) , _VertexOffsetMaskMinus);
			half VertexOffsetMask240 = lerpResult234;
			float2 uv_MaskEmissionTexture = v.texcoord * _MaskEmissionTexture_ST.xy + _MaskEmissionTexture_ST.zw;
			half temp_output_346_0 = saturate( ( tex2Dlod( _MaskEmissionTexture, float4( uv_MaskEmissionTexture, 0, 0.0) ).r + (-1.0 + (_MaskEmissionRadius - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) );
			half lerpResult348 = lerp( VertexOffsetMask240 , temp_output_346_0 , _CustomVertexOffsetMask);
			half3 ase_vertexNormal = v.normal.xyz;
			half3 VertexOffset35 = ( ( ( simplePerlin3D98 * lerpResult348 ) * _VertexOffsetIntensity ) * ase_vertexNormal );
			#ifdef _USEVERTEXOFFSET_ON
				half3 staticSwitch140 = VertexOffset35;
			#else
				half3 staticSwitch140 = temp_cast_0;
			#endif
			v.vertex.xyz += staticSwitch140;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			half3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			half3 ase_worldNormal = i.worldNormal;
			half fresnelNdotV99 = dot( ase_worldNormal, ase_worldViewDir );
			half fresnelNode99 = ( 0.0 + _FrenelScale * pow( 1.0 - fresnelNdotV99, _FrenelPower ) );
			half4 Fresnel132 = ( ( saturate( fresnelNode99 ) * _FresnelColor ) * _OnHitRange );
			half4 temp_cast_0 = (0.0).xxxx;
			float2 uv_MaskEmissionTexture = i.uv_texcoord * _MaskEmissionTexture_ST.xy + _MaskEmissionTexture_ST.zw;
			half temp_output_346_0 = saturate( ( tex2D( _MaskEmissionTexture, uv_MaskEmissionTexture ).r + (-1.0 + (_MaskEmissionRadius - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) );
			half2 appendResult24 = (half2(( _Time.y * _MaskEmissionNoiseRollX ) , ( _Time.y * _MaskEmissionNoiseRollY )));
			float2 uv_TexCoord25 = i.uv_texcoord + appendResult24;
			half simplePerlin3D27 = snoise( half3( uv_TexCoord25 ,  0.0 )*_MaskEmissionNoiseScale );
			simplePerlin3D27 = simplePerlin3D27*0.5 + 0.5;
			half lerpResult341 = lerp( 1.0 , simplePerlin3D27 , _MaskEmissionNoise);
			#ifdef _USEMASKEMISSIONTEXTURE_ON
				half4 staticSwitch33 = ( pow( ( temp_output_346_0 * lerpResult341 ) , _MaskPower ) * _MaskEmissionTexColor * _MaskColorHDR );
			#else
				half4 staticSwitch33 = temp_cast_0;
			#endif
			half4 MaskEmission34 = staticSwitch33;
			half temp_output_108_0 = (-0.075 + (_Dissolve - 0.0) * (1.05 - -0.075) / (1.0 - 0.0));
			half3 worldToObj89 = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) ).xyz;
			half3 appendResult115 = (half3(( worldToObj89.x + ( _Time.y * _NoiseRoll_X ) ) , ( worldToObj89.y + ( _Time.y * _NoiseRoll_Y ) ) , ( worldToObj89.z + ( _Time.y * _NoiseRoll_Z ) )));
			half simplePerlin3D125 = snoise( appendResult115*_NoiseScale );
			simplePerlin3D125 = simplePerlin3D125*0.5 + 0.5;
			half temp_output_128_0 = step( temp_output_108_0 , simplePerlin3D125 );
			half lerpResult203 = lerp( i.uv_texcoord.x , i.uv_texcoord.y , _DissolveTexDir);
			half lerpResult204 = lerp( lerpResult203 , ( 1.0 - lerpResult203 ) , _DissolveTexDirMinus);
			half temp_output_126_0 = step( temp_output_108_0 , lerpResult204 );
			#ifdef _USETEXTUREDEDGELIGHT_ON
				half staticSwitch171 = ( temp_output_126_0 - step( ( temp_output_108_0 - _EdgeWidth ) , lerpResult204 ) );
			#else
				half staticSwitch171 = ( temp_output_128_0 - step( ( temp_output_108_0 - _EdgeWidth ) , simplePerlin3D125 ) );
			#endif
			half4 EdgeLight174 = ( saturate( staticSwitch171 ) * _EdgeColor );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			half4 ase_lightColor = 0;
			#else //aselc
			half4 ase_lightColor = _LightColor0;
			#endif //aselc
			half4 temp_cast_2 = (1.0).xxxx;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			half2 appendResult44 = (half2(( ase_worldPos.x + ( _Time.y * _WorldMainTextureRollX ) ) , ( ase_worldPos.y + ( _Time.y * _WorldMainTextureRollY ) )));
			#ifdef _USEMAINTEXWORLDUV_ON
				half2 staticSwitch49 = ( appendResult44 / _WorldMainTexTiling );
			#else
				half2 staticSwitch49 = uv_MainTex;
			#endif
			half4 tex2DNode54 = tex2D( _MainTex, staticSwitch49 );
			half4 lerpResult212 = lerp( temp_cast_2 , tex2DNode54 , _UseMainTexture);
			half3 desaturateInitialColor61 = lerpResult212.rgb;
			half desaturateDot61 = dot( desaturateInitialColor61, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar61 = lerp( desaturateInitialColor61, desaturateDot61.xxx, _Desaturate );
			half4 temp_output_146_0 = ( half4( desaturateVar61 , 0.0 ) * _MainTexColor );
			half3 ase_normWorldNormal = normalize( ase_worldNormal );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			half3 ase_worldlightDir = 0;
			#else //aseld
			half3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			half dotResult143 = dot( ase_normWorldNormal , ase_worldlightDir );
			half smoothstepResult152 = smoothstep( 0.0 , _ShadowSmooth , ( dotResult143 + _LightDir ));
			half MainLight149 = smoothstepResult152;
			half4 lerpResult145 = lerp( ( _ShadowIntensity * temp_output_146_0 ) , temp_output_146_0 , MainLight149);
			half4 MainTexture144 = lerpResult145;
			half dotResult52 = dot( ase_normWorldNormal , ase_worldViewDir );
			half smoothstepResult62 = smoothstep( 0.0 , _RimSmooth , ( dotResult52 + _RimLightDir ));
			half4 lerpResult158 = lerp( ( half4( desaturateVar61 , 0.0 ) * _RimLightColor ) , float4( 0,0,0,0 ) , smoothstepResult62);
			half4 BlinnLight75 = lerpResult158;
			half4 temp_cast_7 = (0.0).xxxx;
			half3 worldToObj69 = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) ).xyz;
			half3 lerpResult270 = lerp( worldToObj69 , ase_worldPos , _AO_WorldPos);
			half3 break272 = lerpResult270;
			half lerpResult209 = lerp( break272.y , break272.z , _AODirection);
			half smoothstepResult179 = smoothstep( 0.0 , _AOsmooth , ( lerpResult209 + _AOposition ));
			half lerpResult226 = lerp( smoothstepResult179 , ( 1.0 - smoothstepResult179 ) , _AOAxisMinus);
			half4 lerpResult201 = lerp( float4( 0,0,0,0 ) , ( lerpResult145 * _AOIntensity ) , saturate( lerpResult226 ));
			half4 AO186 = lerpResult201;
			#ifdef _USEAO_ON
				half4 staticSwitch206 = AO186;
			#else
				half4 staticSwitch206 = temp_cast_7;
			#endif
			half4 ShadowCastDepart137 = ( ase_lightColor * saturate( ( MainTexture144 + BlinnLight75 + staticSwitch206 ) ) * _TexEmission );
			o.Emission = ( Fresnel132 + MaskEmission34 + EdgeLight174 + ShadowCastDepart137 ).rgb;
			o.Alpha = 1;
			#ifdef _USETEXTUREDISSOLVE_ON
				half staticSwitch131 = ( tex2DNode54.a * temp_output_126_0 );
			#else
				half staticSwitch131 = temp_output_128_0;
			#endif
			half Dissolve135 = staticSwitch131;
			half lerpResult224 = lerp( tex2DNode54.a , Dissolve135 , _TexClipStyle);
			clip( lerpResult224 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18934
2560;0;2560;1419;1284.611;305.8958;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;11;-4075.853,-848.3871;Inherit;False;2444.652;526.8491;MainTexture;26;151;150;148;147;146;145;144;61;57;54;51;49;47;46;45;44;43;42;41;40;39;38;37;36;212;213;MainTexture;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-4042.887,-415.004;Inherit;False;Property;_WorldMainTextureRollY;WorldMainTextureRollY;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-4037.887,-491.004;Inherit;False;Property;_WorldMainTextureRollX;WorldMainTextureRollX;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;37;-3982.887,-650.0037;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-3796.888,-614.0037;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;41;-3872.7,-797.8173;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-3791.888,-495.004;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;14;-2337.878,596.6541;Inherit;False;2249.156;842.55;VertexOffset;37;240;234;238;235;236;231;237;232;228;233;60;35;32;121;124;230;113;98;348;347;87;84;241;73;72;74;67;68;70;267;59;65;66;64;268;269;69;VertexOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-3652.744,-602.6865;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-3655.744,-713.6865;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-3595.81,-504.7716;Inherit;False;Property;_WorldMainTexTiling;WorldMainTexTiling;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;187;-2341.599,1491.595;Inherit;False;1984.121;365.8573;AO;17;272;208;186;201;184;190;226;200;182;227;179;177;180;178;209;270;271;AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;60;-2319.454,657.3188;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;44;-3520.744,-601.6865;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TransformPositionNode;69;-2166.45,895.9284;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;271;-2323.256,1761.542;Inherit;False;Property;_AO_WorldPos;AO_WorldPos;56;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;13;-4069.971,-289.1175;Inherit;False;919.1312;420.9999;MainLight;8;155;154;153;152;149;143;50;156;MainLight;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;47;-3387.81,-601.7714;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-3485.252,-734.3112;Inherit;False;0;54;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;50;-4038.971,-246.1176;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;270;-2166.953,1656.937;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;156;-4045.972,-106.1179;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;49;-3266.154,-663.3823;Inherit;False;Property;_UseMainTexWorldUV;UseMainTexWorldUV;2;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-4042.672,42.60732;Inherit;False;Property;_LightDir;LightDir;21;0;Create;True;0;0;0;False;0;False;0;-0.15;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;213;-2897.252,-492.8461;Inherit;False;Property;_UseMainTexture;UseMainTexture;3;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-2843.74,-769.5496;Inherit;False;Constant;_Notex;Notex;55;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;272;-2035.515,1534.886;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;208;-1965.13,1650.499;Inherit;False;Property;_AODirection;AODirection;57;1;[Enum];Create;True;0;2;Axis Y;0;Axis Z;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;143;-3793.744,-177.8594;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-3000.241,-690.9351;Inherit;True;Property;_MainTex;MainTex;4;0;Create;True;0;0;0;False;0;False;-1;None;5195409b3011c9b4592d7c74884525ad;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;57;-2711.782,-549.981;Inherit;False;Property;_Desaturate;Desaturate;10;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;209;-1803.13,1558.499;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;153;-3662.893,-126.673;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-3734.966,35.88233;Inherit;False;Property;_ShadowSmooth;ShadowSmooth;22;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;178;-1769.6,1681.595;Inherit;False;Property;_AOposition;AOposition;59;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;212;-2645.252,-681.8461;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;177;-1619.6,1592.595;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;152;-3511.323,-160.1232;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;61;-2450.052,-677.0827;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;150;-2430.052,-563.083;Inherit;False;Property;_MainTexColor;MainTexColor;5;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.509434,0.509434,0.509434,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;180;-1777.112,1764.73;Inherit;False;Property;_AOsmooth;AOsmooth;60;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;233;-1655.076,1274.694;Inherit;False;Property;_VertexOffsetMaskAxis;VertexOffsetMaskAxis;50;1;[Enum];Create;True;0;2;Y Axis;0;Z Axis;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-2404.516,-786.5026;Inherit;False;Property;_ShadowIntensity;ShadowIntensity;23;0;Create;True;0;0;0;False;0;False;0.75;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;232;-1357.076,1166.694;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;16;-4083.242,163.5379;Inherit;False;1713.8;791.1955;dissolve;28;135;131;205;103;203;127;128;126;125;115;117;204;108;106;104;107;105;85;95;89;91;79;202;78;81;77;80;76;Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-1353.076,1279.694;Inherit;False;Property;_VertexOffsetMaskPos;VertexOffsetMaskPos;52;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;15;-4257.017,-1488.135;Inherit;False;2184.899;611.5481;EmissionMask;26;29;34;33;214;30;215;28;242;243;31;27;25;26;24;22;23;19;21;20;340;341;342;343;344;345;346;EmissionMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;149;-3352.559,-153.0164;Inherit;False;MainLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;179;-1490.113,1591.73;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;12;-3109.889,-282.9279;Inherit;False;1291.156;403.9842;Rim;10;75;158;63;71;62;56;55;53;52;48;Rim;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-2227.053,-665.0827;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-1284.081,1347.904;Inherit;False;Property;_VertexOffsetMaskSmooth;VertexOffsetMaskSmooth;53;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;231;-1164.076,1161.694;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-4234.944,-1000.121;Inherit;False;Property;_MaskEmissionNoiseRollY;MaskEmissionNoiseRollY;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;48;-3029.685,-180.5827;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;80;-4014.133,539.7297;Inherit;False;Property;_NoiseRoll_X;NoiseRoll_X;30;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;79;-4058.815,225.6145;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-2115.363,-757.0408;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TimeNode;78;-4058.24,397.2345;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;76;-3994.643,687.9056;Inherit;False;Property;_NoiseRoll_Z;NoiseRoll_Z;32;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;182;-1327.113,1651.73;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;-2174.709,-494.3876;Inherit;False;149;MainLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-4236.017,-1078.406;Inherit;False;Property;_MaskEmissionNoiseRollX;MaskEmissionNoiseRollX;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;20;-4180.253,-1222.105;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;81;-4008.167,615.0768;Inherit;False;Property;_NoiseRoll_Y;NoiseRoll_Y;31;0;Create;True;0;0;0;False;0;False;0;-0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-1358.152,1739.873;Inherit;False;Property;_AOAxisMinus;AOAxisMinus;58;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;77;-4019.814,759.6328;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;269;-2179.905,1064.193;Inherit;False;Property;_VertexOffsetWorldPos;VertexOffsetWorldPos;44;1;[Enum];Create;True;0;2;On;0;Off;1;0;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;236;-1010.08,1162.904;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;226;-1147.152,1591.874;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-3811.632,581.4897;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;89;-3889.464,227.2236;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;202;-3938.866,874.0074;Inherit;False;Property;_DissolveTexDir;DissolveTexDir;36;1;[Enum];Create;True;0;2;Horizontal;0;Vertical;1;0;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-3979.716,-1047.307;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-3982.931,-1151.329;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;52;-2820.106,-236.9276;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-3080.221,-29.3531;Inherit;False;Property;_RimLightDir;RimLightDir;25;0;Create;True;0;0;0;False;0;False;0;-0.25;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;200;-1163.906,1740.89;Inherit;False;Property;_AOIntensity;AOIntensity;61;0;Create;True;0;0;0;False;0;False;-0.35;-0.25;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-3817.157,478.6616;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;145;-1993.053,-668.0828;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-3828.226,377.1737;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-1868.431,1219.13;Inherit;False;Property;_VertexOffsetMove_Z;VertexOffsetMove_Z;47;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1898.431,1143.13;Inherit;False;Property;_VertexOffsetMove_Y;VertexOffsetMove_Y;46;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;268;-1949.677,658.5554;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TimeNode;65;-1932.176,918.1115;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;235;-937.0797,1289.904;Inherit;False;Property;_VertexOffsetMaskMinus;VertexOffsetMaskMinus;51;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;238;-854.0798,1216.904;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1939.431,1066.13;Inherit;False;Property;_VertexOffsetMove_X;VertexOffsetMove_X;45;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-2802.698,8.70182;Inherit;False;Property;_RimSmooth;RimSmooth;26;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;344;-4048.986,-1328.965;Inherit;False;Property;_MaskEmissionRadius;MaskEmissionRadius;20;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-882.8824,1684.251;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;203;-3745.866,706.0074;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;-3650.135,465.6976;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;175;-3982.706,1001.188;Inherit;False;1612.392;458.1671;EdgeLight;12;164;165;163;169;170;168;171;167;172;173;174;166;EdgeLight;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;-3657.134,369.0658;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-3817.16,-1090.84;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;63;-2508.911,-64.85017;Inherit;False;Property;_RimLightColor;RimLightColor;24;0;Create;True;0;0;0;False;0;False;0.3921569,0.3921569,0.3921569,0;0.3301887,0.3301887,0.3301887,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;105;-3647.592,567.0657;Inherit;False;Property;_Dissolve;Dissolve;39;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;-3663.27,267.4103;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-2677.495,-202.9565;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;190;-891.8732,1597.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-2320.919,-188.4883;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;234;-641.0803,1164.904;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1694.215,865.0932;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1683.146,965.5815;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;345;-3725.636,-1319.003;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1648.836,1067.849;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-3524.859,398.6087;Inherit;False;Property;_NoiseScale;NoiseScale;38;0;Create;True;0;0;0;False;0;False;5;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;108;-3334.739,542.3572;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.075;False;4;FLOAT;1.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;62;-2533.494,-193.9565;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;205;-3653.866,839.0074;Inherit;False;Property;_DissolveTexDirMinus;DissolveTexDirMinus;37;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;103;-3592.171,764.2217;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;201;-745.6404,1604.132;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;29;-3547.738,-1451.713;Inherit;True;Property;_MaskEmissionTexture;MaskEmissionTexture;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-3696.082,-968.424;Inherit;False;Property;_MaskEmissionNoiseScale;MaskEmissionNoiseScale;19;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;115;-3503.843,275.0146;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-3671.555,-1150.249;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;163;-3932.706,1178.719;Inherit;False;Property;_EdgeWidth;EdgeWidth;42;0;Create;True;0;0;0;False;0;False;-0.05;-0.035;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;267;-1771.085,718.4684;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;240;-475.0804,1158.904;Inherit;False;VertexOffsetMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-1502.837,967.8477;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-1523.121,856.9853;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-1529.258,755.3296;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;204;-3425.866,713.0074;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;125;-3358.529,273.0417;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;18;-1766.911,-262.9312;Inherit;False;1096.865;434.5344;Fresnel;9;132;118;111;120;99;130;86;119;88;Fresnel;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;17;-1616.26,-848.3229;Inherit;False;1212.15;550.9542;LightMix;11;137;221;114;123;222;97;92;93;206;207;188;LightMix;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;169;-3603.387,1299.771;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;158;-2171.156,-172.2106;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;186;-588.1647,1609.418;Inherit;False;AO;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;164;-3611.72,1093.337;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;342;-3356.325,-1154.233;Inherit;False;Constant;_Float2;Float 2;63;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;340;-3398.325,-954.2327;Inherit;False;Property;_MaskEmissionNoise;MaskEmissionNoise;16;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;27;-3406.594,-1069.24;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;343;-3254.306,-1304.52;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;165;-3441.523,1068.237;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-2007.645,-123.2464;Inherit;False;BlinnLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;126;-3139.14,605.1437;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-1831.709,-671.3873;Inherit;False;MainTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;207;-1575.474,-568.2117;Inherit;False;Constant;_Float0;Float 0;52;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;188;-1591.258,-465.3798;Inherit;False;186;AO;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;341;-3164.325,-1089.233;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;170;-3440.19,1271.671;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-1716.911,-72.3969;Inherit;False;Property;_FrenelPower;FrenelPower;29;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-1710.911,-146.3971;Inherit;False;Property;_FrenelScale;FrenelScale;28;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;347;-1135.313,935.6495;Inherit;False;Property;_CustomVertexOffsetMask;CustomVertexOffsetMask;49;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;128;-3082.224,348.4441;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;-1119.84,815.0175;Inherit;False;240;VertexOffsetMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;346;-3138.306,-1342.906;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-1363.836,942.8476;Inherit;False;Property;_VertexOffsetScale;VertexOffsetScale;48;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;84;-1369.831,762.9346;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;98;-1104.286,690.2817;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;206;-1434.726,-569.1061;Inherit;False;Property;_UseAO;UseAO;55;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;348;-906.2072,808.2275;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-1441.336,-726.859;Inherit;False;144;MainTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;166;-3293.7,1076.187;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;243;-2991.028,-1217.594;Inherit;False;Property;_MaskPower;MaskPower;15;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;168;-3296.367,1263.621;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;99;-1513.898,-178.8312;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-1435.694,-646.821;Inherit;False;75;BlinnLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-2994.129,-1333.9;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;242;-2845.028,-1334.594;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-798.4738,939.9495;Inherit;False;Property;_VertexOffsetIntensity;VertexOffsetIntensity;54;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;215;-2735.526,-1072.581;Inherit;False;Property;_MaskColorHDR;MaskColorHDR;14;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-1240.726,-654.822;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;171;-3154.314,1140.354;Inherit;False;Property;_UseTexturedEdgeLight;UseTexturedEdgeLight;40;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;118;-1490.912,-13.39691;Inherit;False;Property;_FresnelColor;FresnelColor;27;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1,0.5882353,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;230;-760.6879,692.0791;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;111;-1289.911,-143.397;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;-2952.964,-1138.458;Inherit;False;Property;_MaskEmissionTexColor;MaskEmissionTexColor;13;0;Create;True;0;0;0;False;0;False;0.6862745,0.6862745,0.6862745,1;0.6862745,0.6862745,0.6862745,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;222;-1142.616,-525.3372;Inherit;False;Property;_TexEmission;TexEmission;6;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-1261.327,19.61824;Inherit;False;Property;_OnHitRange;OnHitRange;33;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;173;-2948.314,1247.354;Inherit;False;Property;_EdgeColor;EdgeColor;41;1;[HDR];Create;True;0;0;0;False;0;False;1,0.5294118,0,0;3.776172,1.432343,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-1153.911,-120.3971;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;167;-2864.938,1144.176;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-553.8345,692.63;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2700.183,-1410.122;Inherit;False;Constant;_Float1;Float 1;48;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;-2697.275,-1336.44;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;123;-1041.792,-760.3241;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.NormalVertexDataNode;121;-520.8347,871.6304;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-2987.01,576.9899;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;114;-1061.174,-628.7997;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;33;-2567.837,-1350.719;Inherit;False;Property;_UseMaskEmissionTexture;UseMaskEmissionTexture;11;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;-2734.314,1147.354;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-427.8345,693.63;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;-860.416,-655.2371;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;131;-2849.605,406.9235;Inherit;False;Property;_UseTextureDissolve;UseTextureDissolve;35;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-1014.994,-123.1125;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;135;-2573.989,409.9362;Inherit;False;Dissolve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-2273.119,-1345.792;Inherit;False;MaskEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-869.2913,-124.5058;Inherit;False;Fresnel;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-303.0063,695.2059;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-664.881,-651.6927;Inherit;False;ShadowCastDepart;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;174;-2589.043,1149.447;Inherit;False;EdgeLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;349;-427.767,368.6213;Inherit;False;Constant;_Float3;Float 3;63;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;-477.85,-77.3071;Inherit;False;132;Fresnel;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-477.5378,453.7484;Inherit;False;35;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-499.0086,262.8999;Inherit;False;Property;_TexClipStyle;TexClipStyle;34;1;[Enum];Create;True;0;2;TexClip;0;DissolveClip;1;0;True;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2;226.0997,55.90039;Inherit;False;225;166;Cull Mode;1;9;Cull Mode;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-503.8129,183.4292;Inherit;False;135;Dissolve;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;-481.8899,78.12;Inherit;False;174;EdgeLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-486.937,-164.7678;Inherit;False;137;ShadowCastDepart;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;-503.5505,1.755402;Inherit;False;34;MaskEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;140;-260.586,388.9995;Inherit;False;Property;_UseVertexOffset;UseVertexOffset;43;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;224;-168.1395,255.8536;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;9;276.0997,105.9002;Inherit;False;Property;_Cull_Mode;Cull_Mode;1;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;2;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;141;-268.2008,61.93652;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-3,55;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Koakuma/Character;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;AlphaTest;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;9;-1;0;False;267;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;40;0;37;2
WireConnection;40;1;38;0
WireConnection;39;0;37;2
WireConnection;39;1;36;0
WireConnection;43;0;41;2
WireConnection;43;1;39;0
WireConnection;42;0;41;1
WireConnection;42;1;40;0
WireConnection;44;0;42;0
WireConnection;44;1;43;0
WireConnection;69;0;60;0
WireConnection;47;0;44;0
WireConnection;47;1;45;0
WireConnection;270;0;69;0
WireConnection;270;1;60;0
WireConnection;270;2;271;0
WireConnection;49;1;46;0
WireConnection;49;0;47;0
WireConnection;272;0;270;0
WireConnection;143;0;50;0
WireConnection;143;1;156;0
WireConnection;54;1;49;0
WireConnection;209;0;272;1
WireConnection;209;1;272;2
WireConnection;209;2;208;0
WireConnection;153;0;143;0
WireConnection;153;1;155;0
WireConnection;212;0;51;0
WireConnection;212;1;54;0
WireConnection;212;2;213;0
WireConnection;177;0;209;0
WireConnection;177;1;178;0
WireConnection;152;0;153;0
WireConnection;152;2;154;0
WireConnection;61;0;212;0
WireConnection;61;1;57;0
WireConnection;232;0;69;2
WireConnection;232;1;69;3
WireConnection;232;2;233;0
WireConnection;149;0;152;0
WireConnection;179;0;177;0
WireConnection;179;2;180;0
WireConnection;146;0;61;0
WireConnection;146;1;150;0
WireConnection;231;0;232;0
WireConnection;231;1;228;0
WireConnection;148;0;151;0
WireConnection;148;1;146;0
WireConnection;182;0;179;0
WireConnection;236;0;231;0
WireConnection;236;2;237;0
WireConnection;226;0;179;0
WireConnection;226;1;182;0
WireConnection;226;2;227;0
WireConnection;85;0;78;2
WireConnection;85;1;76;0
WireConnection;89;0;79;0
WireConnection;23;0;20;2
WireConnection;23;1;21;0
WireConnection;22;0;20;2
WireConnection;22;1;19;0
WireConnection;52;0;50;0
WireConnection;52;1;48;0
WireConnection;91;0;78;2
WireConnection;91;1;81;0
WireConnection;145;0;148;0
WireConnection;145;1;146;0
WireConnection;145;2;147;0
WireConnection;95;0;78;2
WireConnection;95;1;80;0
WireConnection;268;0;60;0
WireConnection;268;1;69;0
WireConnection;268;2;269;0
WireConnection;238;0;236;0
WireConnection;184;0;145;0
WireConnection;184;1;200;0
WireConnection;203;0;77;1
WireConnection;203;1;77;2
WireConnection;203;2;202;0
WireConnection;107;0;89;3
WireConnection;107;1;85;0
WireConnection;104;0;89;2
WireConnection;104;1;91;0
WireConnection;24;0;22;0
WireConnection;24;1;23;0
WireConnection;106;0;89;1
WireConnection;106;1;95;0
WireConnection;56;0;52;0
WireConnection;56;1;53;0
WireConnection;190;0;226;0
WireConnection;71;0;61;0
WireConnection;71;1;63;0
WireConnection;234;0;236;0
WireConnection;234;1;238;0
WireConnection;234;2;235;0
WireConnection;70;0;65;2
WireConnection;70;1;66;0
WireConnection;67;0;65;2
WireConnection;67;1;64;0
WireConnection;345;0;344;0
WireConnection;68;0;65;2
WireConnection;68;1;59;0
WireConnection;108;0;105;0
WireConnection;62;0;56;0
WireConnection;62;2;55;0
WireConnection;103;0;203;0
WireConnection;201;1;184;0
WireConnection;201;2;190;0
WireConnection;115;0;106;0
WireConnection;115;1;104;0
WireConnection;115;2;107;0
WireConnection;25;1;24;0
WireConnection;267;0;268;0
WireConnection;240;0;234;0
WireConnection;73;0;267;2
WireConnection;73;1;68;0
WireConnection;72;0;267;1
WireConnection;72;1;67;0
WireConnection;74;0;267;0
WireConnection;74;1;70;0
WireConnection;204;0;203;0
WireConnection;204;1;103;0
WireConnection;204;2;205;0
WireConnection;125;0;115;0
WireConnection;125;1;117;0
WireConnection;169;0;108;0
WireConnection;169;1;163;0
WireConnection;158;0;71;0
WireConnection;158;2;62;0
WireConnection;186;0;201;0
WireConnection;164;0;108;0
WireConnection;164;1;163;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;343;0;29;1
WireConnection;343;1;345;0
WireConnection;165;0;164;0
WireConnection;165;1;125;0
WireConnection;75;0;158;0
WireConnection;126;0;108;0
WireConnection;126;1;204;0
WireConnection;144;0;145;0
WireConnection;341;0;342;0
WireConnection;341;1;27;0
WireConnection;341;2;340;0
WireConnection;170;0;169;0
WireConnection;170;1;204;0
WireConnection;128;0;108;0
WireConnection;128;1;125;0
WireConnection;346;0;343;0
WireConnection;84;0;74;0
WireConnection;84;1;72;0
WireConnection;84;2;73;0
WireConnection;98;0;84;0
WireConnection;98;1;87;0
WireConnection;206;1;207;0
WireConnection;206;0;188;0
WireConnection;348;0;241;0
WireConnection;348;1;346;0
WireConnection;348;2;347;0
WireConnection;166;0;128;0
WireConnection;166;1;165;0
WireConnection;168;0;126;0
WireConnection;168;1;170;0
WireConnection;99;2;88;0
WireConnection;99;3;86;0
WireConnection;31;0;346;0
WireConnection;31;1;341;0
WireConnection;242;0;31;0
WireConnection;242;1;243;0
WireConnection;97;0;92;0
WireConnection;97;1;93;0
WireConnection;97;2;206;0
WireConnection;171;1;166;0
WireConnection;171;0;168;0
WireConnection;230;0;98;0
WireConnection;230;1;348;0
WireConnection;111;0;99;0
WireConnection;120;0;111;0
WireConnection;120;1;118;0
WireConnection;167;0;171;0
WireConnection;124;0;230;0
WireConnection;124;1;113;0
WireConnection;214;0;242;0
WireConnection;214;1;28;0
WireConnection;214;2;215;0
WireConnection;127;0;54;4
WireConnection;127;1;126;0
WireConnection;114;0;97;0
WireConnection;33;1;30;0
WireConnection;33;0;214;0
WireConnection;172;0;167;0
WireConnection;172;1;173;0
WireConnection;32;0;124;0
WireConnection;32;1;121;0
WireConnection;221;0;123;0
WireConnection;221;1;114;0
WireConnection;221;2;222;0
WireConnection;131;1;128;0
WireConnection;131;0;127;0
WireConnection;130;0;120;0
WireConnection;130;1;119;0
WireConnection;135;0;131;0
WireConnection;34;0;33;0
WireConnection;132;0;130;0
WireConnection;35;0;32;0
WireConnection;137;0;221;0
WireConnection;174;0;172;0
WireConnection;140;1;349;0
WireConnection;140;0;138;0
WireConnection;224;0;54;4
WireConnection;224;1;142;0
WireConnection;224;2;223;0
WireConnection;141;0;134;0
WireConnection;141;1;157;0
WireConnection;141;2;176;0
WireConnection;141;3;139;0
WireConnection;0;2;141;0
WireConnection;0;10;224;0
WireConnection;0;11;140;0
ASEEND*/
//CHKSM=051AF3F7A8E047F952988A25AE3AA751FB27DA3B