//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_SdKfz251_22CannonPawn extends DH_Pak40CannonPawn;

var vector WeaponAttachmentOffset; // used to reposition Pak40 relative to attachment bone (easy to add bone to hull mesh, but would then need modified interior mesh to match)

// Modified to remove excess Pak40 AT gun exit positions
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    ExitPositions.Length = 2;
}

// Modified to reposition the Pak40 to fit correctly onto the pedestal mount
// But relative location & rotation won't replicate reliably to clients (timing issues in replication of actors), so need to set separately on client in PostNetReceive
simulated function InitializeCannon()
{
    super.InitializeCannon();

    if (Gun != none)
    {
        Gun.SetRelativeLocation(WeaponAttachmentOffset);
    }
}

// Modified to skip over the Super in DHATGunCannonPawn, as that prevents any switching position
simulated function SwitchWeapon(byte F)
{
    super(DHVehicleCannonPawn).SwitchWeapon(F);
}

defaultproperties
{
    GunClass=class'DH_Guns.DH_SdKfz251_22Cannon'
    WeaponAttachmentOffset=(X=-42.76,Y=0.3,Z=37.95) // don't have a bone for the Pak40 attachment, so this offsets from the hull's 'body' bone
    DriverPositions(1)=(DriverTransitionAnim="stand_idlehold_bayo",ViewPositiveYawLimit=2400,ViewNegativeYawLimit=-5100) // anim better positions the standing gunner in a vehicle
    DrivePos=(X=-11.0,Y=-1.0,Z=-57.0)
    EntryRadius=130.0
}
