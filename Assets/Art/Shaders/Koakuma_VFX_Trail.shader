// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/VFX_Trail"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_Cull_Mode("Cull_Mode", Int) = 2
		[Enum(UnityEngine.Rendering.BlendMode)]_Blend_Src("Blend_Src", Int) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Blend_Dst("Blend_Dst", Int) = 10
		[Enum(On,1,Off,0)]_Z_Write("Z_Write", Int) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]_Z_Test("Z_Test", Int) = 4
		[Enum(Texture,0,Mask,1)]_Texture_Mask("Texture_Mask", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_HDR("HDR", Range( 0 , 50)) = 1
		_MainTexRollX("MainTexRollX", Float) = 0
		_MainTexRollY("MainTexRollY", Float) = 0
		[Enum(Off,0,On,1)]_TextureDistort("TextureDistort", Float) = 0
		_TexDistortTilingX("TexDistortTilingX", Float) = 1
		_TexDistortTilingY("TexDistortTilingY", Float) = 1
		_TexDistortRollX("TexDistortRollX", Range( 0 , 1)) = 0
		_TexDistortRollY("TexDistortRollY", Range( 0 , 1)) = 0
		_RollerBlance("RollerBlance", Range( 0 , 0.5)) = 0.05
		_TexDisIntensity("TexDisIntensity", Range( 0 , 1)) = 0
		[Enum(On,0,Off,1)]_MaskUVhorizontal("MaskUVhorizontal", Float) = 0
		_MaskTrailRadius("MaskTrailRadius", Range( 0.001 , 1)) = 0.5
		_MaskTrailSmooth("MaskTrailSmooth", Range( -1 , 1)) = -0.5
		[Enum(Off,0,On,1)]_AddNoise("AddNoise", Float) = 0
		[Enum(CustomData,0,Value,1)]_ControlStyle("ControlStyle", Float) = 0
		_NoiseStep("NoiseStep", Range( 0 , 1)) = 0
		_NoiseTilingX("NoiseTilingX", Float) = 0.25
		_NoiseTilingY("NoiseTilingY", Float) = 1
		_NoisePannerX("NoisePannerX", Float) = 0
		_NoisePannerY("NoisePannerY", Float) = 0
		_NoiseScale("NoiseScale", Float) = 5
		_NoiseAngle("NoiseAngle", Range( 0 , 1)) = 0.5
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
		#pragma surface surf Unlit keepalpha noshadow nofog 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float3 uv_texcoord;
			float4 screenPos;
		};

		uniform int _Blend_Dst;
		uniform int _Z_Test;
		uniform int _Z_Write;
		uniform int _Cull_Mode;
		uniform int _Blend_Src;
		uniform half _HDR;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform half _MainTexRollX;
		uniform half _MainTexRollY;
		uniform half _TexDistortRollX;
		uniform half _TexDistortRollY;
		uniform half _TexDistortTilingX;
		uniform half _TexDistortTilingY;
		uniform half _RollerBlance;
		uniform half _TexDisIntensity;
		uniform half _TextureDistort;
		uniform half _MaskTrailRadius;
		uniform half _MaskTrailSmooth;
		uniform half _MaskUVhorizontal;
		uniform half _NoiseStep;
		uniform half _ControlStyle;
		uniform half _NoiseScale;
		uniform half _NoiseAngle;
		uniform half _NoisePannerX;
		uniform half _NoisePannerY;
		uniform half _NoiseTilingX;
		uniform half _NoiseTilingY;
		uniform half _AddNoise;
		uniform half _Texture_Mask;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform half _DepthFadeDistance;


		float2 voronoihash345( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi345( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash345( n + g );
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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = ( i.vertexColor * _HDR ).rgb;
			float3 uvs_MainTex = i.uv_texcoord;
			uvs_MainTex.xy = i.uv_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			half2 appendResult76 = (half2(( _Time.y * _MainTexRollX ) , ( _Time.y * _MainTexRollY )));
			half2 appendResult363 = (half2(_TexDistortRollX , _TexDistortRollY));
			half2 appendResult382 = (half2(_TexDistortTilingX , _TexDistortTilingY));
			float2 uvs_TexCoord379 = i.uv_texcoord;
			uvs_TexCoord379.xy = i.uv_texcoord.xy * appendResult382;
			half2 panner360 = ( 1.0 * _Time.y * appendResult363 + uvs_TexCoord379.xy);
			half2 appendResult367 = (half2(( _TexDistortRollX - _RollerBlance ) , ( _TexDistortRollY - _RollerBlance )));
			half2 panner368 = ( 1.0 * _Time.y * appendResult367 + uvs_TexCoord379.xy);
			half2 lerpResult355 = lerp( (uvs_MainTex.xy*1.0 + appendResult76) , ( uvs_MainTex.xy + ( saturate( ( tex2D( _MainTex, panner360 ).a + tex2D( _MainTex, panner368 ).a ) ) * _TexDisIntensity ) ) , _TextureDistort);
			half lerpResult328 = lerp( i.uv_texcoord.xy.x , i.uv_texcoord.xy.y , _MaskUVhorizontal);
			half blendOpSrc330 = lerpResult328;
			half blendOpDest330 = lerpResult328;
			half smoothstepResult334 = smoothstep( ( _MaskTrailRadius + _MaskTrailSmooth ) , ( _MaskTrailRadius - _MaskTrailSmooth ) , ( saturate( ( 0.5 - 2.0 * ( blendOpSrc330 - 0.5 ) * ( blendOpDest330 - 0.5 ) ) )));
			half lerpResult389 = lerp( i.uv_texcoord.z , _NoiseStep , _ControlStyle);
			half mulTime347 = _Time.y * _NoiseAngle;
			half time345 = mulTime347;
			half2 voronoiSmoothId345 = 0;
			half2 appendResult268 = (half2(_NoisePannerX , _NoisePannerY));
			half2 appendResult309 = (half2(_NoiseTilingX , _NoiseTilingY));
			float2 uvs_TexCoord138 = i.uv_texcoord;
			uvs_TexCoord138.xy = i.uv_texcoord.xy * appendResult309;
			half2 panner267 = ( 1.0 * _Time.y * appendResult268 + uvs_TexCoord138.xy);
			float2 coords345 = panner267 * _NoiseScale;
			float2 id345 = 0;
			float2 uv345 = 0;
			float fade345 = 0.5;
			float voroi345 = 0;
			float rest345 = 0;
			for( int it345 = 0; it345 <2; it345++ ){
			voroi345 += fade345 * voronoi345( coords345, time345, id345, uv345, 0,voronoiSmoothId345 );
			rest345 += fade345;
			coords345 *= 2;
			fade345 *= 0.5;
			}//Voronoi345
			voroi345 /= rest345;
			half lerpResult343 = lerp( smoothstepResult334 , ( smoothstepResult334 * step( (-0.05 + (lerpResult389 - 0.0) * (1.05 - -0.05) / (1.0 - 0.0)) , voroi345 ) ) , _AddNoise);
			half lerpResult323 = lerp( tex2D( _MainTex, lerpResult355 ).a , lerpResult343 , _Texture_Mask);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			half4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth169 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half distanceDepth169 = saturate( abs( ( screenDepth169 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeDistance ) ) );
			o.Alpha = ( i.vertexColor.a * lerpResult323 * distanceDepth169 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18934
7;6;2546;1373;1389.62;806.8441;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;102;-2419.199,-905.5341;Inherit;False;2163.295;941.9478;TextureRollPart;31;358;77;376;384;375;383;381;382;380;379;371;378;355;351;76;353;354;219;218;352;370;369;368;367;360;363;362;361;57;385;386;TextureRollPart;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;361;-2193.834,-396.0746;Inherit;False;Property;_TexDistortRollX;TexDistortRollX;14;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;362;-2194.835,-306.0746;Inherit;False;Property;_TexDistortRollY;TexDistortRollY;15;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;371;-2326.717,-129.5227;Inherit;False;Property;_RollerBlance;RollerBlance;16;0;Create;True;0;0;0;False;0;False;0.05;0.1;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;381;-2393.717,-458.5226;Inherit;False;Property;_TexDistortTilingY;TexDistortTilingY;13;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;380;-2391.717,-551.5226;Inherit;False;Property;_TexDistortTilingX;TexDistortTilingX;12;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;370;-2007.717,-81.52269;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;382;-2189.717,-499.5226;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;369;-2004.717,-211.5227;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;367;-1872.322,-151.3137;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;271;-1628.84,536.4269;Inherit;False;1335.637;669.1688;NoisePart;18;276;310;345;78;306;267;347;348;138;268;269;309;270;308;307;387;388;389;NoisePart;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;363;-1871.835,-365.0746;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;379;-2054.717,-523.5226;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;308;-1626.13,872.6046;Inherit;False;Property;_NoiseTilingY;NoiseTilingY;25;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;368;-1734.322,-175.3137;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;307;-1623.13,786.6046;Inherit;False;Property;_NoiseTilingX;NoiseTilingX;24;0;Create;True;0;0;0;False;0;False;0.25;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;360;-1733.835,-389.0746;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;309;-1410.244,822.1952;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;270;-1452.987,1018.027;Inherit;False;Property;_NoisePannerY;NoisePannerY;27;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;269;-1451.396,937.4368;Inherit;False;Property;_NoisePannerX;NoisePannerX;26;0;Create;True;0;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;385;-1559.984,-419.4063;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;57;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;386;-1563.984,-204.4063;Inherit;True;Property;_TextureSample1;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;57;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;342;-1541.515,73.83211;Inherit;False;1004.681;439.7089;MaskPart;9;327;328;329;330;333;335;337;336;334;MaskPart;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;383;-1260.717,-289.5226;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;352;-1538.842,-712.246;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;219;-1530.524,-636.3452;Inherit;False;Property;_MainTexRollX;MainTexRollX;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;218;-1532.524,-554.345;Inherit;False;Property;_MainTexRollY;MainTexRollY;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;327;-1491.515,123.8322;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;329;-1444.834,245.5412;Inherit;False;Property;_MaskUVhorizontal;MaskUVhorizontal;18;1;[Enum];Create;True;0;2;On;0;Off;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;387;-1057.332,772.5948;Inherit;False;Property;_ControlStyle;ControlStyle;22;1;[Enum];Create;True;0;2;CustomData;0;Value;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;268;-1229.832,949.0273;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;138;-1253.459,825.119;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;348;-1480.802,1094.745;Inherit;False;Property;_NoiseAngle;NoiseAngle;29;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;388;-1346.332,726.5948;Inherit;False;Property;_NoiseStep;NoiseStep;23;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;276;-1169.295,577.5844;Inherit;False;0;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;354;-1316.842,-606.246;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;353;-1318.842,-709.246;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;333;-1172.834,293.5414;Inherit;False;Property;_MaskTrailRadius;MaskTrailRadius;19;0;Create;True;0;0;0;False;0;False;0.5;0.5;0.001;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;389;-958.332,639.5948;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;335;-1178.834,397.5412;Inherit;False;Property;_MaskTrailSmooth;MaskTrailSmooth;20;0;Create;True;0;0;0;False;0;False;-0.5;-0.2882353;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;306;-951.8936,1074.945;Inherit;False;Property;_NoiseScale;NoiseScale;28;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;347;-972.709,1000.336;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;267;-985.648,875.4056;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;384;-1143.717,-290.5226;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;376;-1233.717,-161.5227;Inherit;False;Property;_TexDisIntensity;TexDisIntensity;17;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;328;-1265.834,147.5411;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;345;-771.1867,947.3961;Inherit;False;0;0;1;0;2;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;77;-1209.727,-838.9962;Inherit;False;0;57;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;375;-1000.717,-308.5226;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;330;-1070.834,145.5411;Inherit;False;Exclusion;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;337;-881.8338,374.5413;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;-1164.929,-694.097;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;78;-799.0091,681.4859;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.05;False;4;FLOAT;1.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;336;-875.8338,230.5412;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;378;-843.7167,-347.5226;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;351;-983.8424,-745.246;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;358;-884.234,-181.2747;Inherit;False;Property;_TextureDistort;TextureDistort;11;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;334;-728.8338,153.5411;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;310;-615.3633,764.8584;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;341;-463.3726,419.2544;Inherit;False;Property;_AddNoise;AddNoise;21;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0.5873612;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;355;-711.234,-373.2746;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-468.5058,301.7458;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;343;-299.8324,215.3599;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;325;-229.0065,26.84863;Inherit;False;Property;_Texture_Mask;Texture_Mask;6;1;[Enum];Create;True;0;2;Texture;0;Mask;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;57;-557.3795,-297.2792;Inherit;True;Property;_MainTex;MainTex;7;0;Create;True;0;0;0;False;0;False;-1;None;80871ffc6a078314d8e04e5686fa15ee;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;170;51.71873,316.7412;Inherit;False;Property;_DepthFadeDistance;DepthFadeDistance;30;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1;943.5275,-109.7639;Inherit;False;225;166;Cull Mode;1;13;Cull Mode;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;5;943.5273,89.23524;Inherit;False;372;143;BlendMode;2;8;6;BlendMode;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;323;-81.87291,-160.9215;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;272;324.3719,-218.1283;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;282;216.1043,-32.18309;Inherit;False;Property;_HDR;HDR;8;0;Create;True;0;0;0;False;0;False;1;1;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;169;275.7186,296.7411;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;3;943.5273,266.2357;Inherit;False;356;166;Depth;2;14;12;Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.IntNode;6;993.5275,140.2354;Inherit;False;Property;_Blend_Src;Blend_Src;2;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;3;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;8;1137.527,139.2354;Inherit;False;Property;_Blend_Dst;Blend_Dst;3;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;1;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;14;1135.527,316.2359;Inherit;False;Property;_Z_Test;Z_Test;5;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;12;993.5275,316.2359;Inherit;False;Property;_Z_Write;Z_Write;4;1;[Enum];Create;True;0;2;On;1;Off;0;0;True;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;326;528.6457,227.0615;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;324;569.7975,72.66368;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;13;993.5274,-59.76408;Inherit;False;Property;_Cull_Mode;Cull_Mode;1;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;2;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;718.2001,24.7;Half;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Koakuma/VFX_Trail;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;False;False;False;False;Back;0;True;12;0;True;14;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;1;5;True;6;10;True;8;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;13;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;370;0;362;0
WireConnection;370;1;371;0
WireConnection;382;0;380;0
WireConnection;382;1;381;0
WireConnection;369;0;361;0
WireConnection;369;1;371;0
WireConnection;367;0;369;0
WireConnection;367;1;370;0
WireConnection;363;0;361;0
WireConnection;363;1;362;0
WireConnection;379;0;382;0
WireConnection;368;0;379;0
WireConnection;368;2;367;0
WireConnection;360;0;379;0
WireConnection;360;2;363;0
WireConnection;309;0;307;0
WireConnection;309;1;308;0
WireConnection;385;1;360;0
WireConnection;386;1;368;0
WireConnection;383;0;385;4
WireConnection;383;1;386;4
WireConnection;268;0;269;0
WireConnection;268;1;270;0
WireConnection;138;0;309;0
WireConnection;354;0;352;0
WireConnection;354;1;218;0
WireConnection;353;0;352;0
WireConnection;353;1;219;0
WireConnection;389;0;276;3
WireConnection;389;1;388;0
WireConnection;389;2;387;0
WireConnection;347;0;348;0
WireConnection;267;0;138;0
WireConnection;267;2;268;0
WireConnection;384;0;383;0
WireConnection;328;0;327;1
WireConnection;328;1;327;2
WireConnection;328;2;329;0
WireConnection;345;0;267;0
WireConnection;345;1;347;0
WireConnection;345;2;306;0
WireConnection;375;0;384;0
WireConnection;375;1;376;0
WireConnection;330;0;328;0
WireConnection;330;1;328;0
WireConnection;337;0;333;0
WireConnection;337;1;335;0
WireConnection;76;0;353;0
WireConnection;76;1;354;0
WireConnection;78;0;389;0
WireConnection;336;0;333;0
WireConnection;336;1;335;0
WireConnection;378;0;77;0
WireConnection;378;1;375;0
WireConnection;351;0;77;0
WireConnection;351;2;76;0
WireConnection;334;0;330;0
WireConnection;334;1;336;0
WireConnection;334;2;337;0
WireConnection;310;0;78;0
WireConnection;310;1;345;0
WireConnection;355;0;351;0
WireConnection;355;1;378;0
WireConnection;355;2;358;0
WireConnection;139;0;334;0
WireConnection;139;1;310;0
WireConnection;343;0;334;0
WireConnection;343;1;139;0
WireConnection;343;2;341;0
WireConnection;57;1;355;0
WireConnection;323;0;57;4
WireConnection;323;1;343;0
WireConnection;323;2;325;0
WireConnection;169;0;170;0
WireConnection;326;0;272;4
WireConnection;326;1;323;0
WireConnection;326;2;169;0
WireConnection;324;0;272;0
WireConnection;324;1;282;0
WireConnection;0;2;324;0
WireConnection;0;9;326;0
ASEEND*/
//CHKSM=4376DE515C79455FC668F0D8EA79F736163994B2