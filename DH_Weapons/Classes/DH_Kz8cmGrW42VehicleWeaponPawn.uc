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
    
    // to do: confirm those values are correct!
    RangeTable(0)=(Mils=88,Range=25)
    RangeTable(1)=(Mils=87,Range=40)
    RangeTable(2)=(Mils=86,Range=55)
    RangeTable(3)=(Mils=85,Range=75)
    RangeTable(4)=(Mils=84,Range=90)
    RangeTable(5)=(Mils=83,Range=105)
    RangeTable(6)=(Mils=82,Range=120)
    RangeTable(7)=(Mils=81,Range=135)
    RangeTable(8)=(Mils=80,Range=150)
    RangeTable(9)=(Mils=79,Range=160)
    RangeTable(10)=(Mils=78,Range=175)
    RangeTable(11)=(Mils=77,Range=190)
    RangeTable(12)=(Mils=76,Range=205)
    RangeTable(13)=(Mils=75,Range=215)
    RangeTable(14)=(Mils=74,Range=230)
    RangeTable(15)=(Mils=73,Range=240)
    RangeTable(16)=(Mils=72,Range=255)
    RangeTable(17)=(Mils=71,Range=265)
    RangeTable(18)=(Mils=70,Range=280)
    RangeTable(19)=(Mils=69,Range=290)
    RangeTable(20)=(Mils=68,Range=300)
    RangeTable(21)=(Mils=67,Range=310)
    RangeTable(22)=(Mils=66,Range=320)
    RangeTable(23)=(Mils=65,Range=330)
    RangeTable(24)=(Mils=64,Range=340)
    RangeTable(25)=(Mils=63,Range=350)
    RangeTable(26)=(Mils=62,Range=360)
    RangeTable(27)=(Mils=61,Range=365)
    RangeTable(28)=(Mils=60,Range=375)
    RangeTable(29)=(Mils=59,Range=385)
    RangeTable(30)=(Mils=58,Range=390)
    RangeTable(31)=(Mils=57,Range=395)
    RangeTable(32)=(Mils=56,Range=400)
    RangeTable(33)=(Mils=55,Range=405)
    RangeTable(34)=(Mils=54,Range=410)
    RangeTable(35)=(Mils=53,Range=415)
    RangeTable(36)=(Mils=52,Range=420)
    RangeTable(37)=(Mils=51,Range=425)
    RangeTable(38)=(Mils=50,Range=425)
    RangeTable(39)=(Mils=49,Range=430)
    RangeTable(40)=(Mils=48,Range=430)
    RangeTable(41)=(Mils=47,Range=430)
    RangeTable(42)=(Mils=46,Range=435)
    RangeTable(43)=(Mils=45,Range=435)
}
