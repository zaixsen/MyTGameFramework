// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/Geometrys"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_Mode", Int) = 2
		[Toggle(_USEMAINTEXWORLDUV_ON)] _UseMainTexWorldUV("UseMainTexWorldUV", Float) = 0
		[Enum(Off,0,On,1)]_UseMainTexture("UseMainTexture", Float) = 1
		_MainTex("MainTex", 2D) = "white" {}
		_MainTexColor("MainTexColor", Color) = (1,1,1,1)
		_TexEmission("TexEmission", Range( 0 , 1)) = 0.5
		_WorldMainTexTiling("WorldMainTexTiling", Float) = 1
		_WorldMainTextureRollX("WorldMainTextureRollX", Float) = 0
		_WorldMainTextureRollY("WorldMainTextureRollY", Float) = 0
		_Desaturate("Desaturate", Range( 0 , 1)) = 0
		[Toggle(_USEMASKEMISSIONTEXTURE_ON)] _UseMaskEmissionTexture("UseMaskEmissionTexture", Float) = 0
		_MaskEmissionTexture("MaskEmissionTexture", 2D) = "white" {}
		_MaskEmissionTexColor("MaskEmissionTexColor", Color) = (0.6862745,0.6862745,0.6862745,1)
		_MaskColorHDR("MaskColorHDR", Float) = 1
		_MaskPower("MaskPower", Float) = 2
		_MaskEmissionNoiseRollX("MaskEmissionNoiseRollX", Float) = 0
		_MaskEmissionNoiseRollY("MaskEmissionNoiseRollY", Float) = 0
		_MaskEmissionNoiseScale("MaskEmissionNoiseScale", Float) = 5
		_ShadowColor("ShadowColor", Color) = (1,1,1,0)
		_LightDir("LightDir", Range( -1 , 1)) = 0
		_ShadowSmooth("ShadowSmooth", Range( 0 , 1)) = 0
		_ShadowIntensity("ShadowIntensity", Range( 0 , 1)) = 0.75
		_RimLightColor("RimLightColor", Color) = (0.3921569,0.3921569,0.3921569,0)
		_RimLightDir("RimLightDir", Range( -1 , 1)) = 0
		_RimSmooth("RimSmooth", Range( 0 , 1)) = 0
		_LightIntensity("LightIntensity", Range( 0 , 5)) = 1
		_NoiseRoll_X("NoiseRoll_X", Float) = 0
		_NoiseRoll_Y("NoiseRoll_Y", Float) = 0
		_NoiseRoll_Z("NoiseRoll_Z", Float) = 0
		[Enum(TexClip,0,DissolveClip,1)]_TexClipStyle("TexClipStyle", Float) = 0
		[Toggle(_USETEXTUREDISSOLVE_ON)] _UseTextureDissolve("UseTextureDissolve", Float) = 0
		[Enum(Horizontal,0,Vertical,1)]_DissolveTexDir("DissolveTexDir", Float) = 1
		[Enum(Off,0,On,1)]_DissolveTexDirMinus("DissolveTexDirMinus", Float) = 0
		_NoiseScale("NoiseScale", Float) = 5
		_Dissolve("Dissolve", Range( 0 , 1)) = 0
		[Toggle(_USETEXTUREDEDGELIGHT_ON)] _UseTexturedEdgeLight("UseTexturedEdgeLight", Float) = 0
		[HDR]_EdgeColor("EdgeColor", Color) = (1,0.5294118,0,0)
		_EdgeWidth("EdgeWidth", Float) = -0.05
		[Toggle(_USEAO_ON)] _UseAO("UseAO", Float) = 0
		[Enum(Off,0,On,1)]_AO_WorldPos("AO_WorldPos", Float) = 0
		[Enum(Axis Y,0,Axis Z,1)]_AODirection("AODirection", Float) = 0
		[Enum(Off,0,On,1)]_AOAxisMinus("AOAxisMinus", Float) = 1
		_AOposition("AOposition", Float) = 0
		_AOsmooth("AOsmooth", Range( 0 , 1)) = 1
		_AOIntensity("AOIntensity", Range( -1 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull [_Cull_Mode]
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USEMAINTEXWORLDUV_ON
		#pragma shader_feature_local _USEAO_ON
		#pragma shader_feature_local _USEMASKEMISSIONTEXTURE_ON
		#pragma shader_feature_local _USETEXTUREDEDGELIGHT_ON
		#pragma shader_feature_local _USETEXTUREDISSOLVE_ON
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			half3 worldNormal;
		};

		uniform int _Cull_Mode;
		uniform half _ShadowIntensity;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform half _WorldMainTextureRollX;
		uniform half _WorldMainTextureRollY;
		uniform half _WorldMainTexTiling;
		uniform half _UseMainTexture;
		uniform half _Desaturate;
		uniform half4 _ShadowColor;
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
		uniform half _LightIntensity;
		uniform sampler2D _MaskEmissionTexture;
		uniform half4 _MaskEmissionTexture_ST;
		uniform half _MaskEmissionNoiseRollX;
		uniform half _MaskEmissionNoiseRollY;
		uniform half _MaskEmissionNoiseScale;
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
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
			half3 ase_worldNormal = i.worldNormal;
			half3 ase_normWorldNormal = normalize( ase_worldNormal );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			half3 ase_worldlightDir = 0;
			#else //aseld
			half3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			half dotResult143 = dot( ase_normWorldNormal , ( ase_worldlightDir + _LightDir ) );
			half smoothstepResult152 = smoothstep( 0.0 , _ShadowSmooth , dotResult143);
			half MainLight149 = smoothstepResult152;
			half4 lerpResult145 = lerp( ( _ShadowIntensity * half4( desaturateVar61 , 0.0 ) * _ShadowColor ) , ( half4( desaturateVar61 , 0.0 ) * _MainTexColor ) , MainLight149);
			half4 MainTexture144 = lerpResult145;
			half3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			half dotResult52 = dot( ase_normWorldNormal , ( ase_worldViewDir + _RimLightDir ) );
			half smoothstepResult62 = smoothstep( 0.0 , _RimSmooth , dotResult52);
			half4 lerpResult158 = lerp( ( half4( desaturateVar61 , 0.0 ) * _RimLightColor ) , float4( 0,0,0,0 ) , smoothstepResult62);
			half4 BlinnLight75 = lerpResult158;
			half4 temp_cast_5 = (0.0).xxxx;
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
				half4 staticSwitch206 = temp_cast_5;
			#endif
			half4 ShadowCastDepart137 = ( saturate( ( MainTexture144 + BlinnLight75 + staticSwitch206 ) ) * _LightIntensity );
			half4 temp_output_328_0 = ShadowCastDepart137;
			o.Albedo = temp_output_328_0.rgb;
			half4 temp_cast_7 = (0.0).xxxx;
			float2 uv_MaskEmissionTexture = i.uv_texcoord * _MaskEmissionTexture_ST.xy + _MaskEmissionTexture_ST.zw;
			half2 appendResult24 = (half2(( _Time.y * _MaskEmissionNoiseRollX ) , ( _Time.y * _MaskEmissionNoiseRollY )));
			float2 uv_TexCoord25 = i.uv_texcoord + appendResult24;
			half simplePerlin3D27 = snoise( half3( uv_TexCoord25 ,  0.0 )*_MaskEmissionNoiseScale );
			simplePerlin3D27 = simplePerlin3D27*0.5 + 0.5;
			#ifdef _USEMASKEMISSIONTEXTURE_ON
				half4 staticSwitch33 = ( pow( ( tex2D( _MaskEmissionTexture, uv_MaskEmissionTexture ).r * simplePerlin3D27 ) , _MaskPower ) * _MaskEmissionTexColor * _MaskColorHDR );
			#else
				half4 staticSwitch33 = temp_cast_7;
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
			o.Emission = ( MaskEmission34 + EdgeLight174 + ( ShadowCastDepart137 * _TexEmission ) ).rgb;
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
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
7;6;2546;1373;2866.188;118.9132;1.240022;True;True
Node;AmplifyShaderEditor.CommentaryNode;11;-4106.814,-1032.799;Inherit;False;2456.767;730.1064;MainTexture;27;144;145;147;148;146;150;61;151;57;212;54;51;213;49;47;46;45;44;42;43;39;40;41;37;38;36;350;MainTexture;1,1,1,1;0;0
Node;AmplifyShaderEditor.TimeNode;37;-4018.107,-644.1999;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-4073.107,-485.1999;Inherit;False;Property;_WorldMainTextureRollX;WorldMainTextureRollX;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-4078.107,-409.2;Inherit;False;Property;_WorldMainTextureRollY;WorldMainTextureRollY;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-3827.108,-489.2;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-3832.108,-608.1999;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;41;-3907.92,-792.0135;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;187;-2319.482,906.9388;Inherit;False;2093.701;544.578;AO;19;186;201;190;184;200;226;182;227;179;180;177;209;178;208;272;270;271;60;69;AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;60;-2305.332,1111.268;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-3687.964,-596.8827;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-3690.964,-707.8827;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;-3555.964,-595.8827;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TransformPositionNode;69;-2145.809,967.9502;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;45;-3631.03,-498.9676;Inherit;False;Property;_WorldMainTexTiling;WorldMainTexTiling;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;13;-3903.996,-287.1876;Inherit;False;919.1312;420.9999;MainLight;8;155;154;153;152;149;143;50;156;MainLight;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;271;-2184.164,1262.817;Inherit;False;Property;_AO_WorldPos;AO_WorldPos;40;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-3520.472,-728.5074;Inherit;False;0;54;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;270;-2010.86,1141.211;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;47;-3423.03,-595.9676;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;156;-3879.997,-104.188;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;155;-3876.697,44.53726;Inherit;False;Property;_LightDir;LightDir;20;0;Create;True;0;0;0;False;0;False;0;-0.35;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;49;-3301.374,-657.5785;Inherit;False;Property;_UseMainTexWorldUV;UseMainTexWorldUV;2;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;272;-1864.421,1062.161;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WorldNormalVector;50;-3872.996,-244.1877;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;153;-3632.918,-92.74305;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;208;-1806.037,1189.773;Inherit;False;Property;_AODirection;AODirection;41;1;[Enum];Create;True;0;2;Axis Y;0;Axis Z;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-3568.991,37.81227;Inherit;False;Property;_ShadowSmooth;ShadowSmooth;21;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;143;-3497.769,-163.9295;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;213;-2940.472,-478.042;Inherit;False;Property;_UseMainTexture;UseMainTexture;3;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-2883.219,-770.8435;Inherit;False;Constant;_Notex;Notex;55;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;209;-1644.037,1097.773;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-3035.461,-685.1313;Inherit;True;Property;_MainTex;MainTex;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;178;-1610.507,1220.869;Inherit;False;Property;_AOposition;AOposition;43;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;180;-1618.019,1304.005;Inherit;False;Property;_AOsmooth;AOsmooth;44;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;177;-1460.507,1131.869;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;152;-3345.348,-158.1933;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-2747.002,-544.1772;Inherit;False;Property;_Desaturate;Desaturate;10;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;212;-2680.472,-676.0423;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;179;-1331.02,1131.005;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;150;-2435.272,-548.2792;Inherit;False;Property;_MainTexColor;MainTexColor;5;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;149;-3186.584,-151.0865;Inherit;False;MainLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;12;-2926.545,-280.998;Inherit;False;1291.156;403.9842;Rim;10;75;158;63;71;62;56;55;53;52;48;Rim;1,1,1,1;0;0
Node;AmplifyShaderEditor.DesaturateOpNode;61;-2524.272,-660.2789;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;350;-2446.376,-882.8335;Inherit;False;Property;_ShadowColor;ShadowColor;19;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;151;-2459.477,-986.9144;Inherit;False;Property;_ShadowIntensity;ShadowIntensity;22;0;Create;True;0;0;0;False;0;False;0.75;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;16;-4122.473,169.1423;Inherit;False;1713.8;791.1955;dissolve;28;135;131;205;103;203;127;128;126;125;115;117;204;108;106;104;107;105;85;95;89;91;79;202;78;81;77;80;76;Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-2179.583,-750.2369;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-2186.273,-640.2789;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-1199.059,1279.148;Inherit;False;Property;_AOAxisMinus;AOAxisMinus;42;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;48;-2841.341,-170.6528;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;53;-2913.877,-14.42316;Inherit;False;Property;_RimLightDir;RimLightDir;24;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;-2209.929,-488.5836;Inherit;False;149;MainLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;182;-1168.02,1191.005;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;79;-4098.047,231.2189;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;76;-4033.874,693.5101;Inherit;False;Property;_NoiseRoll_Z;NoiseRoll_Z;29;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;15;-3817.706,-1706.976;Inherit;False;1753.899;618.5481;EmissionMask;19;33;31;30;29;28;27;26;25;24;23;22;21;20;19;214;215;242;243;34;EmissionMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-4053.364,545.3341;Inherit;False;Property;_NoiseRoll_X;NoiseRoll_X;27;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;200;-1004.814,1280.165;Inherit;False;Property;_AOIntensity;AOIntensity;45;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-2671.151,-154.0266;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-4047.399,620.6813;Inherit;False;Property;_NoiseRoll_Y;NoiseRoll_Y;28;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;226;-988.0596,1131.148;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;145;-2028.271,-662.279;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TimeNode;78;-4097.471,402.8389;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;202;-3978.098,879.6118;Inherit;False;Property;_DissolveTexDir;DissolveTexDir;32;1;[Enum];Create;True;0;2;Horizontal;0;Vertical;1;0;True;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;52;-2526.762,-236.9977;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;89;-3928.695,232.828;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-3850.863,587.0941;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;20;-3732.942,-1463.946;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-3867.457,382.7781;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-3787.633,-1241.961;Inherit;False;Property;_MaskEmissionNoiseRollY;MaskEmissionNoiseRollY;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-3856.389,484.266;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;77;-4059.046,765.2372;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-3788.706,-1320.246;Inherit;False;Property;_MaskEmissionNoiseRollX;MaskEmissionNoiseRollX;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;63;-2325.567,-62.92022;Inherit;False;Property;_RimLightColor;RimLightColor;23;0;Create;True;0;0;0;False;0;False;0.3921569,0.3921569,0.3921569,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;55;-2623.354,-1.368237;Inherit;False;Property;_RimSmooth;RimSmooth;25;0;Create;True;0;0;0;False;0;False;0;0.35;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-723.7882,1223.526;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;190;-767.7791,1130.206;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-3532.405,-1289.147;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;203;-3785.098,711.6118;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-3686.823,572.6701;Inherit;False;Property;_Dissolve;Dissolve;35;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-3535.62,-1393.169;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;201;-586.5463,1143.406;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;-3696.365,374.6702;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;-3689.366,471.302;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-2137.575,-186.5583;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;62;-2350.15,-192.0266;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;-3702.501,273.0147;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;175;-4019.011,993.9269;Inherit;False;1612.392;458.1671;EdgeLight;12;164;165;163;169;170;168;171;167;172;173;174;166;EdgeLight;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;115;-3543.074,280.619;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-3564.09,404.2131;Inherit;False;Property;_NoiseScale;NoiseScale;34;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;108;-3373.97,547.9616;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.075;False;4;FLOAT;1.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;103;-3631.402,769.8262;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;17;-1616.26,-848.3229;Inherit;False;1104.15;505.9542;LightMix;10;137;129;114;222;97;93;206;92;207;188;LightMix;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-3390.849,-1326.68;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;186;-429.0703,1148.693;Inherit;False;AO;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;158;-1987.812,-170.2807;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;205;-3693.098,844.6118;Inherit;False;Property;_DissolveTexDirMinus;DissolveTexDirMinus;33;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;-3969.011,1171.458;Inherit;False;Property;_EdgeWidth;EdgeWidth;38;0;Create;True;0;0;0;False;0;False;-0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;164;-3648.025,1086.076;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;169;-3639.692,1292.51;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;125;-3397.76,278.6461;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-3422.771,-1187.265;Inherit;False;Property;_MaskEmissionNoiseScale;MaskEmissionNoiseScale;18;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;204;-3465.098,718.6118;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-3272.244,-1436.089;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;188;-1591.258,-465.3798;Inherit;False;186;AO;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;207;-1575.474,-568.2117;Inherit;False;Constant;_Float0;Float 0;52;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-1866.927,-665.5835;Inherit;False;MainTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-1824.301,-121.3165;Inherit;False;BlinnLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-1441.336,-726.859;Inherit;False;144;MainTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;206;-1434.726,-569.1061;Inherit;False;Property;_UseAO;UseAO;39;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;126;-3178.371,610.7481;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;165;-3477.828,1060.976;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-3278.427,-1661.553;Inherit;True;Property;_MaskEmissionTexture;MaskEmissionTexture;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;93;-1435.694,-646.821;Inherit;False;75;BlinnLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;27;-3138.283,-1292.08;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;128;-3121.455,354.0485;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;170;-3476.495,1264.41;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;166;-3330.005,1068.926;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;168;-3332.672,1256.36;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;243;-2982.717,-1436.435;Inherit;False;Property;_MaskPower;MaskPower;15;0;Create;True;0;0;0;False;0;False;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-2985.818,-1552.74;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-1248.726,-657.822;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;114;-1100.174,-625.8996;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;222;-1186.616,-520.3372;Inherit;False;Property;_LightIntensity;LightIntensity;26;0;Create;True;0;0;0;False;0;False;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;-2944.653,-1357.299;Inherit;False;Property;_MaskEmissionTexColor;MaskEmissionTexColor;13;0;Create;True;0;0;0;False;0;False;0.6862745,0.6862745,0.6862745,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;215;-2727.215,-1291.421;Inherit;False;Property;_MaskColorHDR;MaskColorHDR;14;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;171;-3190.619,1133.093;Inherit;False;Property;_UseTexturedEdgeLight;UseTexturedEdgeLight;36;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;242;-2836.717,-1553.435;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;173;-2984.619,1240.093;Inherit;False;Property;_EdgeColor;EdgeColor;37;1;[HDR];Create;True;0;0;0;False;0;False;1,0.5294118,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;-2688.964,-1555.281;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-3026.242,582.5943;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2691.872,-1628.962;Inherit;False;Constant;_Float1;Float 1;48;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;167;-2901.243,1136.915;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-919.35,-628.7363;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-740.881,-631.6927;Inherit;False;ShadowCastDepart;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;33;-2559.526,-1569.56;Inherit;False;Property;_UseMaskEmissionTexture;UseMaskEmissionTexture;11;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;-2770.619,1140.093;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;131;-2888.837,412.5279;Inherit;False;Property;_UseTextureDissolve;UseTextureDissolve;31;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;349;-650.658,162.3522;Inherit;False;Property;_TexEmission;TexEmission;6;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;174;-2625.348,1142.186;Inherit;False;EdgeLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-2264.808,-1564.632;Inherit;False;MaskEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;135;-2613.22,415.5406;Inherit;False;Dissolve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;328;-521.9688,-226.4912;Inherit;False;137;ShadowCastDepart;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;2;226.0997,55.90039;Inherit;False;225;166;Cull Mode;1;9;Cull Mode;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;345;-344.658,145.3522;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-460.8129,291.4292;Inherit;False;135;Dissolve;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;-433.5505,-16.2446;Inherit;False;34;MaskEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;-417.8899,63.12;Inherit;False;174;EdgeLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-456.0086,370.8999;Inherit;False;Property;_TexClipStyle;TexClipStyle;30;1;[Enum];Create;True;0;2;TexClip;0;DissolveClip;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;329;-2323.406,212.2321;Inherit;False;1508.936;462.012;Outline;10;327;337;319;322;321;315;316;317;320;302;Outline;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;302;-2239.145,356.2756;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;327;-1042.469,448.8889;Inherit;False;OutLine;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;319;-1816.776,565.244;Inherit;False;Property;_OutlineWidth;OutlineWidth;46;0;Create;True;0;0;0;False;0;False;0.05;-0.05;0;0.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;321;-1719.645,450.3665;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;224;-201.1395,279.8536;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OutlineNode;337;-1363.122,447.2499;Inherit;False;0;False;None;0;0;Front;True;True;True;True;0;False;-1;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;315;-2041.824,558.6072;Inherit;False;Constant;_OutlineViewDistance;OutlineViewDistance;64;0;Create;True;0;0;0;False;0;False;32;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;344;-201.6985,409.8416;Inherit;False;327;OutLine;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;9;276.0997,105.9002;Inherit;False;Property;_Cull_Mode;Cull_Mode;1;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.DistanceOpNode;317;-2031.446,432.4274;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;322;-1554.117,452.3444;Inherit;False;3;0;FLOAT;0.005;False;1;FLOAT;0.1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SurfaceDepthNode;320;-2303.406,521.311;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;141;-186.2008,63.93652;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;316;-1855.821,448.4341;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-3,55;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Koakuma/Geometrys;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;9;-1;0;False;267;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;39;0;37;2
WireConnection;39;1;36;0
WireConnection;40;0;37;2
WireConnection;40;1;38;0
WireConnection;43;0;41;2
WireConnection;43;1;39;0
WireConnection;42;0;41;1
WireConnection;42;1;40;0
WireConnection;44;0;42;0
WireConnection;44;1;43;0
WireConnection;69;0;60;0
WireConnection;270;0;69;0
WireConnection;270;1;60;0
WireConnection;270;2;271;0
WireConnection;47;0;44;0
WireConnection;47;1;45;0
WireConnection;49;1;46;0
WireConnection;49;0;47;0
WireConnection;272;0;270;0
WireConnection;153;0;156;0
WireConnection;153;1;155;0
WireConnection;143;0;50;0
WireConnection;143;1;153;0
WireConnection;209;0;272;1
WireConnection;209;1;272;2
WireConnection;209;2;208;0
WireConnection;54;1;49;0
WireConnection;177;0;209;0
WireConnection;177;1;178;0
WireConnection;152;0;143;0
WireConnection;152;2;154;0
WireConnection;212;0;51;0
WireConnection;212;1;54;0
WireConnection;212;2;213;0
WireConnection;179;0;177;0
WireConnection;179;2;180;0
WireConnection;149;0;152;0
WireConnection;61;0;212;0
WireConnection;61;1;57;0
WireConnection;148;0;151;0
WireConnection;148;1;61;0
WireConnection;148;2;350;0
WireConnection;146;0;61;0
WireConnection;146;1;150;0
WireConnection;182;0;179;0
WireConnection;56;0;48;0
WireConnection;56;1;53;0
WireConnection;226;0;179;0
WireConnection;226;1;182;0
WireConnection;226;2;227;0
WireConnection;145;0;148;0
WireConnection;145;1;146;0
WireConnection;145;2;147;0
WireConnection;52;0;50;0
WireConnection;52;1;56;0
WireConnection;89;0;79;0
WireConnection;85;0;78;2
WireConnection;85;1;76;0
WireConnection;95;0;78;2
WireConnection;95;1;80;0
WireConnection;91;0;78;2
WireConnection;91;1;81;0
WireConnection;184;0;145;0
WireConnection;184;1;200;0
WireConnection;190;0;226;0
WireConnection;23;0;20;2
WireConnection;23;1;21;0
WireConnection;203;0;77;1
WireConnection;203;1;77;2
WireConnection;203;2;202;0
WireConnection;22;0;20;2
WireConnection;22;1;19;0
WireConnection;201;1;184;0
WireConnection;201;2;190;0
WireConnection;104;0;89;2
WireConnection;104;1;91;0
WireConnection;107;0;89;3
WireConnection;107;1;85;0
WireConnection;71;0;61;0
WireConnection;71;1;63;0
WireConnection;62;0;52;0
WireConnection;62;2;55;0
WireConnection;106;0;89;1
WireConnection;106;1;95;0
WireConnection;115;0;106;0
WireConnection;115;1;104;0
WireConnection;115;2;107;0
WireConnection;108;0;105;0
WireConnection;103;0;203;0
WireConnection;24;0;22;0
WireConnection;24;1;23;0
WireConnection;186;0;201;0
WireConnection;158;0;71;0
WireConnection;158;2;62;0
WireConnection;164;0;108;0
WireConnection;164;1;163;0
WireConnection;169;0;108;0
WireConnection;169;1;163;0
WireConnection;125;0;115;0
WireConnection;125;1;117;0
WireConnection;204;0;203;0
WireConnection;204;1;103;0
WireConnection;204;2;205;0
WireConnection;25;1;24;0
WireConnection;144;0;145;0
WireConnection;75;0;158;0
WireConnection;206;1;207;0
WireConnection;206;0;188;0
WireConnection;126;0;108;0
WireConnection;126;1;204;0
WireConnection;165;0;164;0
WireConnection;165;1;125;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;128;0;108;0
WireConnection;128;1;125;0
WireConnection;170;0;169;0
WireConnection;170;1;204;0
WireConnection;166;0;128;0
WireConnection;166;1;165;0
WireConnection;168;0;126;0
WireConnection;168;1;170;0
WireConnection;31;0;29;1
WireConnection;31;1;27;0
WireConnection;97;0;92;0
WireConnection;97;1;93;0
WireConnection;97;2;206;0
WireConnection;114;0;97;0
WireConnection;171;1;166;0
WireConnection;171;0;168;0
WireConnection;242;0;31;0
WireConnection;242;1;243;0
WireConnection;214;0;242;0
WireConnection;214;1;28;0
WireConnection;214;2;215;0
WireConnection;127;0;54;4
WireConnection;127;1;126;0
WireConnection;167;0;171;0
WireConnection;129;0;114;0
WireConnection;129;1;222;0
WireConnection;137;0;129;0
WireConnection;33;1;30;0
WireConnection;33;0;214;0
WireConnection;172;0;167;0
WireConnection;172;1;173;0
WireConnection;131;1;128;0
WireConnection;131;0;127;0
WireConnection;174;0;172;0
WireConnection;34;0;33;0
WireConnection;135;0;131;0
WireConnection;345;0;328;0
WireConnection;345;1;349;0
WireConnection;327;0;337;0
WireConnection;321;0;316;0
WireConnection;224;0;54;4
WireConnection;224;1;142;0
WireConnection;224;2;223;0
WireConnection;337;1;322;0
WireConnection;317;0;302;0
WireConnection;317;1;320;0
WireConnection;322;1;319;0
WireConnection;322;2;321;0
WireConnection;141;0;157;0
WireConnection;141;1;176;0
WireConnection;141;2;345;0
WireConnection;316;0;317;0
WireConnection;316;1;315;0
WireConnection;0;0;328;0
WireConnection;0;2;141;0
WireConnection;0;10;224;0
ASEEND*/
//CHKSM=749F5225FBFA3D35F8C59C5373BE3262277A1AD0