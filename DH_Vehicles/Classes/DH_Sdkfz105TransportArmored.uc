//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Sdkfz105TransportArmored extends DH_Sdkfz105Transport;

// Modified to unhide collision mesh attachment used for armoured shielding on the front, to match its camo to the vehicle, & to set it to resist bullets
simulated function SpawnVehicleAttachments()
{
    super(DHVehicle).SpawnVehicleAttachments(); // skip over the Super in DH_Sdkfz105Transport as this variant doesn't have the windscreen attachment

    if (DHCollisionMeshActor(CollisionAttachments[0].Actor) != none)
    {
        DHCollisionMeshActor(CollisionAttachments[0].Actor).bIsBulletProof = true;

        if (Level.NetMode != NM_DedicatedServer)
        {
            CollisionAttachments[0].Actor.Skins[0] = Skins[1]; // match camo to vehicle's 'cabin' texture
            CollisionAttachments[0].Actor.SetDrawType(DT_StaticMesh);
        }
    }
}

defaultproperties
{
    EngineDamageFromGrenadeModifier=0.05
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_German_vehicles_stc4.Sdkfz10_5.SdKfz10_5_armor',AttachBone="Body") // collision attachment for armour shielding to the front
    VehicleAttachments(0)=(StaticMesh=none) // remove windscreen attachment
    DriverPositions(0)=(TransitionUpAnim="Driver_out")  // to lean forward for a better view through vision slot in armoured shield
    DriverPositions(1)=(TransitionDownAnim="Driver_in") // for reference: camera moves X+25, Z-1

}
