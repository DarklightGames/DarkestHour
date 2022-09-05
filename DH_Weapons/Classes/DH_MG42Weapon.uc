//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_MG42Weapon extends DHMGWeapon;

// Modified so we do faster net updated when we're down to the last few rounds
simulated function bool ConsumeAmmo(int Mode, float Load, optional bool bAmountNeededIsMax)
{
    if (AmmoAmount(0) < 11)
    {
        NetUpdateTime = Level.TimeSeconds - 1.0;
    }

    return super.ConsumeAmmo(Mode, Load, bAmountNeededIsMax);
}

defaultproperties
{
    ItemName="Maschinengewehr 42"
    TeamIndex=0
    FireModeClass(0)=class'DH_Weapons.DH_MG42Fire'
    AttachmentClass=class'DH_Weapons.DH_MG42Attachment'
    PickupClass=class'DH_Weapons.DH_MG42Pickup'

    Mesh=SkeletalMesh'DH_Mg42_1st.MG42_Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.MG.MG42_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    HandTex=Texture'Weapons1st_tex.Arms.hands_gergloves'

    DisplayFOV=85.0
    IronSightDisplayFOV=60.0
    PlayerIronsightFOV=90.0
    
    bCanFireFromHip=true
    FreeAimRotationSpeed=2.0
    
    IronBringUp="Rest_2_Hip"
    IronPutDown="Hip_2_Rest"
    BipodHipIdle="Hip_Idle"
    BipodHipToDeploy="Hip_2_Bipod"

    MaxNumPrimaryMags=2
    InitialNumPrimaryMags=2

    InitialBarrels=2
    BarrelClass=class'DH_Weapons.DH_MG42Barrel'
    BarrelSteamBone="Barrel_Switch"
    BarrelChangeAnim="Bipod_Barrel_Change"

    PutDownAnim="putaway"

    BeltBulletClass=class'ROInventory.MG42BeltRound'
    MGBeltBones(0)="Case09"
    MGBeltBones(1)="Case08"
    MGBeltBones(2)="Case07"
    MGBeltBones(3)="Case06"
    MGBeltBones(4)="Case05"
    MGBeltBones(5)="Case04"
    MGBeltBones(6)="Case03"
    MGBeltBones(7)="Case02"
    MGBeltBones(8)="Case01"
    MGBeltBones(9)="Case"
}
