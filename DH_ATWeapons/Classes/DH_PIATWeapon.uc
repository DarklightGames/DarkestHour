//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PIATWeapon extends DHRocketWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_PIAT_1st.ukx

// Modified to prevent reloading unless prone or rested (with message) or if weapon is not empty
simulated function bool AllowReload()
{
    if (Instigator == none || (!Instigator.bIsCrawling && !Instigator.bRestingWeapon))
    {
        if (Instigator.IsHumanControlled())
        {
            WarningMessageClass.static.ClientReceive(PlayerController(Instigator.Controller), 5,,, self); // can't reload unless prone or rested
        }

        return false;
    }

    if (!IsLoaded())
    {
        return super(DHProjectileWeapon).AllowReload();
    }
}

// Modified to prevent crouching while reloading
simulated state Reloading
{
    simulated function bool WeaponAllowCrouchChange()
    {
        return false;
    }
}

// Modified as PIAT can only be fired when player is prone or weapon is rested
simulated function bool CanFire()
{
    if (!bUsingSights)
    {
        if (InstigatorIsHumanControlled())
        {
            WarningMessageClass.static.ClientReceive(PlayerController(Instigator.Controller), 1,,, self); // can't fire from hip
        }

        return false;
    }

    if (Instigator == none || (!Instigator.bIsCrawling && !Instigator.bRestingWeapon))
    {
        if (InstigatorIsHumanControlled())
        {
            WarningMessageClass.static.ClientReceive(PlayerController(Instigator.Controller), 3,,, self); // can't fire unless prone or rested
        }

        return false;
    }

    return true;
}

defaultproperties
{
    RangeSettings(0)=(FirePitch=85,IronIdleAnim="Iron_idle",FireIronAnim="iron_shoot")
    RangeSettings(1)=(FirePitch=325,IronIdleAnim="iron_idleMid",FireIronAnim="iron_shootMid")
    RangeSettings(2)=(FirePitch=500,IronIdleAnim="iron_idleFar",FireIronAnim="iron_shootFar")
    NumMagsToResupply=2
    MagEmptyReloadAnim="Reload"
    MagPartialReloadAnim="Reload"
    InitialNumPrimaryMags=2
    FireModeClass(0)=class'DH_ATWeapons.DH_PIATFire'
    FireModeClass(1)=class'DH_ATWeapons.DH_PIATMeleeFire'
    PickupClass=class'DH_ATWeapons.DH_PIATPickup'
    MuzzleBone="Warhead"
    AttachmentClass=class'DH_ATWeapons.DH_PIATAttachment'
    RocketAttachmentClass=class'DH_PIATAmmoRound'
    ItemName="PIAT"
    Mesh=SkeletalMesh'DH_PIAT_1st.PIAT'
}
