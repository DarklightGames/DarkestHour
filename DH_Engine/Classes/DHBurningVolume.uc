//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBurningVolume extends PhysicsVolume;

var()   int                 FireDamageAmount;
var()   class<DamageType>   FireDamageType;

// Modified to allow for DH fire damage type & and igniting players on fire
function CausePainTo(Actor Other)
{
    local Pawn P;

    P = Pawn(Other);

    if (DamagePerSec > 0.0)
    {
        if (Region.Zone.bSoftKillZ && Other.Physics != PHYS_Walking)
        {
            return;
        }

        Other.TakeDamage(int(DamagePerSec), none, Location, vect(0.0, 0.0, 0.0), DamageType);

        if (P != none)
        {
            if (P.Health <= 20)
            {
               P.TakeDamage(FireDamageAmount, none, Location, vect(0.0, 0.0, 0.0), FireDamageType);
            }

            if (P.Controller != none)
            {
                P.Controller.PawnIsInPain(self);
            }
        }
    }
    else if (P != none && P.Health < P.HealthMax)
    {
        P.Health = Min(P.HealthMax, P.Health - int(DamagePerSec));
    }
}

defaultproperties
{
    FireDamageAmount=1
    DamagePerSec=45.0
    FireDamageType=class'DH_Engine.DHBurningDamageType'
    DamageType=class'FellLava'
    bPainCausing=true
    bDestructive=true
    bNoInventory=true
    ViewFog=(X=0.5859375,Y=0.1953125,Z=0.078125)
    FluidFriction=4.0
    KExtraLinearDamping=0.8
    KExtraAngularDamping=0.1
    RemoteRole=ROLE_None
}
