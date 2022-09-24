//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// The FG-42 has a unique bolt operation. It operates in open-bolt while in
// automatic mode and closed bolt in single-fire mode.
// If the user switches to semi-automatic mode, the weapon will operate from a
// closed bolt once the weapon is fired, and vice versa.
//
// To accomodate this from an animation perspective, the FG42 weapon animations
// have two separate bolts in their animations that animate independently.
// Depending on whether or not the weapon is operating in open-bolt or closed-
// bolt mode, the inactive bolt will be scaled to zero, hiding it. This
// eliminates the need for having redundant animations that differ only
// in the bolt configuration and all the supporting code that would be required
// to play the right animations.
//==============================================================================

class DH_FG42Weapon extends DHAutoWeapon;

// Bolt operation.
var private enum EBoltMode
{
    BM_Open,
    BM_Closed
} BoltMode;
var int BoltOpenSlot;
var int BoltClosedSlot;
var name BoltOpenBoneName;
var name BoltClosedBoneName;

// Sets the bolt mode and updates the bolt visuals.
simulated function SetBoltMode(EBoltMode BoltMode)
{
    if (self.BoltMode != BoltMode)
    {
        self.BoltMode = BoltMode;

        UpdateBolt();
    }
}

// This hides & shows the correct bolt bones depending on the bolt mode.
simulated private function UpdateBolt()
{
    if (BoltMode == BM_Closed)
    {
        SetBoneScale(BoltClosedSlot, 1.0, BoltClosedBoneName);
        SetBoneScale(BoltOpenSlot, 0.0, BoltOpenBoneName);
    }
    else if (BoltMode == BM_Open)
    {
        SetBoneScale(BoltClosedSlot, 0.0, BoltClosedBoneName);
        SetBoneScale(BoltOpenSlot, 1.0, BoltOpenBoneName);
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (InstigatorIsLocallyControlled())
    {
        UpdateBolt();
    }
}

defaultproperties
{
    ItemName="FG 42"
    NativeItemName="Fallschirmjägergewehr 42"
    TeamIndex=0
    FireModeClass(0)=class'DH_Weapons.DH_FG42Fire'
    FireModeClass(1)=class'DH_Weapons.DH_FG42MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_FG42Attachment'
    PickupClass=class'DH_Weapons.DH_FG42Pickup'

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_FG42Barrel'
    BarrelSteamBone="Muzzle"

    Mesh=SkeletalMesh'DH_Fallschirmgewehr42_1st.FG42_1st'

    IronSightDisplayFOV=50.0
    DisplayFOV=85.0

    MaxNumPrimaryMags=11
    InitialNumPrimaryMags=11

    bHasSelectFire=true

    SelectFireAnim="switchfiremode"
    SelectFireIronAnim="Iron_switchfiremode"
    SelectFireBipodIronAnim="deploy_switchfiremode"
    IdleToBipodDeploy="Deploy"
    BipodDeployToIdle="undeploy"
    BipodIdleAnim="deploy_idle"
    BipodMagEmptyReloadAnim="deploy_reload"
    BipodMagPartialReloadAnim="deploy_reload"

    bCanBipodDeploy=true
    ZoomOutTime=0.1
    PutDownAnim="putaway"

    MagEmptyReloadAnims(0)="reload"
    MagPartialReloadAnims(0)="reload"

    // Bolt operation
    BoltMode=BM_Open
    BoltOpenSlot=0
    BoltClosedSlot=1
    BoltOpenBoneName="bolt_open"
    BoltClosedBoneName="bolt_closed"
}
