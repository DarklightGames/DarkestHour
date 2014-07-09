class DHSeaVolume extends PhysicsVolume;

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

defaultproperties
{
     EntrySoundName="Inf_Player.FootstepWaterDeep"
     ExitSoundName="Inf_Player.FootstepWaterDeep"
     EntryActorName="ROEffects.WaterSplashEmitter"
     PawnEntryActorName="DH_Game.DHWakeEmitter"
     GroundFriction=0.000000
     FluidFriction=0.000000
     bWaterVolume=True
     KExtraLinearDamping=2.500000
     KExtraAngularDamping=0.400000
     LocationName="at sea"
}
