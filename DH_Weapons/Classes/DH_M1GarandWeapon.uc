//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M1GarandWeapon extends DH_SemiAutoWeapon;

#exec OBJ LOAD FILE=..\DarkestHour\Animations\DH_Garand_1st.ukx

var Bool    bIsLastRound;

//overwritten to support garand last round clip eject for Client only
simulated function Fire(float F)
{
    super.Fire(F);

    bIsLastRound = AmmoAmount(0) == 1;
}

//overwritten to support garand last round clip eject for Server only
simulated function bool WasLastRound()
{
    return AmmoAmount(0) == 0;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (Instigator != none && Instigator.Controller != none && DHPlayer(Instigator.Controller) != none)
        DHPlayer(Instigator.Controller).QueueHint(4, true);
}

// Do the actual ammo swapping
function PerformReload()
{
    local int CurrentMagLoad;

    CurrentMagLoad = AmmoAmount(0);

    if (PrimaryAmmoArray.Length == 0)
    {
        return;
    }

    if (CurrentMagLoad < FireMode[0].AmmoClass.default.InitialAmount)
    {
        PrimaryAmmoArray.Remove(CurrentMagIndex, 1);
    }
    else
    {
        PrimaryAmmoArray[CurrentMagIndex] = CurrentMagLoad;
        AmmoCharge[0] = 0;
    }

    if (PrimaryAmmoArray.Length == 0)
    {
        return;
    }

    ++CurrentMagIndex;

    if (CurrentMagIndex > PrimaryAmmoArray.Length - 1)
    {
        CurrentMagIndex = 0;
    }

    AddAmmo(PrimaryAmmoArray[CurrentMagIndex], 0);

    if (Instigator.IsHumanControlled())
    {
        if (AmmoStatus(0) > 0.5)
        {
            PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'ROAmmoWeightMessage',0);
        }
        else if (AmmoStatus(0) > 0.2)
        {
            PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'ROAmmoWeightMessage',1);
        }
        else
        {
            PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'ROAmmoWeightMessage',2);
        }
    }

    if (AmmoAmount(0) > 0)
    {
        if (DHWeaponAttachment(ThirdPersonActor) != none)
        {
            DHWeaponAttachment(ThirdPersonActor).bOutOfAmmo = false;
        }
    }

    ClientForceAmmoUpdate(0, AmmoAmount(0));

    CurrentMagCount = PrimaryAmmoArray.Length - 1;
}

defaultproperties
{
     MagEmptyReloadAnim="reload_empty"
     MagPartialReloadAnim="reload_half"
     IronIdleAnim="Iron_idle"
     IronIdleEmptyAnim="iron_idle_empty"
     IronBringUp="iron_in"
     IronBringUpEmpty="Iron_In_empty"
     IronPutDown="iron_out"
     IronPutDownEmpty="Iron_Out_empty"
//   SelectEmptyAnim=" // Matt: removed as causes warning & no "Draw_empty" anim exists for Garand
     BayoAttachAnim="Bayonet_on"
     BayoDetachAnim="Bayonet_off"
     BayonetBoneName="bayonet"
     bHasBayonet=true
     IdleEmptyAnim="idle_empty"
     MaxNumPrimaryMags=11
     InitialNumPrimaryMags=11
     CrawlForwardAnim="crawlF"
     CrawlBackwardAnim="crawlB"
     CrawlStartAnim="crawl_in"
     CrawlEndAnim="crawl_out"
     IronSightDisplayFOV=20.000000
     ZoomInTime=0.400000
     ZoomOutTime=0.200000
     FreeAimRotationSpeed=7.500000
     FireModeClass(0)=class'DH_Weapons.DH_M1GarandFire'
     FireModeClass(1)=class'DH_Weapons.DH_M1GarandMeleeFire'
     SelectAnim="Draw"
     PutDownAnim="putaway"
     SelectAnimRate=1.000000
     PutDownAnimRate=1.000000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.400000
     CurrentRating=0.400000
     bSniping=true
     DisplayFOV=70.000000
     bCanRestDeploy=true
     PickupClass=class'DH_Weapons.DH_M1GarandPickup'
     BobDamping=1.600000
     AttachmentClass=class'DH_Weapons.DH_M1GarandAttachment'
     ItemName="M1 Garand"
     Mesh=SkeletalMesh'DH_Garand_1st.M1_Garand'
}
