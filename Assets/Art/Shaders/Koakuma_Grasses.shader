// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/Transparent/Grasses"
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
		_VertexOffsetIntensity("VertexOffsetIntensity", Range( 0 , 2)) = 0.1
		_LightIntensity("LightIntensity", Range( 0 , 5)) = 1
		[Enum(Off,0,On,1)]_GrassCut("GrassCut", Float) = 0
		[Enum(Off,0,On,1)]_CutDirChange("CutDirChange", Float) = 0
		_CutPosition("CutPosition", Float) = 0.71
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull [_Cull_Mode]
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
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
		uniform half _LightIntensity;
		uniform half _TexEmission;
		uniform half _CutDirChange;
		uniform half _CutPosition;
		uniform half _GrassCut;
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
			half3 appendResult84 = (half3(( break267.x + ( _Time.y * _VertexOffsetMove_X ) ) , ( break267.z + ( _Time.y * _VertexOffsetMove_Y ) ) , ( _Time.y * _VertexOffsetMove_Z )));
			half simplePerlin3D98 = snoise( appendResult84*_VertexOffsetScale );
			half smoothstepResult236 = smoothstep( 0.0 , _VertexOffsetMaskSmooth , ( v.texcoord.xy.y + _VertexOffsetMaskPos ));
			half VertexOffsetMask240 = smoothstepResult236;
			half3 ase_vertexNormal = v.normal.xyz;
			half4 temp_cast_1 = (1.0).xxxx;
			float4 ase_vertex4Pos = v.vertex;
			half4 lerpResult337 = lerp( temp_cast_1 , ase_vertex4Pos , _VertexPosition);
			half4 VertexOffset35 = saturate( ( ( ( simplePerlin3D98 * VertexOffsetMask240 ) * _VertexOffsetIntensity ) * half4( ase_vertexNormal , 0.0 ) * lerpResult337 ) );
			v.vertex.xyz += VertexOffset35.xyz;
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
			half4 ShadowCastDepart290 = ( saturate( ( MainTexture144 + BlinnLight75 ) ) * _LightIntensity );
			half4 temp_output_139_0 = ShadowCastDepart290;
			o.Albedo = temp_output_139_0.rgb;
			o.Emission = ( ShadowCastDepart290 * _TexEmission ).rgb;
			o.Alpha = 1;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			half lerpResult302 = lerp( ( 1.0 - ase_vertex3Pos.y ) , ase_vertex3Pos.y , _CutDirChange);
			half lerpResult307 = lerp( 1.0 , step( 1.0 , ( lerpResult302 + _CutPosition ) ) , _GrassCut);
			clip( ( tex2DNode54.a * lerpResult307 ) - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

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
2560;0;2560;1419;4277.431;884.1761;2.106038;True;True
Node;AmplifyShaderEditor.CommentaryNode;13;-4069.971,-289.1175;Inherit;False;919.1312;420.9999;MainLight;8;155;154;153;152;149;143;50;156;MainLight;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;50;-4038.971,-246.1176;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;156;-4042.972,-39.1179;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;14;-2938.261,159.7522;Inherit;False;2331.782;719.7875;VertexOffset;35;35;338;32;124;337;324;113;335;230;323;334;98;241;240;84;87;73;68;74;236;59;70;67;231;237;267;64;268;66;65;228;269;69;60;340;VertexOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;143;-3795.744,-184.8594;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-3794.672,-68.39268;Inherit;False;Property;_LightDir;LightDir;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;11;-3421.965,-856.9095;Inherit;False;1389.029;520.842;MainTexture;11;57;46;54;144;145;147;146;148;151;61;150;MainTexture;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;12;-3114.021,-284.3054;Inherit;False;1291.156;403.9842;Rim;10;75;158;63;71;62;56;55;53;52;48;Rim;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;60;-2933.18,220.417;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-3380.874,-678.1081;Inherit;False;0;54;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;153;-3645.893,-166.673;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-3801.966,26.88233;Inherit;False;Property;_ShadowSmooth;ShadowSmooth;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;48;-3076.817,-146.9602;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;69;-2752.248,310.6112;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;269;-2779.06,471.6538;Inherit;False;Property;_VertexOffsetWorldPos;VertexOffsetWorldPos;12;1;[Enum];Create;True;0;2;On;0;Off;1;0;True;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;52;-2902.238,-234.3051;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-3167.976,-694.4575;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;0;False;0;False;-1;None;7ef213accd8b5404b981c4c1b94f0c5c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-2852.353,-95.73058;Inherit;False;Property;_BlinnLightDir;BlinnLightDir;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;152;-3511.323,-160.1232;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-3152.517,-484.5034;Inherit;False;Property;_Desaturate;Desaturate;5;0;Create;True;0;0;0;False;0;False;0;0.075;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;65;-2527.604,473.0379;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;228;-2035.566,660.1782;Inherit;False;Property;_VertexOffsetMaskPos;VertexOffsetMaskPos;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-2534.859,621.0563;Inherit;False;Property;_VertexOffsetMove_X;VertexOffsetMove_X;13;0;Create;True;0;0;0;False;0;False;0;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;340;-2029.554,535.9153;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;64;-2493.859,698.0563;Inherit;False;Property;_VertexOffsetMove_Y;VertexOffsetMove_Y;14;0;Create;True;0;0;0;False;0;False;0;-0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;63;-2490.043,-61.22764;Inherit;False;Property;_BlinnLightColor;BlinnLightColor;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.09803922,0.03921569,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;268;-2550.06,221.6537;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-2794.83,-3.67565;Inherit;False;Property;_BlinnSmooth;BlinnSmooth;11;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-2894.251,-784.025;Inherit;False;Property;_ShadowIntensity;ShadowIntensity;8;0;Create;True;0;0;0;False;0;False;0.75;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;61;-2831.323,-654.3871;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;149;-3352.559,-153.0164;Inherit;False;MainLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;150;-2843.787,-524.6055;Inherit;False;Property;_MainTexColor;MainTexColor;3;0;Create;True;0;0;0;False;0;False;0.8018868,0.8018868,0.8018868,1;0.4117647,0.4509804,0.372549,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-2698.627,-231.334;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-2463.859,774.0562;Inherit;False;Property;_VertexOffsetMove_Z;VertexOffsetMove_Z;15;0;Create;True;0;0;0;False;0;False;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;231;-1798.566,571.1783;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;62;-2537.626,-195.334;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-2287.598,368.9768;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-2281.528,476.4642;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-2612.788,-630.6052;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;267;-2367.467,226.3516;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-2350.051,-197.8658;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;-2596.865,-515.7278;Inherit;False;149;MainLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-2612.098,-744.5632;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-1954.571,744.3881;Inherit;False;Property;_VertexOffsetMaskSmooth;VertexOffsetMaskSmooth;19;0;Create;True;0;0;0;False;0;False;1;2;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;158;-2188.288,-169.5881;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-2117.64,232.2125;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2260.218,584.7322;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;236;-1611.571,569.3884;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-2118.219,344.7304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;145;-2459.788,-680.6052;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;309;-2113.686,918.5068;Inherit;False;1198.985;444.0862;GrassCut;11;308;304;306;307;305;298;302;300;301;299;297;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;273;-1984.184,-870.1185;Inherit;False;1077.15;539.9542;LightMix;7;290;289;287;281;279;278;277;LightMix;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-2011.777,-124.6239;Inherit;False;BlinnLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-2214.443,-663.9097;Inherit;False;MainTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-1929.218,425.7302;Inherit;False;Property;_VertexOffsetScale;VertexOffsetScale;16;0;Create;True;0;0;0;False;0;False;5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;84;-1912.213,256.8175;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;240;-1425.571,750.3884;Inherit;False;VertexOffsetMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;277;-1873.292,-715.4161;Inherit;False;144;MainTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;278;-1868.65,-635.378;Inherit;False;75;BlinnLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;98;-1689.9,248.8447;Inherit;False;Simplex3D;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;-1687.571,354.3887;Inherit;False;240;VertexOffsetMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;297;-2070.685,1025.552;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;299;-1880.906,1060.593;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-1673.219,444.7302;Inherit;False;Property;_VertexOffsetIntensity;VertexOffsetIntensity;20;0;Create;True;0;0;0;False;0;False;0.1;0.35;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;279;-1681.682,-646.379;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;323;-1392.603,478.6053;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;230;-1475.566,256.1769;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;301;-2034.701,1174.507;Inherit;False;Property;_CutDirChange;CutDirChange;23;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;335;-1259.795,645.5684;Inherit;False;Property;_VertexPosition;VertexPosition;17;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;334;-1222.795,468.5683;Inherit;False;Constant;_Float3;Float 1;31;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;324;-1322.603,322.6053;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-1291.216,224.728;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;300;-1844.906,1241.593;Inherit;False;Property;_CutPosition;CutPosition;24;0;Create;True;0;0;0;False;0;False;0.71;0.125;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;287;-1532.34,-519.0325;Inherit;False;Property;_LightIntensity;LightIntensity;21;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;281;-1450.098,-666.5952;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;337;-1094.794,501.5684;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;302;-1727.701,1064.507;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;298;-1556.906,1101.593;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;-1288.675,-669.3318;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1090.217,244.728;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;305;-1545.701,996.5069;Inherit;False;Constant;_Float1;Float 1;32;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;338;-944.554,257.9153;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;290;-1123.206,-673.4883;Inherit;False;ShadowCastDepart;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;304;-1414.701,1066.507;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;308;-1387.701,958.5069;Inherit;False;Constant;_Float2;Float 2;33;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;306;-1423.701,1173.507;Inherit;False;Property;_GrassCut;GrassCut;22;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;295;-482.024,112.2529;Inherit;False;Property;_TexEmission;TexEmission;4;0;Create;True;0;0;0;False;0;False;0.5;0.35;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-393.6304,-48.37741;Inherit;False;290;ShadowCastDepart;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;2;226.0997,55.90039;Inherit;False;225;166;Cull Mode;1;9;Cull Mode;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;307;-1243.7,1030.507;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-791.391,262.0317;Inherit;False;VertexOffset;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-224.3428,380.4082;Inherit;False;35;VertexOffset;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.IntNode;9;276.0997,105.9002;Inherit;False;Property;_Cull_Mode;Cull_Mode;1;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;321;-235.9822,251.2355;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;294;-170.024,105.2529;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-3,55;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Koakuma/Transparent/Grasses;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;ForwardOnly;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;9;-1;0;False;267;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;143;0;50;0
WireConnection;143;1;156;0
WireConnection;153;0;143;0
WireConnection;153;1;155;0
WireConnection;69;0;60;0
WireConnection;52;0;50;0
WireConnection;52;1;48;0
WireConnection;54;1;46;0
WireConnection;152;0;153;0
WireConnection;152;2;154;0
WireConnection;268;0;60;0
WireConnection;268;1;69;0
WireConnection;268;2;269;0
WireConnection;61;0;54;0
WireConnection;61;1;57;0
WireConnection;149;0;152;0
WireConnection;56;0;52;0
WireConnection;56;1;53;0
WireConnection;231;0;340;2
WireConnection;231;1;228;0
WireConnection;62;0;56;0
WireConnection;62;2;55;0
WireConnection;70;0;65;2
WireConnection;70;1;66;0
WireConnection;67;0;65;2
WireConnection;67;1;64;0
WireConnection;146;0;61;0
WireConnection;146;1;150;0
WireConnection;267;0;268;0
WireConnection;71;0;61;0
WireConnection;71;1;63;0
WireConnection;148;0;151;0
WireConnection;148;1;61;0
WireConnection;158;0;71;0
WireConnection;158;2;62;0
WireConnection;74;0;267;0
WireConnection;74;1;70;0
WireConnection;68;0;65;2
WireConnection;68;1;59;0
WireConnection;236;0;231;0
WireConnection;236;2;237;0
WireConnection;73;0;267;2
WireConnection;73;1;67;0
WireConnection;145;0;148;0
WireConnection;145;1;146;0
WireConnection;145;2;147;0
WireConnection;75;0;158;0
WireConnection;144;0;145;0
WireConnection;84;0;74;0
WireConnection;84;1;73;0
WireConnection;84;2;68;0
WireConnection;240;0;236;0
WireConnection;98;0;84;0
WireConnection;98;1;87;0
WireConnection;299;0;297;2
WireConnection;279;0;277;0
WireConnection;279;1;278;0
WireConnection;230;0;98;0
WireConnection;230;1;241;0
WireConnection;124;0;230;0
WireConnection;124;1;113;0
WireConnection;281;0;279;0
WireConnection;337;0;334;0
WireConnection;337;1;323;0
WireConnection;337;2;335;0
WireConnection;302;0;299;0
WireConnection;302;1;297;2
WireConnection;302;2;301;0
WireConnection;298;0;302;0
WireConnection;298;1;300;0
WireConnection;289;0;281;0
WireConnection;289;1;287;0
WireConnection;32;0;124;0
WireConnection;32;1;324;0
WireConnection;32;2;337;0
WireConnection;338;0;32;0
WireConnection;290;0;289;0
WireConnection;304;0;305;0
WireConnection;304;1;298;0
WireConnection;307;0;308;0
WireConnection;307;1;304;0
WireConnection;307;2;306;0
WireConnection;35;0;338;0
WireConnection;321;0;54;4
WireConnection;321;1;307;0
WireConnection;294;0;139;0
WireConnection;294;1;295;0
WireConnection;0;0;139;0
WireConnection;0;2;294;0
WireConnection;0;10;321;0
WireConnection;0;11;138;0
ASEEND*/
//CHKSM=7D3F4C1D4434FBCC4F936C397A571F3DEF8FD7CB