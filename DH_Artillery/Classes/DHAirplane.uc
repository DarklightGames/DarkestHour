//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================
// TODO:
// [ ] Airplanes should be "destructible" in that they can be damaged to a point
// of inoperability. If they are damaged before their payload is released, they
// will not drop bombs or fire guns, will have smoke and flames from their
// propellers, and will not perform subsequent passes. When this happens, an
// obvious explosion and sound should indicate that this has happened.
//==============================================================================

class DHAirplane extends Actor
    abstract;

var localized string    AirplaneName;
var float               Airspeed;       // "Ground" airspeed in meters per second.

var array<name>         BombBoneNames;
var array<name>         PropellerBoneNames;
var name                CockpitBoneName;

var SoundGroup          CloseSound;
var float               CloseSoundRadius;
var float               CloseSoundVolume;
var ROSoundAttachment   CloseSoundAttachment;

simulated function PostBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        // TODO: proper cleanup etc.
        CloseSoundAttachment = Spawn(class'ROSoundAttachment', self);
        CloseSoundAttachment.AmbientSound = CloseSound;
        CloseSoundAttachment.SoundRadius = CloseSoundRadius;
        CloseSoundAttachment.SoundVolume = CloseSoundVolume;
        CloseSoundAttachment.SetBase(self);
        CloseSoundAttachment.SetRelativeLocation(vect(0, 0, 0));
    }
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    Log("TakeDamage" @ self);
}

defaultproperties
{
    AirplaneName="Airplane"
    DrawType=DT_Mesh
    Airspeed=50.0
    AmbientSound=Sound'DH_Airplanes.flybys.flyby_01_ambient'
    SoundVolume=255
    SoundRadius=10000.0 // TODO: fiddle with these
    bAlwaysRelevant=true
    CockpitBoneName="cockpit"
    PropellerBoneNames(0)="propeller"
    bCanBeDamaged=true
}
