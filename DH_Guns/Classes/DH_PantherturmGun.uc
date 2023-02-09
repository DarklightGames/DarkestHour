//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PantherturmGun extends DHATGun;

defaultproperties
{
    VehicleNameString="Pantherturm"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_PantherturmCannonPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_Panther_anm.Panther_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo2'
	Skins(1)=Texture'axis_vehicles_tex.Treads.PantherG_treads'
    Skins(2)=Texture'axis_vehicles_tex.Treads.PantherG_treads'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed2'
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.panther_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panther_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panther_turret_look'
    ExitPositions(0)=(X=-91.0,Y=20.0,Z=110.0)
	VehicleMass=14.0
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Vehicle_Armored'

    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.06) // relatively, COM is high, gun is light & it's base is not so stable, so any karma impulse can make it rock - this lowers COM to approx ground level
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.0
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=50.0
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Guns.DH_PantherturmGun.KParams0'

	Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=32.0,Y=-15.0,Z=-1.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=32.0,Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-14.0,Y=-15.0,Z=-1.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-14.0,Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-15.0,Z=-1.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.Right_Drive_Wheel'

	// Damage
    HealthMax=1600.0
    Health=1600
    EngineHealth=0
	VehHitpoints(0)=(PointRadius=30.0,PointBone="Turret",DamageMultiplier=50.0,HitPointType=HP_AmmoStore)
    DamagedEffectClass=none
    DestructionEffectClass=class'DH_Effects.DHVehicleDestroyedEmitter'
    DisintegrationEffectClass=class'DH_Effects.DHVehicleObliteratedEmitter'
    DestructionLinearMomentum=(Min=0.0,Max=0.0)
    DestructionAngularMomentum=(Min=0.0,Max=0.0)
    bCanCrash=false
}
