// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Koakuma/Ground"
{
	Properties
	{
		[Toggle(_USEVERTEXCOLORMAP_ON)] _UseVertexColorMap("UseVertexColorMap", Float) = 0
		[Enum(WorldPosition,0,LocalPosition,1)]_PositionSelect("PositionSelect", Float) = 0
		_TexEmission("TexEmission", Range( 0 , 1)) = 0.5
		_Texture1("Texture1", 2D) = "white" {}
		_TexColor1("TexColor1", Color) = (1,1,1,0)
		_TexUVTiling1("TexUVTiling1", Float) = 5
		_Texture2("Texture2", 2D) = "white" {}
		_TexColor2("TexColor2", Color) = (1,1,1,0)
		_TexUVTiling2("TexUVTiling2", Float) = 5
		[Enum(Noise,0,Voronoi,1)]_Part1NoiseStyle("Part1NoiseStyle", Float) = 0
		_Part1NoiseScale("Part1NoiseScale", Float) = 0.5
		_Part1NoiseOffsetX("Part1NoiseOffsetX", Float) = 0
		_Part1NoiseOffsetY("Part1NoiseOffsetY", Float) = 0
		_Part1RadiusBlend("Part1RadiusBlend", Range( 0 , 1)) = 0.5
		_Part1SmoothBlend("Part1SmoothBlend", Range( 0.01 , 1)) = 0.15
		_Texture3("Texture3", 2D) = "white" {}
		_TexColor3("TexColor3", Color) = (1,1,1,0)
		_TexUVTiling3("TexUVTiling3", Float) = 5
		_Texture4("Texture4", 2D) = "white" {}
		_TexColor4("TexColor4", Color) = (1,1,1,0)
		_TexUVTiling4("TexUVTiling4", Float) = 5
		[Enum(Noise,0,Voronoi,1)]_Part2NoiseStyle("Part2NoiseStyle", Float) = 0
		_Part2NoiseScale("Part2NoiseScale", Float) = 0.5
		_Part2NoiseOffsetX("Part2NoiseOffsetX", Float) = 0
		_Part2NoiseOffsetY("Part2NoiseOffsetY", Float) = 0
		_Part2RadiusBlend("Part2RadiusBlend", Range( 0 , 1)) = 0.5
		_Part2SmoothBlend("Part2SmoothBlend", Range( 0.01 , 1)) = 0.15
		_Texture5_1("Texture5", 2D) = "white" {}
		_TexColor5_1("TexColor5", Color) = (1,1,1,0)
		_TexUVTiling5_1("TexUVTiling5", Float) = 5
		_Texture6_1("Texture6", 2D) = "white" {}
		_TexColor6_1("TexColor6", Color) = (1,1,1,0)
		_TexUVTiling6_1("TexUVTiling6", Float) = 5
		[Enum(Noise,0,Voronoi,1)]_Part3NoiseStyle("Part3NoiseStyle", Float) = 0
		_Part3NoiseScale("Part3NoiseScale", Float) = 0.5
		_Part3NoiseOffsetX("Part3NoiseOffsetX", Float) = 0
		_Part3NoiseOffsetY("Part3NoiseOffsetY", Float) = 0
		_Part3RadiusBlend("Part3RadiusBlend", Range( 0 , 1)) = 0.5
		_Part3SmoothBlend("Part3SmoothBlend", Range( 0.01 , 1)) = 0.15
		[Enum(Noise,0,Voronoi,1)]_MixNoiseStyle("MixNoiseStyle", Float) = 0
		_MixNoiseScale("MixNoiseScale", Float) = 0.065
		_MixNoiseOffsetX("MixNoiseOffsetX", Float) = 0
		_MixNoiseOffsetY("MixNoiseOffsetY", Float) = 0
		_MixRadiusBlend("MixRadiusBlend", Range( 0 , 1)) = 0.5
		_MixSmoothBlend("MixSmoothBlend", Range( 0.01 , 1)) = 0.15
		_MapIntensity("MapIntensity", Range( 0 , 1)) = 1
		[Enum(Off,0,On,1)]_CloudShadow("CloudShadow", Float) = 0
		_CloudOffsetX("CloudOffsetX", Range( -0.15 , 0.15)) = 0
		_CloudOffsetY("CloudOffsetY", Range( -0.15 , 0.15)) = 0
		_CloudScaleX("CloudScaleX", Range( 0.01 , 0.5)) = 0.1
		_CloudScaleY("CloudScaleY", Range( 0.01 , 0.5)) = 0.1
		_CloudNoiseOffsetX("CloudNoiseOffsetX", Range( -0.15 , 0.15)) = 0
		_CloudNoiseOffsetY("CloudNoiseOffsetY", Range( -0.15 , 0.15)) = 0
		_CloudNoiseScaleX("CloudNoiseScaleX", Range( 0.01 , 0.5)) = 0.5
		_CloudNoiseScaleY("CloudNoiseScaleY", Range( 0.01 , 0.5)) = 0.5
		_CloudRadiusBlend("CloudRadiusBlend", Range( 0 , 2)) = 0.5
		_CloudSmoothBlend("CloudSmoothBlend", Range( 0.01 , 1)) = 0.15
		_CloudIntensity("CloudIntensity", Range( -0.2 , 0)) = -0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USEVERTEXCOLORMAP_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform half _MapIntensity;
		uniform half4 _TexColor1;
		uniform sampler2D _Texture1;
		uniform half _PositionSelect;
		uniform half _TexUVTiling1;
		uniform half4 _TexColor2;
		uniform sampler2D _Texture2;
		uniform half _TexUVTiling2;
		uniform half _Part1RadiusBlend;
		uniform half _Part1SmoothBlend;
		uniform half _Part1NoiseScale;
		uniform half _Part1NoiseOffsetX;
		uniform half _Part1NoiseOffsetY;
		uniform half _Part1NoiseStyle;
		uniform half4 _TexColor3;
		uniform sampler2D _Texture3;
		uniform half _TexUVTiling3;
		uniform half4 _TexColor4;
		uniform sampler2D _Texture4;
		uniform half _TexUVTiling4;
		uniform half _Part2RadiusBlend;
		uniform half _Part2SmoothBlend;
		uniform half _Part2NoiseScale;
		uniform half _Part2NoiseOffsetX;
		uniform half _Part2NoiseOffsetY;
		uniform half _Part2NoiseStyle;
		uniform half _MixRadiusBlend;
		uniform half _MixSmoothBlend;
		uniform half _MixNoiseScale;
		uniform half _MixNoiseOffsetX;
		uniform half _MixNoiseOffsetY;
		uniform half _MixNoiseStyle;
		uniform half4 _TexColor5_1;
		uniform sampler2D _Texture5_1;
		uniform half _TexUVTiling5_1;
		uniform half4 _TexColor6_1;
		uniform sampler2D _Texture6_1;
		uniform half _TexUVTiling6_1;
		uniform half _Part3RadiusBlend;
		uniform half _Part3SmoothBlend;
		uniform half _Part3NoiseScale;
		uniform half _Part3NoiseOffsetX;
		uniform half _Part3NoiseOffsetY;
		uniform half _Part3NoiseStyle;
		uniform half _CloudIntensity;
		uniform half _CloudRadiusBlend;
		uniform half _CloudSmoothBlend;
		uniform half _CloudScaleX;
		uniform half _CloudScaleY;
		uniform half _CloudOffsetX;
		uniform half _CloudOffsetY;
		uniform half _CloudNoiseScaleX;
		uniform half _CloudNoiseScaleY;
		uniform half _CloudNoiseOffsetX;
		uniform half _CloudNoiseOffsetY;
		uniform half _CloudShadow;
		uniform half _TexEmission;


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


		float2 voronoihash676( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi676( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash676( n + g );
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
			return F2;
		}


		float2 voronoihash734( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi734( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash734( n + g );
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
			return F2;
		}


		float2 voronoihash746( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi746( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash746( n + g );
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
			return F2;
		}


		float2 voronoihash841( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi841( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash841( n + g );
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
			return F2;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			half2 appendResult648 = (half2(ase_worldPos.x , ase_worldPos.z));
			half2 lerpResult867 = lerp( appendResult648 , i.uv_texcoord , _PositionSelect);
			half2 Position707 = lerpResult867;
			half2 appendResult705 = (half2(_Part1NoiseOffsetX , _Part1NoiseOffsetY));
			half2 temp_output_700_0 = (Position707*_Part1NoiseScale + appendResult705);
			half simplePerlin2D666 = snoise( temp_output_700_0 );
			simplePerlin2D666 = simplePerlin2D666*0.5 + 0.5;
			half time676 = 0.0;
			half2 voronoiSmoothId676 = 0;
			float2 coords676 = temp_output_700_0 * 1.0;
			float2 id676 = 0;
			float2 uv676 = 0;
			float fade676 = 0.5;
			float voroi676 = 0;
			float rest676 = 0;
			for( int it676 = 0; it676 <4; it676++ ){
			voroi676 += fade676 * voronoi676( coords676, time676, id676, uv676, 0,voronoiSmoothId676 );
			rest676 += fade676;
			coords676 *= 2;
			fade676 *= 0.5;
			}//Voronoi676
			voroi676 /= rest676;
			half lerpResult759 = lerp( simplePerlin2D666 , voroi676 , _Part1NoiseStyle);
			half smoothstepResult673 = smoothstep( ( _Part1RadiusBlend + _Part1SmoothBlend ) , ( _Part1RadiusBlend - _Part1SmoothBlend ) , lerpResult759);
			half4 lerpResult663 = lerp( ( _TexColor1 * tex2D( _Texture1, ( Position707 / _TexUVTiling1 ) ) ) , ( _TexColor2 * tex2D( _Texture2, ( Position707 / _TexUVTiling2 ) ) ) , saturate( smoothstepResult673 ));
			half2 appendResult730 = (half2(_Part2NoiseOffsetX , _Part2NoiseOffsetY));
			half2 temp_output_732_0 = (Position707*_Part2NoiseScale + appendResult730);
			half simplePerlin2D733 = snoise( temp_output_732_0 );
			simplePerlin2D733 = simplePerlin2D733*0.5 + 0.5;
			half time734 = 0.0;
			half2 voronoiSmoothId734 = 0;
			float2 coords734 = temp_output_732_0 * 1.0;
			float2 id734 = 0;
			float2 uv734 = 0;
			float fade734 = 0.5;
			float voroi734 = 0;
			float rest734 = 0;
			for( int it734 = 0; it734 <4; it734++ ){
			voroi734 += fade734 * voronoi734( coords734, time734, id734, uv734, 0,voronoiSmoothId734 );
			rest734 += fade734;
			coords734 *= 2;
			fade734 *= 0.5;
			}//Voronoi734
			voroi734 /= rest734;
			half lerpResult761 = lerp( simplePerlin2D733 , voroi734 , _Part2NoiseStyle);
			half smoothstepResult740 = smoothstep( ( _Part2RadiusBlend + _Part2SmoothBlend ) , ( _Part2RadiusBlend - _Part2SmoothBlend ) , lerpResult761);
			half4 lerpResult725 = lerp( ( _TexColor3 * tex2D( _Texture3, ( Position707 / _TexUVTiling3 ) ) ) , ( _TexColor4 * tex2D( _Texture4, ( Position707 / _TexUVTiling4 ) ) ) , saturate( smoothstepResult740 ));
			half2 appendResult743 = (half2(_MixNoiseOffsetX , _MixNoiseOffsetY));
			half2 temp_output_744_0 = (Position707*_MixNoiseScale + appendResult743);
			half simplePerlin2D745 = snoise( temp_output_744_0 );
			simplePerlin2D745 = simplePerlin2D745*0.5 + 0.5;
			half time746 = 0.0;
			half2 voronoiSmoothId746 = 0;
			float2 coords746 = temp_output_744_0 * 1.0;
			float2 id746 = 0;
			float2 uv746 = 0;
			float fade746 = 0.5;
			float voroi746 = 0;
			float rest746 = 0;
			for( int it746 = 0; it746 <4; it746++ ){
			voroi746 += fade746 * voronoi746( coords746, time746, id746, uv746, 0,voronoiSmoothId746 );
			rest746 += fade746;
			coords746 *= 2;
			fade746 *= 0.5;
			}//Voronoi746
			voroi746 /= rest746;
			half lerpResult766 = lerp( simplePerlin2D745 , voroi746 , _MixNoiseStyle);
			half smoothstepResult750 = smoothstep( ( _MixRadiusBlend + _MixSmoothBlend ) , ( _MixRadiusBlend - _MixSmoothBlend ) , lerpResult766);
			half Mix762 = saturate( smoothstepResult750 );
			half4 lerpResult712 = lerp( lerpResult663 , lerpResult725 , Mix762);
			half VertexColor_R798 = i.vertexColor.r;
			half VertexColor_G799 = i.vertexColor.g;
			half2 appendResult829 = (half2(_Part3NoiseOffsetX , _Part3NoiseOffsetY));
			half2 temp_output_836_0 = (Position707*_Part3NoiseScale + appendResult829);
			half simplePerlin2D840 = snoise( temp_output_836_0 );
			simplePerlin2D840 = simplePerlin2D840*0.5 + 0.5;
			half time841 = 0.0;
			half2 voronoiSmoothId841 = 0;
			float2 coords841 = temp_output_836_0 * 1.0;
			float2 id841 = 0;
			float2 uv841 = 0;
			float fade841 = 0.5;
			float voroi841 = 0;
			float rest841 = 0;
			for( int it841 = 0; it841 <4; it841++ ){
			voroi841 += fade841 * voronoi841( coords841, time841, id841, uv841, 0,voronoiSmoothId841 );
			rest841 += fade841;
			coords841 *= 2;
			fade841 *= 0.5;
			}//Voronoi841
			voroi841 /= rest841;
			half lerpResult850 = lerp( simplePerlin2D840 , voroi841 , _Part3NoiseStyle);
			half smoothstepResult853 = smoothstep( ( _Part3RadiusBlend + _Part3SmoothBlend ) , ( _Part3RadiusBlend - _Part3SmoothBlend ) , lerpResult850);
			half4 lerpResult855 = lerp( ( _TexColor5_1 * tex2D( _Texture5_1, ( Position707 / _TexUVTiling5_1 ) ) ) , ( _TexColor6_1 * tex2D( _Texture6_1, ( Position707 / _TexUVTiling6_1 ) ) ) , saturate( smoothstepResult853 ));
			half VertexColor_B800 = i.vertexColor.b;
			#ifdef _USEVERTEXCOLORMAP_ON
				half4 staticSwitch796 = saturate( ( ( lerpResult663 * VertexColor_R798 ) + ( lerpResult725 * VertexColor_G799 ) + ( lerpResult855 * VertexColor_B800 ) ) );
			#else
				half4 staticSwitch796 = lerpResult712;
			#endif
			half2 WorldPosition870 = appendResult648;
			half2 appendResult795 = (half2(_CloudScaleX , _CloudScaleY));
			half2 appendResult772 = (half2(( _Time.y * _CloudOffsetX ) , ( _Time.y * _CloudOffsetY )));
			half simplePerlin2D774 = snoise( (WorldPosition870*appendResult795 + appendResult772) );
			simplePerlin2D774 = simplePerlin2D774*0.5 + 0.5;
			half2 appendResult878 = (half2(_CloudNoiseScaleX , _CloudNoiseScaleY));
			half2 appendResult880 = (half2(( _Time.y * _CloudNoiseOffsetX ) , ( _Time.y * _CloudNoiseOffsetY )));
			half simplePerlin2D884 = snoise( (WorldPosition870*appendResult878 + appendResult880) );
			simplePerlin2D884 = simplePerlin2D884*0.5 + 0.5;
			half smoothstepResult782 = smoothstep( ( _CloudRadiusBlend + _CloudSmoothBlend ) , ( _CloudRadiusBlend - _CloudSmoothBlend ) , ( simplePerlin2D774 + simplePerlin2D884 ));
			half lerpResult786 = lerp( _CloudIntensity , 0.0 , saturate( smoothstepResult782 ));
			half Cloud784 = lerpResult786;
			half lerpResult887 = lerp( 0.0 , Cloud784 , _CloudShadow);
			half4 TextureColor602 = ( ( _MapIntensity * staticSwitch796 ) + lerpResult887 );
			half4 temp_output_696_0 = TextureColor602;
			o.Albedo = temp_output_696_0.rgb;
			o.Emission = ( TextureColor602 * _TexEmission ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18934
2553;25;2560;1387;2145.011;-628.4698;1.181158;True;True
Node;AmplifyShaderEditor.CommentaryNode;710;-4130.876,-715.5865;Inherit;False;1158.058;302;Position;7;707;648;647;867;868;869;870;Position;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;647;-4084.876,-678.5865;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;648;-3822.582,-672.3976;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;868;-3897.263,-555.9291;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;869;-3646.263,-496.9291;Inherit;False;Property;_PositionSelect;PositionSelect;2;1;[Enum];Create;True;0;2;WorldPosition;0;LocalPosition;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;867;-3398.263,-602.9291;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;825;-3675.691,2335.494;Inherit;False;1633.408;472.668;NoiseMaskPart3;16;854;853;850;849;848;843;842;841;840;837;836;830;829;828;827;826;NoiseMaskPart3;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;684;-3630.022,-391.3264;Inherit;False;1600.917;458.8718;NoiseMaskPart1;16;705;704;703;670;711;700;666;676;682;680;674;681;675;673;758;759;NoiseMaskPart1;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;742;-3634.68,958.3568;Inherit;False;1633.408;472.668;NoiseMaskPart2;16;727;728;729;730;731;732;733;734;735;736;737;739;740;741;760;761;NoiseMaskPart2;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;707;-3165.818,-613.2806;Inherit;False;Position;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;826;-3628.691,2598.162;Inherit;False;Property;_Part3NoiseOffsetX;Part3NoiseOffsetX;36;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;728;-3583.68,1315.025;Inherit;False;Property;_Part2NoiseOffsetY;Part2NoiseOffsetY;25;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;703;-3610.328,-143.4479;Inherit;False;Property;_Part1NoiseOffsetX;Part1NoiseOffsetX;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;827;-3624.691,2692.162;Inherit;False;Property;_Part3NoiseOffsetY;Part3NoiseOffsetY;37;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;767;-1662.911,601.8198;Inherit;False;1846.374;476.8956;MixPart;17;752;753;757;756;743;744;745;746;747;749;750;751;762;754;755;766;765;MixPart;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;704;-3609.328,-50.44793;Inherit;False;Property;_Part1NoiseOffsetY;Part1NoiseOffsetY;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;727;-3587.68,1221.025;Inherit;False;Property;_Part2NoiseOffsetX;Part2NoiseOffsetX;24;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;785;-1673.502,1136.614;Inherit;False;2250.974;918.1488;SimulatCloud;33;782;780;779;776;775;786;787;881;774;773;792;793;876;875;880;772;871;872;873;884;878;877;874;783;784;771;795;794;770;791;769;768;886;SimulatCloud;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;729;-3403.395,1112.477;Inherit;False;707;Position;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;791;-1623.13,1240.543;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;731;-3395.374,1188.61;Inherit;False;Property;_Part2NoiseScale;Part2NoiseScale;23;0;Create;True;0;0;0;False;0;False;0.5;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;828;-3444.406,2489.614;Inherit;False;707;Position;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;670;-3431.022,-176.8627;Inherit;False;Property;_Part1NoiseScale;Part1NoiseScale;11;0;Create;True;0;0;0;False;0;False;0.5;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;752;-1612.911,868.7155;Inherit;False;Property;_MixNoiseOffsetX;MixNoiseOffsetX;42;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;705;-3370.328,-99.44794;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;830;-3436.385,2565.747;Inherit;False;Property;_Part3NoiseScale;Part3NoiseScale;35;0;Create;True;0;0;0;False;0;False;0.5;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;711;-3429.043,-252.9953;Inherit;False;707;Position;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;829;-3385.691,2643.162;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;753;-1608.911,962.7153;Inherit;False;Property;_MixNoiseOffsetY;MixNoiseOffsetY;43;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;873;-1643.42,1625.582;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;769;-1615.202,1394.963;Inherit;False;Property;_CloudOffsetX;CloudOffsetX;48;0;Create;True;0;0;0;False;0;False;0;0;-0.15;0.15;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;872;-1637.492,1792.002;Inherit;False;Property;_CloudNoiseOffsetX;CloudNoiseOffsetX;52;0;Create;True;0;0;0;False;0;False;0;0;-0.15;0.15;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;730;-3344.68,1266.025;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;768;-1617.202,1493.963;Inherit;False;Property;_CloudOffsetY;CloudOffsetY;49;0;Create;True;0;0;0;False;0;False;0;0;-0.15;0.15;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;871;-1641.492,1895.002;Inherit;False;Property;_CloudNoiseOffsetY;CloudNoiseOffsetY;53;0;Create;True;0;0;0;False;0;False;0;0;-0.15;0.15;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;700;-3206.939,-253.7062;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;732;-3181.291,1111.766;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;743;-1369.911,913.7153;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;836;-3222.302,2488.903;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;685;-2928.589,-1208.184;Inherit;False;1149.641;784.0704;TexturePart1;13;663;571;660;659;549;662;560;664;650;708;709;651;665;TexturePart1;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;756;-1428.626,749.1674;Inherit;False;707;Position;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;831;-3293.296,1487.047;Inherit;False;1133.804;792.6351;TexturePart3;13;855;852;851;839;838;834;833;857;858;859;860;861;862;TexturePart3;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;726;-3252.285,109.9095;Inherit;False;1133.804;792.6351;TexturePart2;13;725;720;719;715;717;718;716;714;713;721;724;723;722;TexturePart2;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;757;-1420.605,836.3003;Inherit;False;Property;_MixNoiseScale;MixNoiseScale;41;0;Create;True;0;0;0;False;0;False;0.065;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;794;-1425.854,1281.91;Inherit;False;Property;_CloudScaleY;CloudScaleY;51;0;Create;True;0;0;0;False;0;False;0.1;0.5;0.01;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;874;-1443.186,1605.587;Inherit;False;Property;_CloudNoiseScaleX;CloudNoiseScaleX;54;0;Create;True;0;0;0;False;0;False;0.5;50;0.01;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;770;-1423.896,1201.548;Inherit;False;Property;_CloudScaleX;CloudScaleX;50;0;Create;True;0;0;0;False;0;False;0.1;50;0.01;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;877;-1445.144,1685.949;Inherit;False;Property;_CloudNoiseScaleY;CloudNoiseScaleY;55;0;Create;True;0;0;0;False;0;False;0.5;0.5;0.01;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;876;-1361.419,1774.582;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;875;-1368.419,1882.582;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;792;-1335.129,1365.543;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;870;-3598.004,-673.4474;Inherit;False;WorldPosition;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;793;-1342.129,1473.543;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;721;-3179.385,422.9893;Inherit;False;Property;_TexUVTiling3;TexUVTiling3;18;0;Create;True;0;0;0;False;0;False;5;3.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;736;-2741.209,1306.521;Inherit;False;Property;_Part2SmoothBlend;Part2SmoothBlend;27;0;Create;True;0;0;0;False;0;False;0.15;1;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;760;-2960.205,1290.15;Inherit;False;Property;_Part2NoiseStyle;Part2NoiseStyle;22;1;[Enum];Create;True;0;2;Noise;0;Voronoi;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;674;-2751.974,-186.0979;Inherit;False;Property;_Part1RadiusBlend;Part1RadiusBlend;14;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;834;-3243.296,1723.808;Inherit;False;707;Position;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;722;-3173.92,767.0358;Inherit;False;Property;_TexUVTiling4;TexUVTiling4;21;0;Create;True;0;0;0;False;0;False;5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;724;-3195.285,695.6702;Inherit;False;707;Position;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;733;-2945.901,1028.46;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;862;-3223.306,2173.684;Inherit;False;Property;_TexUVTiling6_1;TexUVTiling6;33;0;Create;False;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;833;-3236.296,2072.807;Inherit;False;707;Position;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;758;-2995.189,-77.46948;Inherit;False;Property;_Part1NoiseStyle;Part1NoiseStyle;10;1;[Enum];Create;True;0;2;Noise;0;Voronoi;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;735;-2745.326,1182.375;Inherit;False;Property;_Part2RadiusBlend;Part2RadiusBlend;26;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;842;-2786.337,2559.512;Inherit;False;Property;_Part3RadiusBlend;Part3RadiusBlend;38;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;651;-2832.538,-897.103;Inherit;False;Property;_TexUVTiling1;TexUVTiling1;6;0;Create;True;0;0;0;False;0;False;5;3.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;744;-1206.522,759.4564;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;795;-1138.855,1251.91;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;843;-2782.22,2683.658;Inherit;False;Property;_Part3SmoothBlend;Part3SmoothBlend;39;0;Create;True;0;0;0;False;0;False;0.15;1;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;858;-3232.847,1814.005;Inherit;False;Property;_TexUVTiling5_1;TexUVTiling5;30;0;Create;False;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;840;-2986.912,2405.597;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;708;-2863.439,-971.4224;Inherit;False;707;Position;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;880;-1154.491,1801.002;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;709;-2902.538,-617.9901;Inherit;False;707;Position;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;771;-1165.916,1172.415;Inherit;False;870;WorldPosition;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;665;-2855.173,-545.6244;Inherit;False;Property;_TexUVTiling2;TexUVTiling2;9;0;Create;True;0;0;0;False;0;False;5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;680;-2751.857,-90.95131;Inherit;False;Property;_Part1SmoothBlend;Part1SmoothBlend;15;0;Create;True;0;0;0;False;0;False;0.15;1;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;878;-1149.145,1614.949;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;772;-1148.201,1413.963;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;723;-3201.285,346.6699;Inherit;False;707;Position;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;734;-2941.055,1161.447;Inherit;False;0;0;1;1;4;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;837;-3001.216,2667.287;Inherit;False;Property;_Part3NoiseStyle;Part3NoiseStyle;34;1;[Enum];Create;True;0;2;Noise;0;Voronoi;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;676;-2967.703,-215.0256;Inherit;False;0;0;1;1;4;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;841;-2982.066,2538.584;Inherit;False;0;0;1;1;4;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;666;-2971.549,-337.0126;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;802;-3598.366,-1085.654;Inherit;False;492.9116;337.9538;VertexColorPart;4;797;798;799;800;VertexColorPart;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;881;-977.1024,1556.743;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;849;-2502.8,2594.982;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;714;-3009.604,354.0449;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;664;-2665.275,-604.3525;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;848;-2493.928,2482.131;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;746;-963.2855,801.1374;Inherit;False;0;0;1;1;4;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;765;-974.3665,935.3672;Inherit;False;Property;_MixNoiseStyle;MixNoiseStyle;40;1;[Enum];Create;True;0;2;Noise;0;Voronoi;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;773;-959.8123,1254.704;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;755;-764.4398,883.2114;Inherit;False;Property;_MixSmoothBlend;MixSmoothBlend;45;0;Create;True;0;0;0;False;0;False;0.15;1;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;739;-2452.917,1104.994;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;681;-2466.565,-221.4788;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;713;-2984.641,701.5917;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;759;-2686.189,-330.4695;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;761;-2673.205,1020.15;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;838;-3041.515,1737.683;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;650;-2670.757,-964.0472;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;839;-3036.052,2103.43;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;745;-971.1313,676.15;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;754;-763.5566,788.0654;Inherit;False;Property;_MixRadiusBlend;MixRadiusBlend;44;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;850;-2714.216,2397.287;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;737;-2461.789,1217.845;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;682;-2475.437,-108.6274;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;549;-2528.624,-989.9111;Inherit;True;Property;_Texture1;Texture1;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;560;-2443.248,-1158.183;Inherit;False;Property;_TexColor1;TexColor1;5;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.9150943,0.9150943,0.9150943,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;749;-478.1482,752.6844;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;747;-487.0203,865.5353;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;718;-2868.471,328.1813;Inherit;True;Property;_Texture3;Texture3;16;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;662;-2532.75,-624.1265;Inherit;True;Property;_Texture2;Texture2;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;860;-2827.26,1530.349;Inherit;False;Property;_TexColor5_1;TexColor5;29;0;Create;False;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;859;-2882.625,2083.567;Inherit;True;Property;_Texture6_1;Texture6;31;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;659;-2447.374,-792.3986;Inherit;False;Property;_TexColor2;TexColor2;8;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.8207547,0.8207547,0.8207547,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;715;-2782.095,159.9095;Inherit;False;Property;_TexColor3;TexColor3;17;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.9150943,0.9150943,0.9150943,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;857;-2878.455,1711.359;Inherit;True;Property;_Texture5_1;Texture5;28;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;861;-2832.26,1905.349;Inherit;False;Property;_TexColor6_1;TexColor6;32;0;Create;False;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;853;-2374.344,2385.494;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;775;-540.7305,1545.459;Inherit;False;Property;_CloudSmoothBlend;CloudSmoothBlend;57;0;Create;True;0;0;0;False;0;False;0.15;1;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;776;-539.8475,1450.313;Inherit;False;Property;_CloudRadiusBlend;CloudRadiusBlend;56;0;Create;True;0;0;0;False;0;False;0.5;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;797;-3548.366,-994.4922;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;774;-746.4221,1247.398;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;884;-756.7122,1491.437;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;673;-2346.98,-318.116;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;716;-2786.221,525.6938;Inherit;False;Property;_TexColor4;TexColor4;20;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.8207547,0.8207547,0.8207547,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;740;-2333.333,1008.357;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;717;-2859.596,692.9661;Inherit;True;Property;_Texture4;Texture4;19;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;766;-706.3668,653.3669;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;851;-2528.127,1720.14;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;571;-2148.269,-975.0898;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;660;-2145.394,-710.3052;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;720;-2484.241,607.7874;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;675;-2179.921,-316.9051;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;854;-2207.283,2386.705;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;741;-2166.272,1009.568;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;800;-3337.473,-838.7003;Inherit;False;VertexColor_B;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;852;-2525.252,1984.925;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;719;-2487.116,343.0024;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;799;-3336.455,-932.6723;Inherit;False;VertexColor_G;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;750;-335.5643,700.0472;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;798;-3334.455,-1025.654;Inherit;False;VertexColor_R;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;779;-204.4386,1387.932;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;780;-212.5526,1503.693;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;886;-542.7333,1323.348;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;806;-2073.448,561.4162;Inherit;False;799;VertexColor_G;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;751;-183.5042,823.2584;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;663;-1933.787,-845.0576;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;817;-2069.411,1870.564;Inherit;False;800;VertexColor_B;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;855;-2313.646,1850.173;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;782;-76.85421,1318.295;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;725;-2272.635,473.0347;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;803;-2012.877,-249.7672;Inherit;False;798;VertexColor_R;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;762;-32.53707,817.8204;Inherit;False;Mix;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;863;-1822.58,-308.5733;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;783;95.20557,1337.506;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;864;-1878.779,470.1078;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;787;-32.70031,1232.567;Inherit;False;Property;_CloudIntensity;CloudIntensity;58;0;Create;True;0;0;0;False;0;False;-0.1;0;-0.2;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;865;-1880.964,1609.149;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;866;-1695.781,444.2462;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;786;254.2996,1274.567;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;763;-1900.305,-45.84689;Inherit;False;762;Mix;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;816;-1611.494,47.5939;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;784;387.1727,1497.068;Inherit;False;Cloud;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;712;-1633.613,-89.33979;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;789;-1380.471,60.1193;Inherit;False;784;Cloud;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;909;-1470.829,-174.0051;Inherit;False;Property;_MapIntensity;MapIntensity;46;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;888;-1381.137,156.9522;Inherit;False;Property;_CloudShadow;CloudShadow;47;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;796;-1471.411,-87.31171;Inherit;False;Property;_UseVertexColorMap;UseVertexColorMap;1;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;908;-1178.829,-128.0051;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;887;-1201.137,63.95221;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;788;-1039.471,-81.88074;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;602;-901.02,-88.43158;Inherit;False;TextureColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;696;-378.4843,-112.3622;Inherit;False;602;TextureColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;911;-471.829,70.99487;Inherit;False;Property;_TexEmission;TexEmission;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;910;-155.829,52.99487;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Koakuma/Ground;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;648;0;647;1
WireConnection;648;1;647;3
WireConnection;867;0;648;0
WireConnection;867;1;868;0
WireConnection;867;2;869;0
WireConnection;707;0;867;0
WireConnection;705;0;703;0
WireConnection;705;1;704;0
WireConnection;829;0;826;0
WireConnection;829;1;827;0
WireConnection;730;0;727;0
WireConnection;730;1;728;0
WireConnection;700;0;711;0
WireConnection;700;1;670;0
WireConnection;700;2;705;0
WireConnection;732;0;729;0
WireConnection;732;1;731;0
WireConnection;732;2;730;0
WireConnection;743;0;752;0
WireConnection;743;1;753;0
WireConnection;836;0;828;0
WireConnection;836;1;830;0
WireConnection;836;2;829;0
WireConnection;876;0;873;2
WireConnection;876;1;872;0
WireConnection;875;0;873;2
WireConnection;875;1;871;0
WireConnection;792;0;791;2
WireConnection;792;1;769;0
WireConnection;870;0;648;0
WireConnection;793;0;791;2
WireConnection;793;1;768;0
WireConnection;733;0;732;0
WireConnection;744;0;756;0
WireConnection;744;1;757;0
WireConnection;744;2;743;0
WireConnection;795;0;770;0
WireConnection;795;1;794;0
WireConnection;840;0;836;0
WireConnection;880;0;876;0
WireConnection;880;1;875;0
WireConnection;878;0;874;0
WireConnection;878;1;877;0
WireConnection;772;0;792;0
WireConnection;772;1;793;0
WireConnection;734;0;732;0
WireConnection;676;0;700;0
WireConnection;841;0;836;0
WireConnection;666;0;700;0
WireConnection;881;0;771;0
WireConnection;881;1;878;0
WireConnection;881;2;880;0
WireConnection;849;0;842;0
WireConnection;849;1;843;0
WireConnection;714;0;723;0
WireConnection;714;1;721;0
WireConnection;664;0;709;0
WireConnection;664;1;665;0
WireConnection;848;0;842;0
WireConnection;848;1;843;0
WireConnection;746;0;744;0
WireConnection;773;0;771;0
WireConnection;773;1;795;0
WireConnection;773;2;772;0
WireConnection;739;0;735;0
WireConnection;739;1;736;0
WireConnection;681;0;674;0
WireConnection;681;1;680;0
WireConnection;713;0;724;0
WireConnection;713;1;722;0
WireConnection;759;0;666;0
WireConnection;759;1;676;0
WireConnection;759;2;758;0
WireConnection;761;0;733;0
WireConnection;761;1;734;0
WireConnection;761;2;760;0
WireConnection;838;0;834;0
WireConnection;838;1;858;0
WireConnection;650;0;708;0
WireConnection;650;1;651;0
WireConnection;839;0;833;0
WireConnection;839;1;862;0
WireConnection;745;0;744;0
WireConnection;850;0;840;0
WireConnection;850;1;841;0
WireConnection;850;2;837;0
WireConnection;737;0;735;0
WireConnection;737;1;736;0
WireConnection;682;0;674;0
WireConnection;682;1;680;0
WireConnection;549;1;650;0
WireConnection;749;0;754;0
WireConnection;749;1;755;0
WireConnection;747;0;754;0
WireConnection;747;1;755;0
WireConnection;718;1;714;0
WireConnection;662;1;664;0
WireConnection;859;1;839;0
WireConnection;857;1;838;0
WireConnection;853;0;850;0
WireConnection;853;1;848;0
WireConnection;853;2;849;0
WireConnection;774;0;773;0
WireConnection;884;0;881;0
WireConnection;673;0;759;0
WireConnection;673;1;681;0
WireConnection;673;2;682;0
WireConnection;740;0;761;0
WireConnection;740;1;739;0
WireConnection;740;2;737;0
WireConnection;717;1;713;0
WireConnection;766;0;745;0
WireConnection;766;1;746;0
WireConnection;766;2;765;0
WireConnection;851;0;860;0
WireConnection;851;1;857;0
WireConnection;571;0;560;0
WireConnection;571;1;549;0
WireConnection;660;0;659;0
WireConnection;660;1;662;0
WireConnection;720;0;716;0
WireConnection;720;1;717;0
WireConnection;675;0;673;0
WireConnection;854;0;853;0
WireConnection;741;0;740;0
WireConnection;800;0;797;3
WireConnection;852;0;861;0
WireConnection;852;1;859;0
WireConnection;719;0;715;0
WireConnection;719;1;718;0
WireConnection;799;0;797;2
WireConnection;750;0;766;0
WireConnection;750;1;749;0
WireConnection;750;2;747;0
WireConnection;798;0;797;1
WireConnection;779;0;776;0
WireConnection;779;1;775;0
WireConnection;780;0;776;0
WireConnection;780;1;775;0
WireConnection;886;0;774;0
WireConnection;886;1;884;0
WireConnection;751;0;750;0
WireConnection;663;0;571;0
WireConnection;663;1;660;0
WireConnection;663;2;675;0
WireConnection;855;0;851;0
WireConnection;855;1;852;0
WireConnection;855;2;854;0
WireConnection;782;0;886;0
WireConnection;782;1;779;0
WireConnection;782;2;780;0
WireConnection;725;0;719;0
WireConnection;725;1;720;0
WireConnection;725;2;741;0
WireConnection;762;0;751;0
WireConnection;863;0;663;0
WireConnection;863;1;803;0
WireConnection;783;0;782;0
WireConnection;864;0;725;0
WireConnection;864;1;806;0
WireConnection;865;0;855;0
WireConnection;865;1;817;0
WireConnection;866;0;863;0
WireConnection;866;1;864;0
WireConnection;866;2;865;0
WireConnection;786;0;787;0
WireConnection;786;2;783;0
WireConnection;816;0;866;0
WireConnection;784;0;786;0
WireConnection;712;0;663;0
WireConnection;712;1;725;0
WireConnection;712;2;763;0
WireConnection;796;1;712;0
WireConnection;796;0;816;0
WireConnection;908;0;909;0
WireConnection;908;1;796;0
WireConnection;887;1;789;0
WireConnection;887;2;888;0
WireConnection;788;0;908;0
WireConnection;788;1;887;0
WireConnection;602;0;788;0
WireConnection;910;0;696;0
WireConnection;910;1;911;0
WireConnection;0;0;696;0
WireConnection;0;2;910;0
ASEEND*/
//CHKSM=DE61E19DF987B2142F6CE351446F9962D578D505