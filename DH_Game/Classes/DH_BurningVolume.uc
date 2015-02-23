//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BurningVolume extends PhysicsVolume;

var()   class<DamageType>   FireDamageType;
var()   int                 FireDamageAmount;

//Overridden to allow for DH fire damage type, and igniting players on fire
function CausePainTo(Actor Other)
{
    local float depth;
    local Pawn P;

    // FIXMEZONE figure out depth of actor, and base pain on that!!!
    depth = 1;
    P = Pawn(Other);

    if (DamagePerSec > 0)
    {
        if (Region.Zone.bSoftKillZ && Other.Physics != PHYS_Walking)
            return;
        Other.TakeDamage(int(DamagePerSec * depth), none, Location, vect(0.0, 0.0, 0.0), DamageType);
        if (P != none && P.Health <= 20)
            Other.TakeDamage(int(FireDamageAmount * depth), none, Location, vect(0.0, 0.0, 0.0), FireDamageType);

        if (P != none && P.Controller != none)
            P.Controller.PawnIsInPain(self);

    }
    else
    {
        if (P != none && P.Health < P.HealthMax)
            P.Health = Min(P.HealthMax, P.Health - depth * DamagePerSec);
    }
}

defaultproperties
{
    FireDamageAmount=1
    DamagePerSec=45
    FireDamageType=class'DH_Engine.DH_BurningDamType'
    DamageType=class'FellLava'
    bPainCausing=true
    bWaterVolume=false
    bDestructive=true
    bNoInventory=true
    ViewFog=(X=0.5859375,Y=0.1953125,Z=0.078125)
    FluidFriction=+00004.0
    KExtraLinearDamping=0.8
    KExtraAngularDamping=0.1
    RemoteRole=ROLE_None
    bNoDelete=true
}
