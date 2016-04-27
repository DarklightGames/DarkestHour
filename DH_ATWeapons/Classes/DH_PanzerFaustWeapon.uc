//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PanzerFaustWeapon extends DHRocketWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_Panzerfaust_1st.ukx

// Modified to revert to Super from DHWeapon, as faust is a one-shot weapon
function DropFrom(vector StartLocation)
{
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

// Modified as faust can be fired from the hip, unlike other rocket weapons
simulated function bool CanFire(optional bool bShowFailureMessage)
{
    return true;
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
    RangeSettings(0)=(FirePitch=500,IronIdleAnim="Iron_idle30",FireIronAnim="shoot30")
    RangeSettings(1)=(FirePitch=1150,IronIdleAnim="Iron_idle",FireIronAnim="shoot")
    RangeSettings(2)=(FirePitch=2000,IronIdleAnim="Iron_idle90",FireIronAnim="shoot90")
    IdleAnim="idle30"
    MaxNumPrimaryMags=1
    InitialNumPrimaryMags=1
    bCanBeResupplied=false
    FireModeClass(0)=class'DH_ATWeapons.DH_PanzerFaustFire'
    FireModeClass(1)=class'ROInventory.PanzerFaustMeleeFire'
    PickupClass=class'DH_ATWeapons.DH_PanzerFaustPickup'
    AttachmentClass=class'DH_ATWeapons.DH_PanzerFaustAttachment'
    RocketAttachmentClass=class'ROGame.ROFPAmmoRound'
    MuzzleBone="Warhead"
    ItemName="Panzerfaust 60"
    Mesh=SkeletalMesh'Axis_Panzerfaust_1st.Panzerfaust_Mesh'
    Skins(2)=texture'Weapons1st_tex.Grenades.PanzerFaust'
    HighDetailOverlay=Shader'Weapons1st_tex.Grenades.Panzerfaust_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
