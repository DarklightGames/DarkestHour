//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PanzerFaustWeapon extends DHRocketWeapon;

// Modified to revert to Super from DHWeapon, as faust is a one-shot weapon
function DropFrom(Vector StartLocation)
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
    NativeItemName="Panzerfaust 60"
    FireModeClass(0)=Class'DH_PanzerFaustFire'
    FireModeClass(1)=Class'DH_PanzerFaustMeleeFire'
    AttachmentClass=Class'DH_PanzerFaustAttachment'
    PickupClass=Class'DH_PanzerFaustPickup'

    Mesh=SkeletalMesh'DH_Panzerfaust_1st.Panzerfaust_Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Grenades.Panzerfaust_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    RocketAttachmentClass=Class'ROFPAmmoRound'
    MuzzleBone="Warhead"
    RocketBone="Warhead"
    MaxNumPrimaryMags=1
    InitialNumPrimaryMags=1
    bCanBeResupplied=false
    bCanResupplyWhenEmpty=true

    RangeDistanceUnit=DU_Meters
    RangeSettings(0)=(Range=30,FirePitch=500,IronIdleAnim="Iron_idle30",IronFireAnim="shoot30")
    RangeSettings(1)=(Range=60,FirePitch=1150,IronIdleAnim="Iron_idle",IronFireAnim="shoot")
    RangeSettings(2)=(Range=80,FirePitch=2000,IronIdleAnim="Iron_idle90",IronFireAnim="shoot90")    // The text on the weapon says 80, but the range is actually 90?
    IdleAnim="idle2"
}
