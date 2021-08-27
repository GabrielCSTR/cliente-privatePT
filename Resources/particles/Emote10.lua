-- Particle System Script v2.0

Script( "Emote System10" );
Author( "Zeus" );

ParticleSystem( "Billboard" );
	Name( "Emote" );

	-- Objects
	Position( Int( 0 ), Int( 65 ), Int( 0 ) );
	Velocity( Int( 0 ), Int( 4 ), Int( 0 ) );

	RGBA( Int( 255 ), Int( 255 ), Int( 255 ), Int( 255 ) );
	Size( Int( 5 ) );
	
	-- Emitter
	EmitType( "Follow" );

	EmitDelay( Dbl( 0.0 ) );
	EmitLifeTime( Dbl( 2.2999999999999998 ) );

	EmitParticles( Int( 1 ) );
	EmitInterval( Dbl( 0.0 ) );

	-- Particle
	Type( "Follow" );

	Texture( "Resources\\particles\\Texture\\emote10.png" );
	Blend( "Alpha" );

	LifeTime( Dbl( 2.2999999999999998 ) );
	
	EventVelocity( Dbl( 1.5 ), Int( 0 ), Int( 30 ), Int( 0 ) );

	ModifierRGBA( Dbl( 1.7 ), Int( 255 ), Int( 255 ), Int( 255 ), Int( 255 ) );
	ModifierRGBA( Dbl( 2.2999999999999998 ), Int( 255 ), Int( 255 ), Int( 255 ), Int( 0 ) );

	ModifierSize( Dbl( 0.0 ), Int( 5 ) );
	ModifierSize( Dbl( 0.10000000000000001 ), Int( 20 ) );
	
ParticleSystemEnd();