//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PIATWeapon extends DHRocketWeapon;

// Overridden to make ironsights key try to deploy/undeploy the bipod, otherwise it goes to iron sights without deploying if weapon allows it
simulated function ROIronSights()
{
    local DHPlayer PC;

    if (bCanBipodDeploy && Instigator != none && (Instigator.bBipodDeployed || Instigator.bCanBipodDeploy))
    {
        if (Instigator.IsLocallyControlled())
        {
            PC = DHPlayer(Instigator.Controller);

            if (PC == none || Level.TimeSeconds < PC.NextToggleDuckTimeSeconds)
            {
                return;
            }
        }

        Deploy();
    }
    else if (bCanUseIronsights || bCanFireFromHip)
    {
        PerformZoom(!bUsingSights);
    }
}


defaultproperties
{
    ItemName="PIAT"
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_PIATFire'
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

    RangeSettings(0)=(FirePitch=50,IronIdleAnim="iron_idle_050",IronFireAnim="iron_shoot_050",BipodIdleAnim="bipod_idle_050",BipodFireAnim="bipod_shoot_050")
    RangeSettings(1)=(FirePitch=275,IronIdleAnim="iron_idle_080",IronFireAnim="iron_shoot_080",BipodIdleAnim="bipod_idle_080",BipodFireAnim="bipod_shoot_080")
    RangeSettings(2)=(FirePitch=500,IronIdleAnim="iron_idle_110",IronFireAnim="iron_shoot_110",BipodIdleAnim="bipod_idle_110",BipodFireAnim="bipod_shoot_110")

    // Bipod
    bCanBipodDeploy=true
    bMustReloadWithBipodDeployed=true
    IdleToBipodDeploy="idle_to_bipod"
    IronToBipodDeploy="iron_to_bipod"
    BipodDeployToIdle="bipod_to_idle"
    BipodMagEmptyReloadAnim="reload"
    BipodMagPartialReloadAnim="reload"
}
