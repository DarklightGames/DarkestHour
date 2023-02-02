//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_30calWeapon extends DHMGWeapon;

defaultproperties
{
    ItemName="M1919A6 Browning Machine Gun"
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_30calFire'
    AttachmentClass=class'DH_Weapons.DH_30calAttachment'
    PickupClass=class'DH_Weapons.DH_30calPickup'

    Mesh=SkeletalMesh'DH_30Cal_1st.30Cal'
    HighDetailOverlay=Shader'DH_Weapon_tex.Spec_Maps.30calMain_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    DisplayFOV=80.0
    IronSightDisplayFOV=60.0

    MaxNumPrimaryMags=2
    InitialNumPrimaryMags=2

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_30CalBarrel'
    BarrelSteamBone="bipod"

    PutDownAnim="putaway"
    MagPartialReloadAnims(0)="Reload"

    BeltBulletClass=class'DH_Weapons.DH_30calBeltRound'
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
