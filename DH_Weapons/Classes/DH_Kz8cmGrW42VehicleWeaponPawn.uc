//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_Kz8cmGrW42VehicleWeaponPawn extends DHMortarVehicleWeaponPawn;

defaultproperties
{
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Mortars_3rd.Kz8cmGrW42_deployed',TransitionUpAnim="Overlay_Out")
    DriverPositions(1)=(ViewFOV=20.0,PositionMesh=SkeletalMesh'DH_Mortars_3rd.Kz8cmGrW42_deployed',TransitionDownAnim="Overlay_In")
    WeaponClass=class'DH_Weapons.DH_Kz8cmGrW42Weapon'
    GunClass=class'DH_Weapons.DH_Kz8cmGrW42VehicleWeapon'
    HUDOverlayClass=class'DH_Weapons.DH_Kz8cmGrW42Overlay'
    DriverFiringAnim="deploy_fire_GrW42"
    DriverUnflinchAnim="flinch_return_GrW42"
    OverlayKnobIdleAnim="traverse_idle"
    DriveAnim="deploy_idle_GrW42"
    DrivePos=(X=28.0,Z=34.0)
    UndeployingDuration=1.4
    HUDHighExplosiveTexture=Texture'DH_Mortars_tex.Kz8cmGrW42.Wgr34-HE'
    HUDSmokeTexture=Texture'DH_Mortars_tex.Kz8cmGrW42.Wgr34-Nb'
    HUDArcTexture=Texture'DH_Mortars_tex.HUD.ArcG'
    
    RangeTable(0)=(Mils=50,Range=100)
    RangeTable(1)=(Mils=85,Range=150)
    RangeTable(2)=(Mils=115,Range=200)
    RangeTable(3)=(Mils=150,Range=250)
    RangeTable(4)=(Mils=180,Range=300)
    RangeTable(5)=(Mils=210,Range=350)
    RangeTable(6)=(Mils=245,Range=400)
    RangeTable(7)=(Mils=280,Range=450)
    RangeTable(8)=(Mils=320,Range=500)
    RangeTable(9)=(Mils=355,Range=550)
    RangeTable(10)=(Mils=400,Range=600)
    RangeTable(11)=(Mils=450,Range=650)
    RangeTable(12)=(Mils=500,Range=700)
    RangeTable(13)=(Mils=570,Range=750)
    RangeTable(14)=(Mils=665,Range=800)
    RangeTable(15)=(Mils=775,Range=820)
    RangeTable(16)=(Mils=890,Range=800)
    RangeTable(17)=(Mils=990,Range=750)
    RangeTable(18)=(Mils=1055,Range=700)
    RangeTable(19)=(Mils=1110,Range=650)
    RangeTable(20)=(Mils=1160,Range=600)
    RangeTable(21)=(Mils=1200,Range=550)
    RangeTable(22)=(Mils=1240,Range=500)
    RangeTable(23)=(Mils=1280,Range=450)
}
