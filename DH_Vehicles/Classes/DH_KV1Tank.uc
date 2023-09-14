//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_KV1Tank extends DHDeprecated;

/*
defaultproperties
{
    // Vehicle properties
    VehicleNameString="KV-1"
    VehicleTeam=1
    VehicleMass=15.7
    ReinforcementCost=10

    // Hull mesh
    Mesh=SkeletalMesh'DH_KV_1and2_anm.KV_body_ext'
    Skins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.KV1_body_ext'
    Skins(1)=Texture'allies_vehicles_tex.Treads.kv1_treads'
    Skins(2)=Texture'allies_vehicles_tex.Treads.kv1_treads'

    // Collision
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_Soviet_vehicles_stc.Kv1s.kv1b_visor_coll',AttachBone="hatch_driver") // collision attachment for driver's armoured visor

    bUseHighDetailOverlayIndex=false

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_KV1CannonPawn',WeaponBone="Turret_Placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_KV1MGPawn',WeaponBone="MG_Placement")
    PassengerPawns(0)=(AttachBone="Body",DrivePos=(X=-133.0,Y=-42.0,Z=104.5),DriveRot=(Pitch=200),DriveAnim="crouch_idle_binoc") // kneeling, as can't sit in usual position due to fuel drums
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-195.0,Y=-35.0,Z=46.0),DriveRot=(Yaw=-32768),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(2)=(AttachBone="Body",DrivePos=(X=-195.0,Y=35.0,Z=46.0),DriveRot=(Yaw=-32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="Body",DrivePos=(X=-133.0,Y=31.0,Z=104.5),DriveRot=(Pitch=200),DriveAnim="crouch_idle_binoc")

    // Hull armor
    FrontArmor(0)=(Thickness=7.5,Slope=-30.0,MaxRelativeHeight=6.5,LocationName="lower")
    FrontArmor(1)=(Thickness=4.0,Slope=65.0,MaxRelativeHeight=26.0,LocationName="upper")
    FrontArmor(2)=(Thickness=7.5,Slope=30.0,LocationName="driver plate")
    RightArmor(0)=(Thickness=7.5)
    LeftArmor(0)=(Thickness=7.5)
    RearArmor(0)=(Thickness=7.0,Slope=-45.0,MaxRelativeHeight=-15.0,LocationName="lower (bottom of curved)")
    RearArmor(1)=(Thickness=7.0,MaxRelativeHeight=8.0,LocationName="lower (flattest curved)") // represents flattest, rear facing part of rounded lower hull
    RearArmor(2)=(Thickness=7.0,Slope=45.0,MaxRelativeHeight=23.5,LocationName="lower (top of curved)")
    RearArmor(3)=(Thickness=6.0,Slope=50.0,MaxRelativeHeight=38.0,LocationName="upper")
    RearArmor(4)=(Thickness=3.0,Slope=85.0,LocationName="upper slope")

    FrontLeftAngle=335.0
    FrontRightAngle=25.0
    RearRightAngle=155.0
    RearLeftAngle=205.0

    // Movement
    MaxCriticalSpeed=577.0 // ~34 kph
    GearRatios(4)=0.7
    TransRatio=0.072

	EngineRestartFailChance=0.2 //unreliability of early design +  weight

    // Damage
	// pros: diesel fuel; 5 men crew
	// cons: fuel tanks in crew compartment;
    Health=565
    HealthMax=565.0
	EngineHealth=240   //reliability problems due to early design ("child problems") and high weight

    PlayerFireDamagePer2Secs=12.0 // reduced from 15 for all diesels
    FireDetonationChance=0.045  //reduced from 0.07 for all diesels
    DisintegrationHealth=-1200.0 //diesel

    VehHitpoints(0)=(PointRadius=40.0,PointOffset=(X=-100.0,Y=0.0,Z=0.0)) // engine // TODO: check position of all hit points
    VehHitpoints(1)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(X=13.0,Y=-25.0,Z=-5.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(X=13.0,Y=25.0,Z=-5.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=26.0
    DamagedEffectOffset=(X=-90.0,Y=0.0,Z=40.0)
    DestroyedVehicleMesh=StaticMesh'DH_soviet_vehicles_stc.Kv1.KV1_Dest'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesSOV_tex.Destroyed.KV1_body_dest'  //needs non-E variant texture
    DestroyedMeshSkins(1)=Combiner'DH_VehiclesSOV_tex.Destroyed.kv1_treads_dest'
    DestroyedMeshSkins(2)=Combiner'DH_VehiclesSOV_tex.Destroyed.kv1_treads_dest'

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.KV-1S_body'
    VehicleHudTurret=TexRotator'InterfaceArt_tex.Tank_Hud.kv1s_turret_rot'
    VehicleHudTurretLook=TexRotator'InterfaceArt_tex.Tank_Hud.kv1s_turret_look'
    VehicleHudTreadsPosX(0)=0.37
    VehicleHudTreadsPosX(1)=0.64
    VehicleHudTreadsScale=0.73
    VehicleHudOccupantsX(0)=0.5
    VehicleHudOccupantsY(0)=0.25
    VehicleHudOccupantsY(1)=0.41
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.3
    VehicleHudOccupantsX(3)=0.44
    VehicleHudOccupantsY(3)=0.72
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.84
    VehicleHudOccupantsX(5)=0.56
    VehicleHudOccupantsY(5)=0.84
    VehicleHudOccupantsX(6)=0.57
    VehicleHudOccupantsY(6)=0.72
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.KV1'
}
*/