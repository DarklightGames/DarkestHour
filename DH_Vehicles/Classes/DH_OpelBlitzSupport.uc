//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_OpelBlitzSupport extends DH_OpelBlitz;

defaultproperties
{
    ResupplyAttachmentClass=class'DH_OpelBlitzResupplyAttachment'
    ResupplyAttachBone="supply"
    ResupplyDecoAttachmentClass=class'DH_OpelBlitzDecoAttachment'
    ResupplyDecoAttachBone="Deco"
    PassengerPawns(1)=(AttachBone="passenger_l_3",DrivePos=(X=-1.0,Y=0.0,Z=-4.0),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(2)=(AttachBone="passenger_r_3",DrivePos=(X=-1.0,Y=0.0,Z=-4.0),DriveAnim="VHalftrack_Rider1_idle")
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.8
    VehicleHudOccupantsX(3)=0.55
    VehicleHudOccupantsY(3)=0.8
    VehHitpoints(2)=(PointRadius=40.0,PointScale=1.0,PointBone="body",PointOffset=(X=0.0,Y=50.0,Z=15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    ExitPositions(2)=(X=-255.0,Y=-30.0,Z=60.0)
    ExitPositions(3)=(X=-255.0,Y=30.0,Z=60.0)
}
