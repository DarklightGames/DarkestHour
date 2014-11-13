//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHSeaVolume extends PhysicsVolume;

var string EntrySoundName, ExitSoundName, EntryActorName, PawnEntryActorName;

function PostBeginPlay()
{
    Super.PostBeginPlay();

    if ((EntrySound == none) && (EntrySoundName != ""))
        EntrySound = Sound(DynamicLoadObject(EntrySoundName,class'Sound'));
    if ((ExitSound == none) && (ExitSoundName != ""))
        ExitSound = Sound(DynamicLoadObject(ExitSoundName,class'Sound'));
    if ((EntryActor == none) && (EntryActorName != ""))
        EntryActor = class<Actor>(DynamicLoadObject(EntryActorName,class'Class'));
    if ((PawnEntryActor == none) && (PawnEntryActorName != ""))
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
     bWaterVolume=true
     KExtraLinearDamping=2.500000
     KExtraAngularDamping=0.400000
     LocationName="at sea"
}
