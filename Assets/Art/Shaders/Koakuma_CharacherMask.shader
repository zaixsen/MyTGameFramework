// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/CharacherMask"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Enum(On,1,Off,0)]_Z_Write1("Z_Write", Int) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]_Z_Test1("Z_Test", Int) = 0
		_MaskColor("MaskColor", Color) = (0,0,0,0)
		_NoiseRoll_X("NoiseRoll_X", Float) = 0
		_NoiseRoll_Y("NoiseRoll_Y", Float) = 0
		_NoiseRoll_Z("NoiseRoll_Z", Float) = 0
		_NoiseScale("NoiseScale", Float) = 5
		_Dissolve("Dissolve", Range( 0 , 1)) = 1
		_DirtherDistance("DirtherDistance", Float) = 16
		_Dither("Dither", Range( 0 , 2)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Geometry+1" "IsEmissive" = "true"  }
		Cull Back
		ZWrite [_Z_Write1]
		ZTest [_Z_Test1]
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float4 screenPosition;
			float3 viewDir;
			float eyeDepth;
		};

		uniform int _Z_Write1;
		uniform int _Z_Test1;
		uniform half4 _MaskColor;
		uniform half _NoiseRoll_X;
		uniform half _NoiseRoll_Y;
		uniform half _NoiseRoll_Z;
		uniform half _NoiseScale;
		uniform half _Dissolve;
		uniform half _Dither;
		uniform half _DirtherDistance;
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


		inline float Dither4x4Bayer( int x, int y )
		{
			const float dither[ 16 ] = {
				 1,  9,  3, 11,
				13,  5, 15,  7,
				 4, 12,  2, 10,
				16,  8, 14,  6 };
			int r = y * 4 + x;
			return dither[r] / 16; // same # of instructions as pre-dividing due to compiler magic
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			o.screenPosition = ase_screenPos;
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = _MaskColor.rgb;
			o.Alpha = 1;
			float3 ase_worldPos = i.worldPos;
			half3 worldToObj23 = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) ).xyz;
			half3 appendResult14 = (half3(( worldToObj23.x + ( _Time.y * _NoiseRoll_X ) ) , ( worldToObj23.y + ( _Time.y * _NoiseRoll_Y ) ) , ( worldToObj23.z + ( _Time.y * _NoiseRoll_Z ) )));
			half simplePerlin3D18 = snoise( appendResult14*_NoiseScale );
			simplePerlin3D18 = simplePerlin3D18*0.5 + 0.5;
			float4 ase_screenPos = i.screenPosition;
			half4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			half2 clipScreen20 = ase_screenPosNorm.xy * _ScreenParams.xy;
			half dither20 = Dither4x4Bayer( fmod(clipScreen20.x, 4), fmod(clipScreen20.y, 4) );
			half3 temp_cast_1 = (i.eyeDepth).xxx;
			half lerpResult34 = lerp( _Dither , 0.0 , saturate( ( distance( i.viewDir , temp_cast_1 ) / _DirtherDistance ) ));
			dither20 = step( dither20, lerpResult34 );
			clip( ( step( simplePerlin3D18 , (-0.01 + (_Dissolve - 0.0) * (1.05 - -0.01) / (1.0 - 0.0)) ) * dither20 ) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18934
7;6;2546;1373;1995.832;231.7499;1;True;True
Node;AmplifyShaderEditor.TimeNode;3;-1252.54,130.7766;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SurfaceDepthNode;32;-1293.832,667.2501;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1218.435,269.2716;Inherit;False;Property;_NoiseRoll_X;NoiseRoll_X;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;30;-1201.832,504.2501;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;4;-1219.469,341.618;Inherit;False;Property;_NoiseRoll_Y;NoiseRoll_Y;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1216.334,425.4576;Inherit;False;Property;_NoiseRoll_Z;NoiseRoll_Z;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;6;-1440.117,-14.84316;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1039.464,241.203;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1032.329,365.0426;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1046.532,119.7159;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;31;-1026.832,589.2501;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1050.832,730.2501;Inherit;False;Property;_DirtherDistance;DirtherDistance;9;0;Create;True;0;0;0;False;0;False;16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;23;-1265.832,-15.74994;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-894.4388,125.608;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;33;-856.832,589.2501;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-909.5748,10.9529;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-877.832,242.2501;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;36;-721.832,611.2501;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-835.2954,470.8718;Inherit;False;Property;_Dither;Dither;10;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-718.1469,99.55679;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-734.1628,273.1509;Inherit;False;Property;_NoiseScale;NoiseScale;7;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-851.8959,362.6082;Inherit;False;Property;_Dissolve;Dissolve;8;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;18;-569.8331,101.5839;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;16;-550.043,255.899;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.01;False;4;FLOAT;1.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;34;-530.832,451.2501;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;19;-309.0337,178.3714;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DitheringNode;20;-373.9601,353.1656;Inherit;False;0;True;4;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;3;SAMPLERSTATE;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;27;227.5013,111.9166;Inherit;False;356;166;Depth;2;29;28;Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-165.9479,259.6137;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;28;277.5015,161.9168;Inherit;False;Property;_Z_Write1;Z_Write;1;1;[Enum];Create;True;0;2;On;1;Off;0;0;True;0;False;1;1;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;29;419.501,161.9168;Inherit;False;Property;_Z_Test1;Z_Test;2;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;0;4;False;0;1;INT;0
Node;AmplifyShaderEditor.ColorNode;1;-359.0713,-16.6826;Inherit;False;Property;_MaskColor;MaskColor;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Half;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Koakuma/CharacherMask;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;2;True;28;7;True;29;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;1;True;Custom;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;1;True;2;255;False;-1;255;False;-1;4;False;-1;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;3;2
WireConnection;7;1;4;0
WireConnection;25;0;3;2
WireConnection;25;1;24;0
WireConnection;8;0;3;2
WireConnection;8;1;5;0
WireConnection;31;0;30;0
WireConnection;31;1;32;0
WireConnection;23;0;6;0
WireConnection;9;0;23;2
WireConnection;9;1;7;0
WireConnection;33;0;31;0
WireConnection;33;1;35;0
WireConnection;10;0;23;1
WireConnection;10;1;8;0
WireConnection;26;0;23;3
WireConnection;26;1;25;0
WireConnection;36;0;33;0
WireConnection;14;0;10;0
WireConnection;14;1;9;0
WireConnection;14;2;26;0
WireConnection;18;0;14;0
WireConnection;18;1;17;0
WireConnection;16;0;13;0
WireConnection;34;0;22;0
WireConnection;34;2;36;0
WireConnection;19;0;18;0
WireConnection;19;1;16;0
WireConnection;20;0;34;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;0;2;1;0
WireConnection;0;10;21;0
ASEEND*/
//CHKSM=CBECD25DF47EF3BC29DD703E65BDCB14CF7963E1