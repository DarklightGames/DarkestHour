//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHShellEject3rd extends Emitter;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(1);
}

simulated function SetShellVelocity(float MinX, float MaxX, float MinY, float MaxY, float MinZ, float MaxZ)
{
    Emitters[0].StartVelocityRange.X.Min = MinX;
    Emitters[0].StartVelocityRange.X.Max = MaxX;
    Emitters[0].StartVelocityRange.Y.Min = MinY;
    Emitters[0].StartVelocityRange.Y.Max = MaxY;
    Emitters[0].StartVelocityRange.Z.Min = MinZ;
    Emitters[0].StartVelocityRange.Z.Max = MaxZ;
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
