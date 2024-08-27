// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/Transparent/Leaves"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_Mode", Int) = 2
		_MainTex("MainTex", 2D) = "white" {}
		_MainTexColor("MainTexColor", Color) = (0.8018868,0.8018868,0.8018868,1)
		_TexEmission("TexEmission", Range( 0 , 1)) = 0.5
		_Desaturate("Desaturate", Range( 0 , 1)) = 0
		_LightDir("LightDir", Float) = 0
		_ShadowSmooth("ShadowSmooth", Range( 0 , 1)) = 0
		_ShadowIntensity("ShadowIntensity", Range( 0 , 1)) = 0.75
		_BlinnLightColor("BlinnLightColor", Color) = (0,0,0,0)
		_BlinnLightDir("BlinnLightDir", Float) = 0
		_BlinnSmooth("BlinnSmooth", Range( 0 , 1)) = 0
		[Enum(On,0,Off,1)]_VertexOffsetWorldPos("VertexOffsetWorldPos", Float) = 1
		_VertexOffsetMove_X("VertexOffsetMove_X", Float) = 0
		_VertexOffsetMove_Y("VertexOffsetMove_Y", Float) = 0
		_VertexOffsetMove_Z("VertexOffsetMove_Z", Float) = 0
		_VertexOffsetScale("VertexOffsetScale", Float) = 5
		[Enum(Off,0,On,1)]_VertexPosition("VertexPosition", Float) = 0
		_VertexOffsetMaskPos("VertexOffsetMaskPos", Float) = 0
		_VertexOffsetMaskSmooth("VertexOffsetMaskSmooth", Range( 0 , 5)) = 1
		_VertexOffsetIntensity("VertexOffsetIntensity", Range( 0 , 1)) = 0.1
		_LightIntensity("LightIntensity", Range( 0 , 5)) = 1
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
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull [_Cull_Mode]
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USEAO_ON
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			half3 worldNormal;
		};

		uniform int _Cull_Mode;
		uniform half _VertexOffsetWorldPos;
		uniform half _VertexOffsetMove_X;
		uniform half _VertexOffsetMove_Y;
		uniform half _VertexOffsetMove_Z;
		uniform half _VertexOffsetScale;
		uniform half _VertexOffsetMaskSmooth;
		uniform half _VertexOffsetMaskPos;
		uniform half _VertexOffsetIntensity;
		uniform half _VertexPosition;
		uniform half _ShadowIntensity;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform half _Desaturate;
		uniform half4 _MainTexColor;
		uniform half _ShadowSmooth;
		uniform half _LightDir;
		uniform half4 _BlinnLightColor;
		uniform half _BlinnSmooth;
		uniform half _BlinnLightDir;
		uniform half _AOIntensity;
		uniform half _AOsmooth;
		uniform half _AO_WorldPos;
		uniform half _AODirection;
		uniform half _AOposition;
		uniform half _AOAxisMinus;
		uniform half _LightIntensity;
		uniform half _TexEmission;
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
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			half3 worldToObj69 = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) ).xyz;
			half3 lerpResult268 = lerp( ase_worldPos , worldToObj69 , _VertexOffsetWorldPos);
			half3 break267 = lerpResult268;
			half3 appendResult84 = (half3(( break267.x + ( _Time.y * _VertexOffsetMove_X ) ) , ( break267.y + ( _Time.y * _VertexOffsetMove_Y ) ) , ( break267.z + ( _Time.y * _VertexOffsetMove_Z ) )));
			half simplePerlin3D98 = snoise( appendResult84*_VertexOffsetScale );
			simplePerlin3D98 = simplePerlin3D98*0.5 + 0.5;
			half smoothstepResult236 = smoothstep( 0.0 , _VertexOffsetMaskSmooth , ( v.texcoord.xy.y + _VertexOffsetMaskPos ));
			half VertexOffsetMask240 = smoothstepResult236;
			half3 ase_vertexNormal = v.normal.xyz;
			half3 temp_cast_0 = (1.0).xxx;
			float3 ase_vertex3Pos = v.vertex.xyz;
			half3 lerpResult303 = lerp( temp_cast_0 , ( ase_vertex3Pos * half3(1,1,0) ) , _VertexPosition);
			half3 VertexOffset35 = ( ( ( simplePerlin3D98 * VertexOffsetMask240 ) * _VertexOffsetIntensity ) * ase_vertexNormal * lerpResult303 );
			v.vertex.xyz += VertexOffset35;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			half4 tex2DNode54 = tex2D( _MainTex, uv_MainTex );
			half3 desaturateInitialColor61 = tex2DNode54.rgb;
			half desaturateDot61 = dot( desaturateInitialColor61, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar61 = lerp( desaturateInitialColor61, desaturateDot61.xxx, _Desaturate );
			half3 ase_worldNormal = i.worldNormal;
			half3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			half3 ase_worldlightDir = 0;
			#else //aseld
			half3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			half dotResult143 = dot( ase_normWorldNormal , ase_worldlightDir );
			half smoothstepResult152 = smoothstep( 0.0 , _ShadowSmooth , ( dotResult143 + _LightDir ));
			half MainLight149 = smoothstepResult152;
			half4 lerpResult145 = lerp( half4( ( _ShadowIntensity * desaturateVar61 ) , 0.0 ) , ( half4( desaturateVar61 , 0.0 ) * _MainTexColor ) , MainLight149);
			half4 MainTexture144 = lerpResult145;
			half3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			half dotResult52 = dot( ase_normWorldNormal , ase_worldViewDir );
			half smoothstepResult62 = smoothstep( 0.0 , _BlinnSmooth , ( dotResult52 + _BlinnLightDir ));
			half4 lerpResult158 = lerp( ( half4( desaturateVar61 , 0.0 ) * _BlinnLightColor ) , float4( 0,0,0,0 ) , smoothstepResult62);
			half4 BlinnLight75 = lerpResult158;
			half4 temp_cast_4 = (0.0).xxxx;
			half3 worldToObj69 = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) ).xyz;
			half3 lerpResult270 = lerp( worldToObj69 , ase_worldPos , _AO_WorldPos);
			half3 break272 = lerpResult270;
			half lerpResult209 = lerp( break272.y , break272.z , _AODirection);
			half smoothstepResult179 = smoothstep( 0.0 , _AOsmooth , ( lerpResult209 + _AOposition ));
			half lerpResult226 = lerp( smoothstepResult179 , ( 1.0 - smoothstepResult179 ) , _AOAxisMinus);
			half4 lerpResult201 = lerp( float4( 0,0,0,0 ) , ( lerpResult145 * _AOIntensity ) , saturate( lerpResult226 ));
			half4 AO186 = lerpResult201;
			#ifdef _USEAO_ON
				half4 staticSwitch276 = AO186;
			#else
				half4 staticSwitch276 = temp_cast_4;
			#endif
			half4 ShadowCastDepart290 = ( saturate( ( MainTexture144 + BlinnLight75 + staticSwitch276 ) ) * _LightIntensity );
			half4 temp_output_139_0 = ShadowCastDepart290;
			o.Albedo = temp_output_139_0.rgb;
			o.Emission = ( ShadowCastDepart290 * _TexEmission ).rgb;
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
2560;0;2560;1419;2347.925;1257.695;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;14;-2857.316,158.1333;Inherit;False;2220.385;720.7875;VertexOffset;37;69;267;60;35;32;124;121;230;113;241;240;98;84;87;74;73;72;236;70;67;68;231;64;65;237;66;59;228;268;269;297;302;303;304;305;306;307;VertexOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;60;-2852.235,218.7981;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;187;-2632.89,929.5422;Inherit;False;1984.121;365.8573;AO;17;272;208;186;201;184;190;226;200;182;227;179;177;180;178;209;270;271;AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;271;-2616.628,1133.131;Inherit;False;Property;_AO_WorldPos;AO_WorldPos;23;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;13;-4069.971,-289.1175;Inherit;False;919.1312;420.9999;MainLight;8;155;154;153;152;149;143;50;156;MainLight;1,1,1,1;0;0
Node;AmplifyShaderEditor.TransformPositionNode;69;-2670.888,307.4071;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;270;-2471.244,1019.884;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;50;-4038.971,-246.1176;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;156;-4042.972,-39.1179;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;208;-2256.423,1088.446;Inherit;False;Property;_AODirection;AODirection;24;1;[Enum];Create;True;0;2;Axis Y;0;Axis Z;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;143;-3795.744,-184.8594;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-3794.672,-68.39268;Inherit;False;Property;_LightDir;LightDir;6;0;Create;True;0;0;0;False;0;False;0;-0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;272;-2326.807,972.8344;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;11;-3421.965,-856.9095;Inherit;False;1389.029;520.842;MainTexture;11;57;46;54;144;145;147;146;148;151;61;150;MainTexture;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;153;-3645.893,-166.673;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-3380.874,-678.1081;Inherit;False;0;54;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;154;-3801.966,26.88233;Inherit;False;Property;_ShadowSmooth;ShadowSmooth;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;209;-2094.423,996.4462;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;178;-2060.893,1119.542;Inherit;False;Property;_AOposition;AOposition;26;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;180;-2068.405,1202.678;Inherit;False;Property;_AOsmooth;AOsmooth;27;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-3152.517,-484.5034;Inherit;False;Property;_Desaturate;Desaturate;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;177;-1910.889,1030.542;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-3167.976,-694.4575;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;152;-3511.323,-160.1232;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;150;-2843.787,-524.6055;Inherit;False;Property;_MainTexColor;MainTexColor;3;0;Create;True;0;0;0;False;0;False;0.8018868,0.8018868,0.8018868,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;12;-3114.021,-284.3054;Inherit;False;1291.156;403.9842;Rim;10;75;158;63;71;62;56;55;53;52;48;Rim;1,1,1,1;0;0
Node;AmplifyShaderEditor.DesaturateOpNode;61;-2831.323,-654.3871;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;179;-1781.402,1029.678;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;149;-3352.559,-153.0164;Inherit;False;MainLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-2894.251,-784.025;Inherit;False;Property;_ShadowIntensity;ShadowIntensity;8;0;Create;True;0;0;0;False;0;False;0.75;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-2612.098,-744.5632;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-2612.788,-630.6052;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-1649.441,1177.821;Inherit;False;Property;_AOAxisMinus;AOAxisMinus;25;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;-2596.865,-515.7278;Inherit;False;149;MainLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;182;-1618.402,1089.678;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;48;-3076.817,-146.9602;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;226;-1438.441,1029.821;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;52;-2902.238,-234.3051;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;200;-1455.195,1178.838;Inherit;False;Property;_AOIntensity;AOIntensity;28;0;Create;True;0;0;0;False;0;False;-0.35;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2852.353,-95.73058;Inherit;False;Property;_BlinnLightDir;BlinnLightDir;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;145;-2459.788,-680.6052;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;269;-2698.115,470.0349;Inherit;False;Property;_VertexOffsetWorldPos;VertexOffsetWorldPos;12;1;[Enum];Create;True;0;2;On;0;Off;1;0;True;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-2794.83,-3.67565;Inherit;False;Property;_BlinnSmooth;BlinnSmooth;11;0;Create;True;0;0;0;False;0;False;0;0.35;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;190;-1183.161,1035.879;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-1174.17,1122.199;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;63;-2490.043,-61.22764;Inherit;False;Property;_BlinnLightColor;BlinnLightColor;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-2698.627,-231.334;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-2412.914,696.4374;Inherit;False;Property;_VertexOffsetMove_Y;VertexOffsetMove_Y;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;65;-2446.659,471.419;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;228;-1994.621,677.5593;Inherit;False;Property;_VertexOffsetMaskPos;VertexOffsetMaskPos;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-2382.914,772.4373;Inherit;False;Property;_VertexOffsetMove_Z;VertexOffsetMove_Z;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;305;-1980.925,559.3047;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;201;-1036.928,1042.08;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-2350.051,-197.8658;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;62;-2537.626,-195.334;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-2453.914,619.4374;Inherit;False;Property;_VertexOffsetMove_X;VertexOffsetMove_X;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;268;-2469.115,220.0348;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;267;-2286.522,224.7327;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-2207.653,380.3579;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;231;-1698.621,577.5594;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-2196.583,480.8453;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2162.273,583.1133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;186;-879.452,1047.366;Inherit;False;AO;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-1837.626,752.7692;Inherit;False;Property;_VertexOffsetMaskSmooth;VertexOffsetMaskSmooth;19;0;Create;True;0;0;0;False;0;False;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;273;-1984.184,-870.1185;Inherit;False;1084.15;509.9542;LightMix;10;290;289;287;281;279;277;278;276;275;274;LightMix;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;158;-2188.288,-169.5881;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-2011.777,-124.6239;Inherit;False;BlinnLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;275;-1943.398,-613.0071;Inherit;False;Constant;_Float0;Float 0;52;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;236;-1510.626,593.7695;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-2011.274,460.1115;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;-1959.182,-510.1752;Inherit;False;186;AO;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-2031.558,349.2499;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-2214.443,-663.9097;Inherit;False;MainTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-2037.695,247.5936;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;240;-1377.568,769.4482;Inherit;False;VertexOffsetMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;84;-1831.268,258.1986;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-1848.273,424.1113;Inherit;False;Property;_VertexOffsetScale;VertexOffsetScale;16;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;276;-1802.65,-613.9016;Inherit;False;Property;_UseAO;UseAO;22;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;278;-1803.618,-691.6163;Inherit;False;75;BlinnLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;277;-1809.26,-771.6544;Inherit;False;144;MainTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;279;-1616.65,-702.6173;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;98;-1608.955,246.2258;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;-1606.728,356.8939;Inherit;False;240;VertexOffsetMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;307;-1247.925,619.3047;Inherit;False;Constant;_Vector0;Vector 0;30;0;Create;True;0;0;0;False;0;False;1,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;297;-1263.516,479.7064;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;230;-1339.839,248.8573;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-1540.748,454.9872;Inherit;False;Property;_VertexOffsetIntensity;VertexOffsetIntensity;20;0;Create;True;0;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;302;-1078.55,677.3881;Inherit;False;Property;_VertexPosition;VertexPosition;17;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;281;-1450.098,-689.5952;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;287;-1532.34,-542.0325;Inherit;False;Property;_LightIntensity;LightIntensity;21;0;Create;True;0;0;0;False;0;False;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;-1076.925,549.3047;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;304;-1046.55,460.3881;Inherit;False;Constant;_Float1;Float 1;31;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;121;-1204.665,342.599;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-1196.665,250.5835;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;303;-905.5498,470.3881;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;-1288.675,-692.3318;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-967.2493,250.4084;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;290;-1122.206,-693.4883;Inherit;False;ShadowCastDepart;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-822.4431,256.6852;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;295;-482.024,112.2529;Inherit;False;Property;_TexEmission;TexEmission;4;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2;226.0997,55.90039;Inherit;False;225;166;Cull Mode;1;9;Cull Mode;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-458.6304,-45.37741;Inherit;False;290;ShadowCastDepart;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;294;-170.024,105.2529;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-227.3428,381.4082;Inherit;False;35;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;9;276.0997,105.9002;Inherit;False;Property;_Cull_Mode;Cull_Mode;1;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-3,55;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Koakuma/Transparent/Leaves;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;9;-1;0;False;267;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;69;0;60;0
WireConnection;270;0;69;0
WireConnection;270;1;60;0
WireConnection;270;2;271;0
WireConnection;143;0;50;0
WireConnection;143;1;156;0
WireConnection;272;0;270;0
WireConnection;153;0;143;0
WireConnection;153;1;155;0
WireConnection;209;0;272;1
WireConnection;209;1;272;2
WireConnection;209;2;208;0
WireConnection;177;0;209;0
WireConnection;177;1;178;0
WireConnection;54;1;46;0
WireConnection;152;0;153;0
WireConnection;152;2;154;0
WireConnection;61;0;54;0
WireConnection;61;1;57;0
WireConnection;179;0;177;0
WireConnection;179;2;180;0
WireConnection;149;0;152;0
WireConnection;148;0;151;0
WireConnection;148;1;61;0
WireConnection;146;0;61;0
WireConnection;146;1;150;0
WireConnection;182;0;179;0
WireConnection;226;0;179;0
WireConnection;226;1;182;0
WireConnection;226;2;227;0
WireConnection;52;0;50;0
WireConnection;52;1;48;0
WireConnection;145;0;148;0
WireConnection;145;1;146;0
WireConnection;145;2;147;0
WireConnection;190;0;226;0
WireConnection;184;0;145;0
WireConnection;184;1;200;0
WireConnection;56;0;52;0
WireConnection;56;1;53;0
WireConnection;201;1;184;0
WireConnection;201;2;190;0
WireConnection;71;0;61;0
WireConnection;71;1;63;0
WireConnection;62;0;56;0
WireConnection;62;2;55;0
WireConnection;268;0;60;0
WireConnection;268;1;69;0
WireConnection;268;2;269;0
WireConnection;267;0;268;0
WireConnection;70;0;65;2
WireConnection;70;1;66;0
WireConnection;231;0;305;2
WireConnection;231;1;228;0
WireConnection;67;0;65;2
WireConnection;67;1;64;0
WireConnection;68;0;65;2
WireConnection;68;1;59;0
WireConnection;186;0;201;0
WireConnection;158;0;71;0
WireConnection;158;2;62;0
WireConnection;75;0;158;0
WireConnection;236;0;231;0
WireConnection;236;2;237;0
WireConnection;73;0;267;2
WireConnection;73;1;68;0
WireConnection;72;0;267;1
WireConnection;72;1;67;0
WireConnection;144;0;145;0
WireConnection;74;0;267;0
WireConnection;74;1;70;0
WireConnection;240;0;236;0
WireConnection;84;0;74;0
WireConnection;84;1;72;0
WireConnection;84;2;73;0
WireConnection;276;1;275;0
WireConnection;276;0;274;0
WireConnection;279;0;277;0
WireConnection;279;1;278;0
WireConnection;279;2;276;0
WireConnection;98;0;84;0
WireConnection;98;1;87;0
WireConnection;230;0;98;0
WireConnection;230;1;241;0
WireConnection;281;0;279;0
WireConnection;306;0;297;0
WireConnection;306;1;307;0
WireConnection;124;0;230;0
WireConnection;124;1;113;0
WireConnection;303;0;304;0
WireConnection;303;1;306;0
WireConnection;303;2;302;0
WireConnection;289;0;281;0
WireConnection;289;1;287;0
WireConnection;32;0;124;0
WireConnection;32;1;121;0
WireConnection;32;2;303;0
WireConnection;290;0;289;0
WireConnection;35;0;32;0
WireConnection;294;0;139;0
WireConnection;294;1;295;0
WireConnection;0;0;139;0
WireConnection;0;2;294;0
WireConnection;0;10;54;4
WireConnection;0;11;138;0
ASEEND*/
//CHKSM=B549674C24672840F2511BE4D938AF54684F00A1