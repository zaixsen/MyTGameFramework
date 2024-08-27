// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/VFX_UVonceRoll"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_Mode", Int) = 2
		[Enum(UnityEngine.Rendering.BlendMode)]_Blend_Src("Blend_Src", Int) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Blend_Dst("Blend_Dst", Int) = 10
		[Enum(On,1,Off,0)]_Z_Write("Z_Write", Int) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]_Z_Test("Z_Test", Int) = 4
		_MainTex("MainTex", 2D) = "white" {}
		_MainTexTilingX("MainTexTilingX", Float) = 1
		_MainTexTilingY("MainTexTilingY", Float) = 1
		_HDR("HDR", Range( 0 , 50)) = 1
		[Enum(On,0,Off,1)]_TextureProcess("TextureProcess", Float) = 1
		_MainTexPower("MainTexPower", Float) = 1
		_MainTexRollX("MainTexRollX", Float) = 0
		_MainTexRollY("MainTexRollY", Float) = 0
		[Toggle(_USEMASK_ON)] _UseMask("UseMask", Float) = 0
		_MaskTexture("MaskTexture", 2D) = "white" {}
		_MaskNoiseTilingX("MaskNoiseTilingX", Float) = 1
		_MaskNoiseTilingY("MaskNoiseTilingY", Float) = 1
		_MaskNoisePannerX("MaskNoisePannerX", Float) = 0
		_MaskNoisePannerY("MaskNoisePannerY", Float) = 0
		_NoiseScale("NoiseScale", Float) = 5
		_NoiseDistortIntensity("NoiseDistortIntensity", Range( 0 , 1)) = 0
		[Enum(Off,0,On,1)]_DepthFade("DepthFade", Float) = 0
		_DepthFadeDistance("DepthFadeDistance", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull [_Cull_Mode]
		ZWrite [_Z_Write]
		ZTest [_Z_Test]
		Blend [_Blend_Src] [_Blend_Dst]
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USEMASK_ON
		#pragma surface surf Unlit keepalpha noshadow nofog 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
			float4 screenPos;
		};

		uniform int _Cull_Mode;
		uniform int _Z_Write;
		uniform int _Blend_Src;
		uniform int _Z_Test;
		uniform int _Blend_Dst;
		uniform half _HDR;
		uniform sampler2D _MainTex;
		uniform half _MainTexRollX;
		uniform half _MainTexRollY;
		uniform half _MainTexTilingX;
		uniform half _MainTexTilingY;
		uniform half _MainTexPower;
		uniform half _TextureProcess;
		uniform sampler2D _MaskTexture;
		uniform float4 _MaskTexture_ST;
		uniform half _MaskNoisePannerX;
		uniform half _MaskNoisePannerY;
		uniform half _MaskNoiseTilingX;
		uniform half _MaskNoiseTilingY;
		uniform half _NoiseScale;
		uniform half _NoiseDistortIntensity;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform half _DepthFadeDistance;
		uniform half _DepthFade;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			half2 appendResult76 = (half2(_MainTexRollX , _MainTexRollY));
			half2 appendResult280 = (half2(_MainTexTilingX , _MainTexTilingY));
			float2 uvs_TexCoord77 = i.uv_texcoord;
			uvs_TexCoord77.xy = i.uv_texcoord.xy * appendResult280;
			half2 panner74 = ( (-1.0 + (i.uv_texcoord.z - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) * appendResult76 + uvs_TexCoord77.xy);
			half4 tex2DNode57 = tex2D( _MainTex, panner74 );
			half4 temp_cast_0 = (_MainTexPower).xxxx;
			half4 lerpResult313 = lerp( saturate( pow( ( ( tex2DNode57 * 0.5 ) + tex2DNode57 ) , temp_cast_0 ) ) , tex2DNode57 , _TextureProcess);
			o.Emission = ( i.vertexColor * _HDR * lerpResult313 ).rgb;
			float4 uvs_MaskTexture = i.uv_texcoord;
			uvs_MaskTexture.xy = i.uv_texcoord.xy * _MaskTexture_ST.xy + _MaskTexture_ST.zw;
			half2 appendResult268 = (half2(_MaskNoisePannerX , _MaskNoisePannerY));
			half2 appendResult309 = (half2(_MaskNoiseTilingX , _MaskNoiseTilingY));
			float2 uvs_TexCoord138 = i.uv_texcoord;
			uvs_TexCoord138.xy = i.uv_texcoord.xy * appendResult309;
			half2 panner267 = ( 1.0 * _Time.y * appendResult268 + uvs_TexCoord138.xy);
			half simplePerlin2D305 = snoise( panner267*_NoiseScale );
			simplePerlin2D305 = simplePerlin2D305*0.5 + 0.5;
			#ifdef _USEMASK_ON
				half staticSwitch149 = ( tex2DNode57.a * ( tex2D( _MaskTexture, ( uvs_MaskTexture.xy + ( simplePerlin2D305 * _NoiseDistortIntensity ) ) ).a * step( (0.001 + (i.uv_texcoord.w - 0.0) * (1.05 - 0.001) / (1.0 - 0.0)) , simplePerlin2D305 ) ) );
			#else
				half staticSwitch149 = tex2DNode57.a;
			#endif
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			half4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth169 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half distanceDepth169 = abs( ( screenDepth169 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeDistance ) );
			half lerpResult177 = lerp( staticSwitch149 , ( staticSwitch149 * saturate( distanceDepth169 ) ) , _DepthFade);
			o.Alpha = ( i.vertexColor.a * lerpResult177 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18934
7;6;2546;1373;1357.117;814.5258;1.042469;True;True
Node;AmplifyShaderEditor.CommentaryNode;271;-2242.248,-15.65471;Inherit;False;1377.985;714.8323;MaskTexUVpart;18;137;315;316;310;305;312;267;306;138;268;269;270;309;308;307;317;318;319;MaskTexUVpart;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;307;-2220.277,242.3544;Inherit;False;Property;_MaskNoiseTilingX;MaskNoiseTilingX;16;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;308;-2223.277,328.3544;Inherit;False;Property;_MaskNoiseTilingY;MaskNoiseTilingY;17;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;309;-2014.277,273.3544;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;270;-2016.838,494.7783;Inherit;False;Property;_MaskNoisePannerY;MaskNoisePannerY;19;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;269;-2020.838,418.7777;Inherit;False;Property;_MaskNoisePannerX;MaskNoisePannerX;18;0;Create;True;0;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;102;-1904.155,-519.8541;Inherit;False;892.37;490.438;TextureRollPart;10;78;219;218;74;76;77;276;278;279;280;TextureRollPart;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;138;-1871.378,268.3452;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;268;-1802.979,416.7777;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;278;-1852.5,-435.6104;Inherit;False;Property;_MainTexTilingX;MainTexTilingX;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;279;-1853.5,-345.6104;Inherit;False;Property;_MainTexTilingY;MainTexTilingY;8;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;267;-1651.863,353.8935;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;306;-1688.277,513.3544;Inherit;False;Property;_NoiseScale;NoiseScale;20;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;319;-1821.277,195.3544;Inherit;False;Property;_NoiseDistortIntensity;NoiseDistortIntensity;21;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;280;-1632.5,-417.6104;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;276;-1618.5,-204.6103;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;218;-1850.38,-163.6644;Inherit;False;Property;_MainTexRollY;MainTexRollY;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;219;-1852.38,-239.6645;Inherit;False;Property;_MainTexRollX;MainTexRollX;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;305;-1446.277,486.3544;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;315;-1649.277,31.35437;Inherit;False;0;137;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;318;-1508.277,187.3544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;77;-1406.584,-406.3159;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;76;-1580.785,-313.4166;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;78;-1401.085,-216.6164;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;317;-1431.277,82.35437;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;312;-1360.277,303.3544;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.001;False;4;FLOAT;1.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;74;-1185.782,-335.4166;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;57;-967.7499,-363.9451;Inherit;True;Property;_MainTex;MainTex;6;0;Create;True;0;0;0;False;0;False;-1;None;80871ffc6a078314d8e04e5686fa15ee;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;137;-1317.574,50.6346;Inherit;True;Property;_MaskTexture;MaskTexture;15;0;Create;True;0;0;0;False;0;False;-1;None;80871ffc6a078314d8e04e5686fa15ee;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;322;-620.0908,-442.3644;Inherit;False;Constant;_Float0;Float 0;24;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;310;-1155.277,469.3544;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;170;-522.5639,283.1515;Inherit;False;Property;_DepthFadeDistance;DepthFadeDistance;23;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;316;-1009.277,236.3544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;321;-456.4229,-415.2601;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;169;-318.5638,262.1515;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-671.8441,-91.09473;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;261;-316.752,-243.8671;Inherit;False;Property;_MainTexPower;MainTexPower;11;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;301;-276.4565,-353.2168;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;262;-127.0919,-291.9095;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;149;-551.8452,-193.5751;Inherit;False;Property;_UseMask;UseMask;14;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;175;-82.564,259.9515;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;50.9359,232.2515;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;41.0359,333.1515;Inherit;False;Property;_DepthFade;DepthFade;22;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;320;7.566549,-167.6131;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;314;-158.2771,-34.64563;Inherit;False;Property;_TextureProcess;TextureProcess;10;1;[Enum];Create;True;0;2;On;0;Off;1;0;True;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;272;234.8362,-332.8578;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;3;943.5273,266.2357;Inherit;False;356;166;Depth;2;14;12;Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;5;943.5273,89.23524;Inherit;False;372;143;BlendMode;2;8;6;BlendMode;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1;943.5275,-109.7639;Inherit;False;225;166;Cull Mode;1;13;Cull Mode;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;177;210.936,206.8515;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;313;160.7229,-63.6456;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;282;203.6549,-134.9615;Inherit;False;Property;_HDR;HDR;9;0;Create;True;0;0;0;False;0;False;1;1;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;6;993.5275,140.2354;Inherit;False;Property;_Blend_Src;Blend_Src;2;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;3;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;14;1135.527,316.2359;Inherit;False;Property;_Z_Test;Z_Test;5;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;417.4677,182.907;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;8;1137.527,139.2354;Inherit;False;Property;_Blend_Dst;Blend_Dst;3;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;1;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;536.8111,-121.4734;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;13;993.5274,-59.76408;Inherit;False;Property;_Cull_Mode;Cull_Mode;1;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;2;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;12;993.5275,316.2359;Inherit;False;Property;_Z_Write;Z_Write;4;1;[Enum];Create;True;0;2;On;1;Off;0;0;True;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;718.2001,24.7;Half;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Koakuma/VFX_UVonceRoll;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;False;False;False;False;Back;0;True;12;0;True;14;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;1;5;True;6;10;True;8;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;13;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;309;0;307;0
WireConnection;309;1;308;0
WireConnection;138;0;309;0
WireConnection;268;0;269;0
WireConnection;268;1;270;0
WireConnection;267;0;138;0
WireConnection;267;2;268;0
WireConnection;280;0;278;0
WireConnection;280;1;279;0
WireConnection;305;0;267;0
WireConnection;305;1;306;0
WireConnection;318;0;305;0
WireConnection;318;1;319;0
WireConnection;77;0;280;0
WireConnection;76;0;219;0
WireConnection;76;1;218;0
WireConnection;78;0;276;3
WireConnection;317;0;315;0
WireConnection;317;1;318;0
WireConnection;312;0;276;4
WireConnection;74;0;77;0
WireConnection;74;2;76;0
WireConnection;74;1;78;0
WireConnection;57;1;74;0
WireConnection;137;1;317;0
WireConnection;310;0;312;0
WireConnection;310;1;305;0
WireConnection;316;0;137;4
WireConnection;316;1;310;0
WireConnection;321;0;57;0
WireConnection;321;1;322;0
WireConnection;169;0;170;0
WireConnection;139;0;57;4
WireConnection;139;1;316;0
WireConnection;301;0;321;0
WireConnection;301;1;57;0
WireConnection;262;0;301;0
WireConnection;262;1;261;0
WireConnection;149;1;57;4
WireConnection;149;0;139;0
WireConnection;175;0;169;0
WireConnection;171;0;149;0
WireConnection;171;1;175;0
WireConnection;320;0;262;0
WireConnection;177;0;149;0
WireConnection;177;1;171;0
WireConnection;177;2;176;0
WireConnection;313;0;320;0
WireConnection;313;1;57;0
WireConnection;313;2;314;0
WireConnection;300;0;272;4
WireConnection;300;1;177;0
WireConnection;156;0;272;0
WireConnection;156;1;282;0
WireConnection;156;2;313;0
WireConnection;0;2;156;0
WireConnection;0;9;300;0
ASEEND*/
//CHKSM=FDDD6912FAD4537213CA6A6324EAAD60B031CBD2