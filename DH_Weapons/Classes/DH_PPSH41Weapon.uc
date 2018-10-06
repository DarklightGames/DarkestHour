//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_PPSh41Weapon extends DHFastAutoWeapon;

simulated function bool StartFire(int Mode)
{
    if (super(DHProjectileWeapon).StartFire(Mode))
    {
        if (FireMode[Mode].bMeleeMode)
        {
            return true;
        }

        AnimStopLooping();

        // single
        if (FireMode[0].bWaitForRelease)
        {
            return true;
        }
        else // auto
        {
            if (!FireMode[Mode].IsInState('FireLoop'))
            {
                FireMode[Mode].StartFiring();
                return true;
            }
        }
    }

    return false;
}

// Modified to play the click sound as there is no anim AND a hack to allow for another firemode for a DHFastAutoWeapon
simulated function ToggleFireMode()
{
    PlaySound(Sound'Inf_Weapons_Foley.stg44.stg44_firemodeswitch01',, 2.0);

    // Toggles the fire mode between single and auto
    if (bHasSelectFire)
    {
        FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
    }
}

defaultproperties
{
    ItemName="PPSh-41"

    FireModeClass(0)=class'DH_Weapons.DH_PPSH41Fire'
    FireModeClass(1)=class'DH_Weapons.DH_PPSH41MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_PPSH41Attachment'
    PickupClass=class'DH_Weapons.DH_PPSH41Pickup'

    Mesh=SkeletalMesh'Allies_Ppsh_1st.PPSH-41-mesh'
    HighDetailOverlay=shader'Weapons1st_tex.SMG.PPSH41_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=30.0

    bHasSelectFire=true
    MaxNumPrimaryMags=3
    InitialNumPrimaryMags=3
}
