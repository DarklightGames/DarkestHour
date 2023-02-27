//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M1928_30rndWeapon extends DHFastAutoWeapon;

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

defaultproperties
{
    ItemName="M1928 Thompson (30rd)"
    SwayModifyFactor=0.78 // +0.08
    FireModeClass(0)=class'DH_Weapons.DH_M1928_30rndFire'
    FireModeClass(1)=class'DH_Weapons.DH_ThompsonMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M1928_30rndAttachment'
    PickupClass=class'DH_Weapons.DH_M1928_30rndPickup'

    Mesh=SkeletalMesh'DH_Thompson_1st.M1928_30rnd' // TODO: there is no specularity mask for this weapon

    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=65.0

    DisplayFOV=86.0
    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_ThompsonBarrel'
    BarrelSteamBone="Muzzle"

    bHasSelectFire=true
    SelectFireAnim="fire_select"
    SelectFireIronAnim="Iron_fire_select"
    PutDownAnim="put_away"

    MagEmptyReloadAnims(0)="reload_m1a1"
    MagPartialReloadAnims(0)="reload_m1a1"

    HandNum=1
    SleeveNum=0
    HighDetailOverlayIndex=2
}
