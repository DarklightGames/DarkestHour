//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_GMCTruckSupport extends DH_GMCTruck;

defaultproperties
{
    ResupplyAttachBone="supply"
    VehicleAttachments(0)=(StaticMesh=StaticMesh'DH_Military_stc.Ammo.CratePile3_Dark',AttachBone="Deco") // decorative only representation of resupply crates
    PassengerPawns(1)=(AttachBone="passenger_l_5",DrivePos=(X=8.0,Y=0.0,Z=5.0),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(2)=(AttachBone="passenger_r_5",DrivePos=(X=8.0,Y=0.0,Z=5.0),DriveAnim="VHalftrack_Rider1_idle")
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.75
    VehicleHudOccupantsX(3)=0.55
    VehicleHudOccupantsY(3)=0.75
    VehHitpoints(3)=(PointRadius=40.0,PointScale=1.0,PointBone="body",PointOffset=(X=-80.0,Y=0.0,Z=90.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    ExitPositions(2)=(X=-273.0,Y=-34.0,Z=25.0) // back left rider
    ExitPositions(3)=(X=-271.0,Y=23.0,Z=25.0)  // back right rider

    SupplyAttachmentClass=class'DHConstructionSupplyAttachment'
    SupplyAttachBone="Deco"
}
