//=============================================================================
// EA_SplashOnlyWaterVol
//=============================================================================
// Author	| Andrew Theel
//-----------------------------------------------------------------------------
// Date		| July 6th, 2014
//-----------------------------------------------------------------------------
// Purpose	| Water volume to stop many bugs and annoyances with normal vol
//			| Uses new emitters for projectile effects
//-----------------------------------------------------------------------------
// Limits	| TBD I can set other round types and make new emitters if need be!
//-----------------------------------------------------------------------------
// To Do	| Remake with DH_Pawn to have proper effects/swimming
//=============================================================================

class EA_SplashOnlyWaterVol extends PhysicsVolume;

var string EntrySoundName, ExitSoundName, EntryActorName, PawnEntryActorName;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( (EntrySound == None) && (EntrySoundName != "") )
		EntrySound = Sound(DynamicLoadObject(EntrySoundName,class'Sound'));
	if ( (ExitSound == None) && (ExitSoundName != "") )
		ExitSound = Sound(DynamicLoadObject(ExitSoundName,class'Sound'));
	if ( (EntryActor == None) && (EntryActorName != "") )
		EntryActor = class<Actor>(DynamicLoadObject(EntryActorName,class'Class'));
	if ( (PawnEntryActor == None) && (PawnEntryActorName != "") )
		PawnEntryActor = class<Actor>(DynamicLoadObject(PawnEntryActorName,class'Class'));
}

/*
simulated event PawnEnteredVolume(Pawn Other)
{
	super.PawnEnteredVolume(Other);

	//Enable in water effects
	if( Other.IsA('ROPawn') )
	{
		//DH_Pawn(Other).SetSprinting(false);
		ROPawn(Other).SetLimping(300);

  		Level.Game.Broadcast(self, "Pawn in water, no sprinting and is limping", 'Say');
	}
}

event PawnLeavingVolume(Pawn Other)
{
	super.PawnLeavingVolume(Other);

	//Disable in water effects
	if( Other.IsA('ROPawn') )
	{
		ROPawn(Other).LimpTime = 0.0;

		Level.Game.Broadcast(self, "Pawn left water, sprinting enabled and not limping");
	}
}
*/

simulated event touch(Actor Other)
{
	local int i;

	Super.Touch(Other);

	//Handle Pawns on Fire!
	if( Other.IsA('DH_Pawn') && DH_Pawn(Other).bOnFire == true)
	{
		DH_Pawn(Other).bOnFire = false;
		DH_Pawn(Other).bBurnFXOn = false;
		DH_Pawn(Other).bCharred = false;

		if (level.NetMode != NM_DEDICATEDSERVER)
		{
			DH_Pawn(Other).EndBurnFX(); //Stop flame effects on the pawn

			//Leaving charred looks dumb and anyone with that much burn degree wouldn't be able to fight
			//So I remove charred and turn off all overlay materials
			DH_Pawn(Other).SetOverlayMaterial(None, 0.0f, true);
			DH_Pawn(Other).HeadGear.SetOverlayMaterial(None, 0.0f, true);

			//Gotta do it to ammo pouches as well
			for (i = 0; i < DH_Pawn(Other).AmmoPouches.Length; i++)
				DH_Pawn(Other).AmmoPouches[i].SetOverlayMaterial(None, 0.0f, true);
		}
	}

	//Handle projectile effects & splashes
	if( Level.NetMode != NM_DedicatedServer )
	{
		if( Other.IsA('ROBallisticProjectile') && !Level.bDropDetail && Level.DetailMode != DM_Low )
		{
			if( Other.IsA('ROAntiVehicleProjectile') )
			{
				EntryActor = class'EA_ExplosiveSplashEffect';
				//Testing will have to make new one for sound
				//EntryActor = class'TankHEHitWaterEffect';
				//EntryActor = class'TankAPHitWaterEffect';
				//EntryActor = class'ROArtilleryWaterEmitter';
			}

			if( Other.IsA('ROBullet') )
			{
				//Use this one as final
				EntryActor = class'EA_BulletSplashEffect';

				//Testing
				//EntryActor = class'DH_ExplosiveSplashEffect';
				//EntryActor = class'WaterSplashEmitter';
				//EntryActor = class'ROBulletHitWaterEffect';
				//BulletSplashEmitter
			}

			PlayEntrySplash(Other);
		}
		/*
		else if ( Other.IsA('ROArtilleryShell') && !Level.bDropDetail && Level.DetailMode != DM_Low )
		{
			//I should custom make a arty emitter that only has water (so it doesn't double up on smoke/explosion effects)
			EntryActor = class'ROArtilleryWaterEmitter';
			PlayEntrySplash(Other);
		}
		*/
	}
}

defaultproperties
{
	PawnEntryActorName=""
	ExitSoundName=""
	EntrySoundName=""
	EntryActor="EA_BulletSplashEffect"
	LocationName="under water"
	bDistanceFog=true
	DistanceFogColor=(R=0,G=0,B=0,A=0)
	DistanceFogStart=0.0
	DistanceFogEnd=64.0
	KExtraLinearDamping=2.5
	KExtraAngularDamping=0.4
}
