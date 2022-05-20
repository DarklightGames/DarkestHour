//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_PIATWeapon extends DHRocketWeapon;

// Modified to prevent reloading unless prone or rested (with message) or if weapon is not empty
simulated function bool AllowReload()
{
    if (Instigator == none || !Instigator.bIsCrawling)
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

defaultproperties
{
    ItemName="P.I.A.T."
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_PIATFire'
    FireModeClass(1)=class'DH_Weapons.DH_PIATMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_PIATAttachment'
    PickupClass=class'DH_Weapons.DH_PIATPickup'

    Mesh=SkeletalMesh'DH_PIAT_1st.PIAT_1st' // TODO: there is no specularity mask for this weapon

    DisplayFOV=90
    IronSightDisplayFOV=55.0 //25.0

    RocketAttachmentClass=class'DH_Weapons.DH_PIATAmmoRound'
    RocketBone="bomb"

    MuzzleBone="muzzle"
    InitialNumPrimaryMags=2
    NumMagsToResupply=2
    MagEmptyReloadAnims(0)="reload"
    MagPartialReloadAnims(0)="reload"

    RangeSettings(0)=(FirePitch=85,IronIdleAnim="iron_idle_050",FireIronAnim="iron_shoot_050")
    RangeSettings(1)=(FirePitch=325,IronIdleAnim="iron_idle_080",FireIronAnim="iron_shoot_080")
    RangeSettings(2)=(FirePitch=500,IronIdleAnim="iron_idle_110",FireIronAnim="iron_shoot_110")
}
