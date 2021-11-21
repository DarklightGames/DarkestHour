//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHShellEject3rd extends Emitter;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(1);
}

defaultproperties
{
    Style=STY_Additive

    bOwnerNoSee=true
    bUnlit=true
    bNoDelete=False
    bHardAttach=True
    RemoteRole=ROLE_None
    Physics=PHYS_None
    bBlockActors=False

    CullDistance=4000.0
}
