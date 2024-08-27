// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/HQ_Character"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_Mode", Int) = 2
		[Toggle(_USEMAINTEXWORLDUV_ON)] _UseMainTexWorldUV("UseMainTexWorldUV", Float) = 0
		[Enum(Off,0,On,1)]_UseMainTexture("UseMainTexture", Float) = 1
		_MainTex("MainTex", 2D) = "white" {}
		_NormalTex("NormalTex", 2D) = "bump" {}
		_ORM_Tex("ORM_Tex", 2D) = "white" {}
		_MainTexColor("MainTexColor", Color) = (1,1,1,1)
		_TexEmission("TexEmission", Range( 0 , 5)) = 1
		_NormalMapDensity("NormalMapDensity", Float) = -1
		_AO_Density("AO_Density", Float) = 0
		_RoughnessDensity("RoughnessDensity", Float) = 0
		_MetallicDensity("MetallicDensity", Float) = 0
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
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USEVERTEXOFFSET_ON
		#pragma shader_feature_local _USEMAINTEXWORLDUV_ON
		#pragma shader_feature_local _USEMASKEMISSIONTEXTURE_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			half3 worldNormal;
			INTERNAL_DATA
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
		uniform sampler2D _NormalTex;
		uniform half4 _NormalTex_ST;
		uniform half _NormalMapDensity;
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
		uniform half _TexEmission;
		uniform half _MaskEmissionNoiseRollX;
		uniform half _MaskEmissionNoiseRollY;
		uniform half _MaskEmissionNoiseScale;
		uniform half _MaskEmissionNoise;
		uniform half _MaskPower;
		uniform half4 _MaskEmissionTexColor;
		uniform half _MaskColorHDR;
		uniform half _MetallicDensity;
		uniform sampler2D _ORM_Tex;
		uniform half4 _ORM_Tex_ST;
		uniform half _RoughnessDensity;
		uniform half _AO_Density;
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
			float2 uv_NormalTex = i.uv_texcoord * _NormalTex_ST.xy + _NormalTex_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _NormalTex, uv_NormalTex ), _NormalMapDensity );
			half4 temp_cast_0 = (1.0).xxxx;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 ase_worldPos = i.worldPos;
			half2 appendResult44 = (half2(( ase_worldPos.x + ( _Time.y * _WorldMainTextureRollX ) ) , ( ase_worldPos.y + ( _Time.y * _WorldMainTextureRollY ) )));
			#ifdef _USEMAINTEXWORLDUV_ON
				half2 staticSwitch49 = ( appendResult44 / _WorldMainTexTiling );
			#else
				half2 staticSwitch49 = uv_MainTex;
			#endif
			half4 tex2DNode54 = tex2D( _MainTex, staticSwitch49 );
			half4 lerpResult212 = lerp( temp_cast_0 , tex2DNode54 , _UseMainTexture);
			half3 desaturateInitialColor61 = lerpResult212.rgb;
			half desaturateDot61 = dot( desaturateInitialColor61, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar61 = lerp( desaturateInitialColor61, desaturateDot61.xxx, _Desaturate );
			half4 temp_output_146_0 = ( half4( desaturateVar61 , 0.0 ) * _MainTexColor );
			half3 ase_worldNormal = WorldNormalVector( i, half3( 0, 0, 1 ) );
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
			half3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			half dotResult52 = dot( ase_normWorldNormal , ase_worldViewDir );
			half smoothstepResult62 = smoothstep( 0.0 , _RimSmooth , ( dotResult52 + _RimLightDir ));
			half4 lerpResult158 = lerp( ( half4( desaturateVar61 , 0.0 ) * _RimLightColor ) , float4( 0,0,0,0 ) , smoothstepResult62);
			half4 BlinnLight75 = lerpResult158;
			half4 ShadowCastDepart137 = ( saturate( ( MainTexture144 + BlinnLight75 ) ) * _TexEmission );
			o.Albedo = ShadowCastDepart137.rgb;
			half4 temp_cast_6 = (0.0).xxxx;
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
				half4 staticSwitch33 = temp_cast_6;
			#endif
			half4 MaskEmission34 = staticSwitch33;
			o.Emission = MaskEmission34.rgb;
			float2 uv_ORM_Tex = i.uv_texcoord * _ORM_Tex_ST.xy + _ORM_Tex_ST.zw;
			half4 tex2DNode351 = tex2D( _ORM_Tex, uv_ORM_Tex );
			half lerpResult352 = lerp( 0.0 , _MetallicDensity , tex2DNode351.b);
			o.Metallic = lerpResult352;
			half lerpResult353 = lerp( _RoughnessDensity , 0.0 , tex2DNode351.g);
			o.Smoothness = lerpResult353;
			half lerpResult354 = lerp( 0.0 , _AO_Density , tex2DNode351.r);
			o.Occlusion = lerpResult354;
			o.Alpha = 1;
			clip( tex2DNode54.a - _Cutoff );
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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
2560;0;2560;1419;4356.5;847.5815;1.673556;True;True
Node;AmplifyShaderEditor.CommentaryNode;11;-4140.851,-925.0866;Inherit;False;2444.652;526.8491;MainTexture;26;151;150;148;147;146;145;144;61;57;54;51;49;47;46;45;44;43;42;41;40;39;38;37;36;212;213;MainTexture;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-4107.886,-491.7038;Inherit;False;Property;_WorldMainTextureRollY;WorldMainTextureRollY;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-4102.887,-567.7036;Inherit;False;Property;_WorldMainTextureRollX;WorldMainTextureRollX;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;37;-4047.888,-726.7032;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-3861.889,-690.7032;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;41;-3937.701,-874.5168;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-3856.889,-571.7036;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-3720.745,-790.386;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;14;-4127.739,641.6034;Inherit;False;2249.156;842.55;VertexOffset;37;240;234;238;235;236;231;237;232;228;233;60;35;32;121;124;230;113;98;348;347;87;84;241;73;72;74;67;68;70;267;59;65;66;64;268;269;69;VertexOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-3717.745,-679.386;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-3660.812,-581.4711;Inherit;False;Property;_WorldMainTexTiling;WorldMainTexTiling;13;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;-3585.745,-678.386;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;60;-4109.315,702.2681;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;233;-3411.938,1289.644;Inherit;False;Property;_VertexOffsetMaskAxis;VertexOffsetMaskAxis;40;1;[Enum];Create;True;0;2;Y Axis;0;Z Axis;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;13;-4134.969,-356.7173;Inherit;False;919.1312;420.9999;MainLight;8;155;154;153;152;149;143;50;156;MainLight;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;47;-3452.812,-678.4709;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-3550.253,-811.0107;Inherit;False;0;54;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TransformPositionNode;69;-3935.332,864.8265;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;50;-4103.97,-313.7174;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;49;-3331.156,-740.0818;Inherit;False;Property;_UseMainTexWorldUV;UseMainTexWorldUV;2;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;156;-4110.97,-173.7179;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;228;-3142.938,1324.644;Inherit;False;Property;_VertexOffsetMaskPos;VertexOffsetMaskPos;42;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;232;-3146.938,1211.644;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-3073.943,1392.854;Inherit;False;Property;_VertexOffsetMaskSmooth;VertexOffsetMaskSmooth;43;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-2908.741,-846.2491;Inherit;False;Constant;_Notex;Notex;55;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;143;-3858.744,-245.4595;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-3065.242,-767.6346;Inherit;True;Property;_MainTex;MainTex;4;0;Create;True;0;0;0;False;0;False;-1;None;5195409b3011c9b4592d7c74884525ad;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;213;-2962.253,-569.5457;Inherit;False;Property;_UseMainTexture;UseMainTexture;3;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;15;-4137.301,-1564.172;Inherit;False;2184.899;611.5481;EmissionMask;26;29;34;33;214;30;215;28;242;243;31;27;25;26;24;22;23;19;21;20;340;341;342;343;344;345;346;EmissionMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;12;-3155.39,-340.1276;Inherit;False;1291.156;403.9842;Rim;10;75;158;63;71;62;56;55;53;52;48;Rim;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;231;-2953.938,1206.644;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-4107.67,-24.99267;Inherit;False;Property;_LightDir;LightDir;27;0;Create;True;0;0;0;False;0;False;0;-0.15;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-4116.301,-1154.443;Inherit;False;Property;_MaskEmissionNoiseRollX;MaskEmissionNoiseRollX;23;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;153;-3727.893,-194.2731;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-4115.228,-1076.157;Inherit;False;Property;_MaskEmissionNoiseRollY;MaskEmissionNoiseRollY;24;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-3799.966,-31.71766;Inherit;False;Property;_ShadowSmooth;ShadowSmooth;28;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;269;-3969.767,1109.143;Inherit;False;Property;_VertexOffsetWorldPos;VertexOffsetWorldPos;34;1;[Enum];Create;True;0;2;On;0;Off;1;0;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-2776.783,-626.6805;Inherit;False;Property;_Desaturate;Desaturate;16;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;212;-2710.253,-758.5457;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;236;-2799.942,1207.854;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;48;-3075.186,-237.7828;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TimeNode;20;-4060.538,-1298.141;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;238;-2643.942,1261.854;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-3860.001,-1123.344;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-3658.293,1264.08;Inherit;False;Property;_VertexOffsetMove_Z;VertexOffsetMove_Z;37;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;268;-3739.539,703.5047;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;152;-3576.323,-227.7233;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;344;-3929.271,-1405.001;Inherit;False;Property;_MaskEmissionRadius;MaskEmissionRadius;26;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;65;-3722.038,963.0607;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-3863.216,-1227.365;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-3125.722,-86.55313;Inherit;False;Property;_RimLightDir;RimLightDir;31;0;Create;True;0;0;0;False;0;False;0;-0.25;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-3688.293,1188.08;Inherit;False;Property;_VertexOffsetMove_Y;VertexOffsetMove_Y;36;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;235;-2726.942,1334.854;Inherit;False;Property;_VertexOffsetMaskMinus;VertexOffsetMaskMinus;41;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;52;-2865.607,-294.1274;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;61;-2515.053,-753.7822;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-3729.293,1111.08;Inherit;False;Property;_VertexOffsetMove_X;VertexOffsetMove_X;35;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;150;-2495.053,-639.7825;Inherit;False;Property;_MainTexColor;MainTexColor;7;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.509434,0.509434,0.509434,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-2722.996,-260.1565;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;149;-3417.559,-220.6165;Inherit;False;MainLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;345;-3616.921,-1394.04;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-3484.077,910.0425;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-3473.009,1010.531;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;63;-2554.412,-122.0502;Inherit;False;Property;_RimLightColor;RimLightColor;30;0;Create;True;0;0;0;False;0;False;0.3921569,0.3921569,0.3921569,0;0.3301887,0.3301887,0.3301887,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;267;-3560.948,763.4177;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LerpOp;234;-2430.943,1209.854;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-2292.054,-741.7822;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-2469.518,-863.2021;Inherit;False;Property;_ShadowIntensity;ShadowIntensity;29;0;Create;True;0;0;0;False;0;False;0.75;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-3697.445,-1166.876;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-3438.698,1112.799;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-2848.199,-48.49817;Inherit;False;Property;_RimSmooth;RimSmooth;32;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-3428.023,-1527.75;Inherit;True;Property;_MaskEmissionTexture;MaskEmissionTexture;18;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-3319.12,800.2789;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;240;-2264.942,1203.854;Inherit;False;VertexOffsetMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;343;-3134.591,-1380.557;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-2366.42,-245.6884;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;62;-2578.995,-251.1566;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-3576.367,-1044.46;Inherit;False;Property;_MaskEmissionNoiseScale;MaskEmissionNoiseScale;25;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-3292.699,1012.797;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-3312.984,901.9346;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;-2239.71,-571.0872;Inherit;False;149;MainLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-2180.365,-833.7403;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-3551.84,-1226.286;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;241;-2909.702,859.9668;Inherit;False;240;VertexOffsetMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;346;-3018.591,-1418.943;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;347;-2928.209,980.5986;Inherit;False;Property;_CustomVertexOffsetMask;CustomVertexOffsetMask;39;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;145;-2058.054,-744.7823;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;84;-3159.693,807.8839;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;158;-2216.657,-229.4107;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-3153.698,987.7968;Inherit;False;Property;_VertexOffsetScale;VertexOffsetScale;38;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;27;-3286.879,-1145.276;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;342;-3236.61,-1230.27;Inherit;False;Constant;_Float2;Float 2;63;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;340;-3278.61,-1030.269;Inherit;False;Property;_MaskEmissionNoise;MaskEmissionNoise;22;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;17;-1915.262,-1525.623;Inherit;False;1212.15;550.9542;LightMix;7;137;221;114;222;97;92;93;LightMix;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;348;-2696.07,853.1768;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;341;-3044.61,-1165.27;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-1896.71,-748.0869;Inherit;False;MainTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-2053.145,-180.4465;Inherit;False;BlinnLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;98;-2894.148,735.231;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-2874.414,-1409.937;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;243;-2871.313,-1293.63;Inherit;False;Property;_MaskPower;MaskPower;21;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-1851.696,-1254.121;Inherit;False;75;BlinnLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-1858.338,-1351.159;Inherit;False;144;MainTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;230;-2550.55,737.0284;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-2642.096,970.4746;Inherit;False;Property;_VertexOffsetIntensity;VertexOffsetIntensity;44;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;121;-2368.391,908.7124;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;28;-2857.249,-1215.495;Inherit;False;Property;_MaskEmissionTexColor;MaskEmissionTexColor;19;0;Create;True;0;0;0;False;0;False;0.6862745,0.6862745,0.6862745,1;0.6862745,0.6862745,0.6862745,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;215;-2630.811,-1144.618;Inherit;False;Property;_MaskColorHDR;MaskColorHDR;20;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-1637.728,-1318.122;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;242;-2725.313,-1410.63;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-2411.88,737.5793;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;-2577.56,-1412.476;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2580.468,-1486.158;Inherit;False;Constant;_Float1;Float 1;48;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;114;-1478.176,-1312.1;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-2266.212,739.8905;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;222;-1610.618,-1201.638;Inherit;False;Property;_TexEmission;TexEmission;8;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;33;-2443.122,-1426.755;Inherit;False;Property;_UseMaskEmissionTexture;UseMaskEmissionTexture;17;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;359;-1648.647,-553.5662;Inherit;False;1006;415;Normal;2;350;349;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;-1237.417,-1318.537;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;358;-1489.647,-118.5662;Inherit;False;802;557;ORM;7;352;353;354;355;356;357;351;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-2116.471,741.4664;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-962.8803,-1314.993;Inherit;False;ShadowCastDepart;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-477.5378,453.7484;Inherit;False;35;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;350;-1643.647,-390.5662;Inherit;False;Property;_NormalMapDensity;NormalMapDensity;9;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;355;-1152.647,298.4338;Inherit;False;Property;_AO_Density;AO_Density;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;357;-1146.647,-51.56616;Inherit;False;Property;_MetallicDensity;MetallicDensity;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-2145.404,-1421.828;Inherit;False;MaskEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;2;226.0997,55.90039;Inherit;False;225;166;Cull Mode;1;9;Cull Mode;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;356;-1130.647,108.4338;Inherit;False;Property;_RoughnessDensity;RoughnessDensity;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;351;-1439.647,25.43384;Inherit;True;Property;_ORM_Tex;ORM_Tex;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;361;-433.8352,355.174;Inherit;False;Constant;_Float0;Float 0;47;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;329;-3725.688,103.5047;Inherit;False;1492.936;473.012;Outline;11;327;317;320;302;316;315;321;319;322;337;360;Outline;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;354;-869.6472,279.4338;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;353;-871.6472,101.4338;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;9;276.0997,105.9002;Inherit;False;Property;_Cull_Mode;Cull_Mode;1;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;2;False;0;1;INT;0
Node;AmplifyShaderEditor.StaticSwitch;140;-278.586,388.9995;Inherit;False;Property;_UseVertexOffset;UseVertexOffset;33;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;349;-1415.647,-504.5662;Inherit;True;Property;_NormalTex;NormalTex;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;352;-905.6472,-68.56616;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-524.937,-197.7678;Inherit;False;137;ShadowCastDepart;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;-512.5505,4.755402;Inherit;False;34;MaskEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;327;-2462.753,204.5812;Inherit;False;OutLine;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OutlineNode;337;-2759.098,204.4058;Inherit;False;0;False;Masked;0;0;Front;True;True;True;True;0;False;-1;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;302;-3638.427,233.5481;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;317;-3422.729,283.6998;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;315;-3475.106,460.8795;Inherit;False;Constant;_OutlineViewDistance;OutlineViewDistance;64;0;Create;True;0;0;0;False;0;False;32;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;316;-3257.104,298.7065;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;360;-3197.793,210.1625;Inherit;False;Property;_OutlineWidthMin;OutlineWidthMin;45;0;Create;True;0;0;0;False;0;False;0.0025;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;321;-3129.927,307.6389;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;319;-3236.058,418.5164;Inherit;False;Property;_OutlineWidth;OutlineWidth;46;0;Create;True;0;0;0;False;0;False;0.05;0.01;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;322;-2958.399,271.6168;Inherit;False;3;0;FLOAT;0.005;False;1;FLOAT;0.1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SurfaceDepthNode;320;-3685.688,391.5834;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-3,55;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Koakuma/HQ_Character;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;AlphaTest;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;9;-1;0;False;267;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;40;0;37;2
WireConnection;40;1;38;0
WireConnection;39;0;37;2
WireConnection;39;1;36;0
WireConnection;42;0;41;1
WireConnection;42;1;40;0
WireConnection;43;0;41;2
WireConnection;43;1;39;0
WireConnection;44;0;42;0
WireConnection;44;1;43;0
WireConnection;47;0;44;0
WireConnection;47;1;45;0
WireConnection;69;0;60;0
WireConnection;49;1;46;0
WireConnection;49;0;47;0
WireConnection;232;0;69;2
WireConnection;232;1;69;3
WireConnection;232;2;233;0
WireConnection;143;0;50;0
WireConnection;143;1;156;0
WireConnection;54;1;49;0
WireConnection;231;0;232;0
WireConnection;231;1;228;0
WireConnection;153;0;143;0
WireConnection;153;1;155;0
WireConnection;212;0;51;0
WireConnection;212;1;54;0
WireConnection;212;2;213;0
WireConnection;236;0;231;0
WireConnection;236;2;237;0
WireConnection;238;0;236;0
WireConnection;23;0;20;2
WireConnection;23;1;21;0
WireConnection;268;0;60;0
WireConnection;268;1;69;0
WireConnection;268;2;269;0
WireConnection;152;0;153;0
WireConnection;152;2;154;0
WireConnection;22;0;20;2
WireConnection;22;1;19;0
WireConnection;52;0;50;0
WireConnection;52;1;48;0
WireConnection;61;0;212;0
WireConnection;61;1;57;0
WireConnection;56;0;52;0
WireConnection;56;1;53;0
WireConnection;149;0;152;0
WireConnection;345;0;344;0
WireConnection;70;0;65;2
WireConnection;70;1;66;0
WireConnection;67;0;65;2
WireConnection;67;1;64;0
WireConnection;267;0;268;0
WireConnection;234;0;236;0
WireConnection;234;1;238;0
WireConnection;234;2;235;0
WireConnection;146;0;61;0
WireConnection;146;1;150;0
WireConnection;24;0;22;0
WireConnection;24;1;23;0
WireConnection;68;0;65;2
WireConnection;68;1;59;0
WireConnection;74;0;267;0
WireConnection;74;1;70;0
WireConnection;240;0;234;0
WireConnection;343;0;29;1
WireConnection;343;1;345;0
WireConnection;71;0;61;0
WireConnection;71;1;63;0
WireConnection;62;0;56;0
WireConnection;62;2;55;0
WireConnection;73;0;267;2
WireConnection;73;1;68;0
WireConnection;72;0;267;1
WireConnection;72;1;67;0
WireConnection;148;0;151;0
WireConnection;148;1;146;0
WireConnection;25;1;24;0
WireConnection;346;0;343;0
WireConnection;145;0;148;0
WireConnection;145;1;146;0
WireConnection;145;2;147;0
WireConnection;84;0;74;0
WireConnection;84;1;72;0
WireConnection;84;2;73;0
WireConnection;158;0;71;0
WireConnection;158;2;62;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;348;0;241;0
WireConnection;348;1;346;0
WireConnection;348;2;347;0
WireConnection;341;0;342;0
WireConnection;341;1;27;0
WireConnection;341;2;340;0
WireConnection;144;0;145;0
WireConnection;75;0;158;0
WireConnection;98;0;84;0
WireConnection;98;1;87;0
WireConnection;31;0;346;0
WireConnection;31;1;341;0
WireConnection;230;0;98;0
WireConnection;230;1;348;0
WireConnection;97;0;92;0
WireConnection;97;1;93;0
WireConnection;242;0;31;0
WireConnection;242;1;243;0
WireConnection;124;0;230;0
WireConnection;124;1;113;0
WireConnection;214;0;242;0
WireConnection;214;1;28;0
WireConnection;214;2;215;0
WireConnection;114;0;97;0
WireConnection;32;0;124;0
WireConnection;32;1;121;0
WireConnection;33;1;30;0
WireConnection;33;0;214;0
WireConnection;221;0;114;0
WireConnection;221;1;222;0
WireConnection;35;0;32;0
WireConnection;137;0;221;0
WireConnection;34;0;33;0
WireConnection;354;1;355;0
WireConnection;354;2;351;1
WireConnection;353;0;356;0
WireConnection;353;2;351;2
WireConnection;140;1;361;0
WireConnection;140;0;138;0
WireConnection;349;5;350;0
WireConnection;352;1;357;0
WireConnection;352;2;351;3
WireConnection;327;0;337;0
WireConnection;337;2;54;4
WireConnection;337;1;322;0
WireConnection;317;0;302;0
WireConnection;317;1;320;0
WireConnection;316;0;317;0
WireConnection;316;1;315;0
WireConnection;321;0;316;0
WireConnection;322;0;360;0
WireConnection;322;1;319;0
WireConnection;322;2;321;0
WireConnection;0;0;139;0
WireConnection;0;1;349;0
WireConnection;0;2;157;0
WireConnection;0;3;352;0
WireConnection;0;4;353;0
WireConnection;0;5;354;0
WireConnection;0;10;54;4
WireConnection;0;11;140;0
ASEEND*/
//CHKSM=DF626961E6399AAE424573B6D2F9272050E7ED63