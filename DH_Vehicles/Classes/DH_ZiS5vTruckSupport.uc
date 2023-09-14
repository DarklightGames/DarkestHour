//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ZiS5vTruckSupport extends DH_ZiS5vTruck;

defaultproperties
{
    VehicleNameString="ZiS-5V (Logistics)"
    Skins(2)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha' // hides rear bench seats to make room for the supply attachment static mesh, which fills the truck bed
    DestroyedMeshSkins(1)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
    PassengerPawns(1)=(AttachBone="Passenger_supply1",DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(2)=(AttachBone="Passenger_supply2",DriveAnim="VHalftrack_Rider5_idle")
    ExitPositions(2)=(X=-210.0,Y=13.0,Z=70.0)  // back left rider
    ExitPositions(3)=(X=-150.0,Y=105.0,Z=70.0) // back right rider
    VehicleHudOccupantsX(2)=0.52
    VehicleHudOccupantsY(2)=0.84
    VehicleHudOccupantsX(3)=0.62
    VehicleHudOccupantsY(3)=0.77
    SupplyAttachmentClass=class'DHConstructionSupplyAttachment_Vehicle'
    SupplyAttachmentBone="Construction_supply"
    ResupplyAttachmentBone="Ammo_resupply"
    VehHitpoints(5)=(PointRadius=40.0,PointScale=1.0,PointBone="Ammo_resupply",DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DisintegrationHealth=-1000.0 // disintegrates if health falls below this threshold, due to explosive ammo carried
    DisintegrationEffectClass=class'ROEffects.ROVehicleObliteratedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleObliteratedEmitter_simple'
    bRequiresDriverLicense=true
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.zis5v_logistics'
    FriendlyResetDistance=15000.0  // 250 meters
}
