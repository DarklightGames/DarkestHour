//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerFaustWeapon extends DHRocketWeapon;

// Modified to revert to Super from DHWeapon, as faust is a one-shot weapon
function DropFrom(vector StartLocation)
{
    if (!HasAmmo())
    {
        // If the panzerfaust has no ammo, it is useless, so don't drop it
        return;
    }

    super(DHWeapon).DropFrom(StartLocation);
}

// Modified to revert to Super in DHWeapon, as faust is a one-shot weapon
function bool HandlePickupQuery(Pickup Item)
{
    return super(DHWeapon).HandlePickupQuery(Item);
}

// Modified to revert to Super from DHWeapon, as faust is a one-shot weapon that doesn't use ammo mags
simulated function int GetHudAmmoCount()
{
    return super(DHWeapon).GetHudAmmoCount();
}

// Emptied out as faust doesn't use CurrentMagCount & can't be resupplied or reloaded
function UpdateResupplyStatus(bool bCurrentWeapon)
{
}

// Modified as faust is one-shot weapon, so auto-lowers after firing & then either switches to a new weapon or brings up another faust (if player has another - not normally in DH)
simulated function PostFire()
{
    if (RocketAttachment != none)
    {
        RocketAttachment.Destroy();
    }

    GotoState('PostFiring');
}

// State where the weapon has just been fired, switching to state AutoLoweringWeapon after firing animation ends
simulated state PostFiring
{
    simulated function bool IsBusy()
    {
        return true;
    }

    simulated function Timer()
    {
        GotoState('AutoLoweringWeapon');
    }

    simulated function BeginState()
    {
        SetTimer(GetAnimDuration(FireMode[0].FireAnim, 1.0), false);
    }

    simulated function EndState()
    {
        if (ROWeaponAttachment(ThirdPersonActor) != none)
        {
            ROWeaponAttachment(ThirdPersonActor).AmbientSound = none;
        }

        OldWeapon = none;
    }
}

// Modified to reset sight range setting if we bring up a new faust & to take player out of ironsights
simulated state AutoLoweringWeapon
{
    simulated function Timer()
    {
        super.Timer();

        if (AmmoAmount(0) > 0)
        {
            RangeIndex = default.RangeIndex;
        }
    }

// Take the player out of ironsights
Begin:
    if (bUsingSights)
    {
        ZoomOut();

        if (InstigatorIsLocalHuman())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }
}

defaultproperties
{
    ItemName="Panzerfaust 60"
    FireModeClass(0)=class'DH_Weapons.DH_PanzerFaustFire'
    FireModeClass(1)=class'DH_Weapons.DH_PanzerFaustMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_PanzerFaustAttachment'
    PickupClass=class'DH_Weapons.DH_PanzerFaustPickup'

    Mesh=SkeletalMesh'DH_Panzerfaust_1st.Panzerfaust_Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Grenades.Panzerfaust_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    RocketAttachmentClass=class'ROGame.ROFPAmmoRound'
    MuzzleBone="Warhead"
    RocketBone="Warhead"
    MaxNumPrimaryMags=1
    InitialNumPrimaryMags=1
    bCanBeResupplied=false

    RangeSettings(0)=(FirePitch=500,IronIdleAnim="Iron_idle30",IronFireAnim="shoot30")
    RangeSettings(1)=(FirePitch=1150,IronIdleAnim="Iron_idle",IronFireAnim="shoot")
    RangeSettings(2)=(FirePitch=2000,IronIdleAnim="Iron_idle90",IronFireAnim="shoot90")
    IdleAnim="idle2"
}
