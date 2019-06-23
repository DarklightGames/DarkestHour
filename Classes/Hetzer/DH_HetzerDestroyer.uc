class DH_HetzerDestroyer extends DHArmoredVehicle;

/**
Original hull & turret models (now heavily modified) by Sandor "Szeder" Sebastian for the 'Revenge of the Turul' RO mod (used with permission)
Various new vehicle skins by Groundwaffe, Scheisskopf & Jefaus
*/

// This embeds a small icon textures as part of this code package to avoid having to re-make & distribute the large hetzer texture file:
#exec OBJ LOAD FILE=..\DH_Hetzer--leave_in_cache\Textures\DH_HetzerIcons_tex.utx PACKAGE=DH_Hetzer--leave_in_cache

// Modified to create appropriate destroyed mesh skins
simulated event DestroyAppearance()
{
    local Combiner DestroyedSkin;

    DestroyedSkin = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
    DestroyedSkin.Material1 = Skins[0];
    DestroyedSkin.Material2 = Texture'DH_FX_Tex.Overlays.DestroyedVehicleOverlay2';
    DestroyedSkin.FallbackMaterial = Skins[0];
    DestroyedSkin.CombineOperation = CO_Multiply;
    DestroyedMeshSkins[0] = DestroyedSkin;

    DestroyedSkin = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
    DestroyedSkin.Material1 = Texture'axis_vehicles_tex.Treads.Stug3_treads';
    DestroyedSkin.Material2 = Texture'DH_FX_Tex.Overlays.DestroyedVehicleOverlay2';
    DestroyedSkin.FallbackMaterial = Skins[1];
    DestroyedSkin.CombineOperation = CO_Multiply;
    DestroyedMeshSkins[1] = DestroyedSkin;

    super.DestroyAppearance();
}

// TEMP fix for a bug in DH code where a bullet's pre-launch trace fails to damage the exposed gunsight optic on the roof
// Happens because bullet's damage is zero on this armoured vehicle, causing this function to exit before it gets to the point where it checks for hit on optic
// There is workaround functionality to handle this in bullet projectile classes, but not in pre-launch trace functionality, which just calls TakeDamage() with zero damage
// The workaround just checks for a zero damage bullet hit & runs an optic hit check for that, otherwise it calls the super as normal
// TODO: delete this override after the next DH release, when code has been fixed
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local class<ROWeaponDamageType> WepDamageType;
    local DHVehicleCannonPawn       CannonPawn;
    local Controller InstigatorController;
    local float      DamageModifier, TreadDamageMod, HullChanceModifier, TurretChanceModifier;
    local int        InstigatorTeam, i;
    local bool       bEngineStoppedProjectile, bAmmoDetonation;

    // Suicide/self-destruction
    if (DamageType == class'Suicided' || DamageType == class'ROSuicided')
    {
        super(Vehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, class'ROSuicided');

        ResetTakeDamageVariables();

        return;
    }

    // Quick fix for the vehicle giving itself impact damage
    if (InstigatedBy == self && DamageType != VehicleBurningDamType)
    {
        ResetTakeDamageVariables();

        return;
    }

    // Prevent griefer players from damaging own team's vehicles that haven't yet been entered, i.e. are sitting in a spawn area (not applicable in single player)
    if (!bDriverAlreadyEntered && Level.NetMode != NM_Standalone)
    {
        if (InstigatedBy != none)
        {
            InstigatorController = InstigatedBy.Controller;
        }

        if (InstigatorController == none && DamageType.default.bDelayedDamage)
        {
            InstigatorController = DelayedDamageInstigatorController;
        }

        if (InstigatorController != none)
        {
            InstigatorTeam = InstigatorController.GetTeamNum();

            if (GetTeamNum() != 255 && InstigatorTeam != 255 && GetTeamNum() == InstigatorTeam)
            {
                ResetTakeDamageVariables();

                return;
            }
        }
    }

    // Apply damage modifier from the DamageType, plus a little damage randomisation (but not randomised for fire damage as it messes up timings)
    WepDamageType = class<ROWeaponDamageType>(DamageType);

    if (WepDamageType != none)
    {
        if (bIsApc)
        {
            DamageModifier = WepDamageType.default.APCDamageModifier;
        }
        else
        {
            DamageModifier = WepDamageType.default.TankDamageModifier;
        }

        if (DamageType != VehicleBurningDamType)
        {
            DamageModifier *= RandRange(0.75, 1.08);
        }

        if (bHasTreads)
        {
            TreadDamageMod = WepDamageType.default.TreadDamageModifier;
        }
    }

    Damage *= DamageModifier;
/*
    // Exit if no damage // MOVED zero damage check further down
    if (Damage < 1)
    {
        ResetTakeDamageVariables();

        return;
    }
*/
    // Check RO VehHitpoints (engine, ammo)
    // Note driver hit check is deprecated as we use a new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    if (bProjectilePenetrated)
    {
        for (i = 0; i < VehHitpoints.Length; ++i)
        {
            if (IsPointShot(HitLocation, Momentum, 1.0, i))
            {
                if (bLogDebugPenetration)
                {
                    Log("We hit VehHitpoints[" $ i $ "]:" @ GetEnum(enum'EHitPointType', VehHitpoints[i].HitPointType));
                }

                // Engine hit
                if (VehHitpoints[i].HitPointType == HP_Engine)
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Hit vehicle engine");
                    }

                    DamageEngine(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
                    Damage *= 0.55; // reduce damage to vehicle itself if hit engine

                    // Shot from the rear that hits engine will stop shell from passing through to cabin, so don't check any more VehHitpoints
                    if (bRearHullPenetration)
                    {
                        bEngineStoppedProjectile = true;
                        break;
                    }
                }
                // Hit ammo store
                else if (VehHitpoints[i].HitPointType == HP_AmmoStore)
                {
                    // Random chance that ammo explodes & vehicle is destroyed
                    if ((bHEATPenetration && FRand() < 0.85) || (!bHEATPenetration && FRand() < AmmoIgnitionProbability))
                    {
                        if (bDebuggingText)
                        {
                            Level.Game.Broadcast(self, "Hit vehicle ammo store - exploded");
                        }

                        Damage *= Health;
                        bAmmoDetonation = true;
                        break;
                    }
                    // Even if ammo did not explode, increase the chance of a fire breaking out
                    else
                    {
                        if (bDebuggingText)
                        {
                            Level.Game.Broadcast(self, "Hit vehicle ammo store but did not explode");
                        }

                        HullFireChance = FMax(0.75, HullFireChance);
                        HullFireHEATChance = FMax(0.90, HullFireHEATChance);
                    }
                }
            }
        }
    }

    if (!bEngineStoppedProjectile && !bAmmoDetonation) // we can skip lots of checks if either has been flagged true
    {
        if ((bProjectilePenetrated || NewVehHitpoints.Length > 0) && Cannon != none)
        {
            CannonPawn = DHVehicleCannonPawn(Cannon.WeaponPawn);
        }

        // Check additional DH NewVehHitPoints
        for (i = 0; i < NewVehHitpoints.Length; ++i)
        {
            if (IsNewPointShot(HitLocation, Momentum, i))
            {
                if (bLogDebugPenetration)
                {
                    Log("We hit NewVehHitpoints[" $ i $ "]:" @ GetEnum(enum'ENewHitPointType', NewVehHitpoints[i].NewHitPointType));
                }

                // Hit periscope optics
                if (NewVehHitpoints[i].NewHitPointType == NHP_PeriscopeOptics)
                {
                    // does nothing at present - possibly add in future
                }
                else if (CannonPawn != none)
                {
                    // Hit exposed gunsight optics
                    if (NewVehHitpoints[i].NewHitPointType == NHP_GunOptics)
                    {
                        if (bDebuggingText)
                        {
                            Level.Game.Broadcast(self, "Hit gunsight optics");
                        }

                        CannonPawn.DamageCannonOverlay();
                    }
                    else if (bProjectilePenetrated)
                    {
                        // Hit turret ring or gun traverse mechanism
                        if (NewVehHitpoints[i].NewHitPointType == NHP_Traverse)
                        {
                            if (bDebuggingText)
                            {
                                Level.Game.Broadcast(self, "Hit gun/turret traverse");
                            }

                            CannonPawn.bTurretRingDamaged = true;
                        }
                        // Hit gun pivot mechanism
                        else if (NewVehHitpoints[i].NewHitPointType == NHP_GunPitch)
                        {
                            if (bDebuggingText)
                            {
                                Level.Game.Broadcast(self, "Hit gun pivot");
                            }

                            CannonPawn.bGunPivotDamaged = true;
                        }
                    }
                }
            }
        }

        // Random damage to crew or vehicle components, caused by shrapnel etc flying around inside the vehicle from penetration, regardless of where it hit
        if (bProjectilePenetrated)
        {
            if (Cannon != none)
            {
                // Although shrapnel etc can get everywhere, modify chance of random damage based on whether penetration was to hull or turret
                if (Cannon.bHasTurret)
                {
                    if (bTurretPenetration)
                    {
                        HullChanceModifier = 0.5;   // half usual chance of damage to things in the hull
                        TurretChanceModifier = 1.0;
                    }
                    else
                    {
                        HullChanceModifier = 1.0;
                        TurretChanceModifier = 0.5; // half usual chance of damage to things in the turret
                    }
                }
                else // normal chance of damage to everything in vehicles without a turret (e.g. casemate-style tank destroyers)
                {
                    HullChanceModifier = 1.0;
                    TurretChanceModifier = 1.0;
                }

                if (CannonPawn != none)
                {
                    // Random chance of shrapnel killing commander
                    if (CannonPawn != none && CannonPawn.Driver != none && FRand() < (float(Damage) / CommanderKillChance * TurretChanceModifier))
                    {
                        if (bDebuggingText)
                        {
                            Level.Game.Broadcast(self, "Commander killed by shrapnel");
                        }

                        CannonPawn.Driver.TakeDamage(150, InstigatedBy, Location, vect(0.0, 0.0, 0.0), DamageType);
                    }

                    // Random chance of shrapnel damaging gunsight optics
                    if (FRand() < (float(Damage) / OpticsDamageChance * TurretChanceModifier))
                    {
                        if (bDebuggingText)
                        {
                            Level.Game.Broadcast(self, "Gunsight optics destroyed by shrapnel");
                        }

                        CannonPawn.DamageCannonOverlay();
                    }

                    // Random chance of shrapnel damaging gun pivot mechanism
                    if (FRand() < (float(Damage) / GunDamageChance * TurretChanceModifier))
                    {
                        if (bDebuggingText)
                        {
                            Level.Game.Broadcast(self, "Gun pivot damaged by shrapnel");
                        }

                        CannonPawn.bGunPivotDamaged = true;
                    }

                    // Random chance of shrapnel damaging gun traverse mechanism
                    if (FRand() < (float(Damage) / TraverseDamageChance * TurretChanceModifier))
                    {
                        if (bDebuggingText)
                        {
                            Level.Game.Broadcast(self, "Gun/turret traverse damaged by shrapnel");
                        }

                        CannonPawn.bTurretRingDamaged = true;
                    }
                }
            }

            // Random chance of shrapnel detonating turret ammo & destroying the vehicle
            if (FRand() < (float(Damage) / TurretDetonationThreshold * TurretChanceModifier))
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Turret ammo detonated by shrapnel");
                }

                Damage *= Health;
            }
            else if (bTurretPenetration)
            {
                Damage *= 0.55; // reduce damage to vehicle itself from a turret hit, if the turret ammo didn't detonate

                // Random chance of shrapnel killing driver
                if (Driver != none && FRand() < (float(Damage) / DriverKillChance * HullChanceModifier))
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Driver killed by shrapnel");
                    }

                    Driver.TakeDamage(150, InstigatedBy, Location, vect(0.0, 0.0, 0.0), DamageType);
                }

                // Random chance of shrapnel killing hull machine gunner
                if (MGun != none && MGun.WeaponPawn != none && MGun.WeaponPawn.Driver != none && FRand() < (float(Damage) / GunnerKillChance * HullChanceModifier))
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Hull gunner killed by shrapnel");
                    }

                    MGun.WeaponPawn.Driver.TakeDamage(150, InstigatedBy, Location, vect(0.0, 0.0, 0.0), DamageType);
                }
            }
        }

        // Check if we hit & damaged either track
        if (bHasTreads && TreadDamageMod >= TreadDamageThreshold && !bTurretPenetration && !bRearHullPenetration)
        {
            CheckTreadDamage(HitLocation, Momentum);
        }
    }

    if (Damage > 0) // MOVED zero damage check down to here
    {
        // Call the Super from Vehicle (skip over others)
        super(Vehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);

        // Vehicle is still alive, so check for possibility of a fire breaking out
        if (Health > 0)
        {
            if (bProjectilePenetrated && !bEngineStoppedProjectile && !bOnFire)
            {
                // Random chance of penetration causing a hull fire
                if ((bHEATPenetration && FRand() < HullFireHEATChance) || (!bHEATPenetration && FRand() < HullFireChance))
                {
                    StartHullFire(InstigatedBy);
                }
                // If we didn't start a fire & this is the 1st time a projectile has penetrated, increase the chance of causing a hull fire for any future penetrations
                else if (bFirstPenetratingHit)
                {
                    bFirstPenetratingHit = false;
                    HullFireChance = FMax(0.75, HullFireChance);
                    HullFireHEATChance = FMax(0.90, HullFireHEATChance);
                }
            }

            // If an APC's health is very low, kill the engine & start a fire
            if (bIsApc && Health <= (HealthMax / 3) && EngineHealth > 0)
            {
                EngineHealth = 0;
                bEngineOff = true;
                StartEngineFire(InstigatedBy);
            }
        }
    }

    ResetTakeDamageVariables();
}

defaultproperties
{
     PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.PERISCOPE_overlay_German'
     FrontArmor(0)=(Thickness=6.000000,Slope=-40.000000,MaxRelativeHeight=9.900000,LocationName="lower")
     FrontArmor(1)=(Thickness=6.000000,Slope=60.000000,LocationName="upper")
     RightArmor(0)=(Thickness=2.000000,Slope=-15.000000,MaxRelativeHeight=13.000000,LocationName="lower")
     RightArmor(1)=(Thickness=2.000000,Slope=40.000000,LocationName="upper")
     LeftArmor(0)=(Thickness=2.000000,Slope=-15.000000,MaxRelativeHeight=13.000000,LocationName="lower")
     LeftArmor(1)=(Thickness=2.000000,Slope=40.000000,LocationName="upper")
     RearArmor(0)=(Thickness=2.000000,Slope=15.000000,MaxRelativeHeight=20.299999,LocationName="lower")
     RearArmor(1)=(Thickness=0.800000,Slope=70.000000,LocationName="upper")
     NewVehHitpoints(0)=(PointRadius=2.000000,PointBone="body",PointOffset=(X=32.000000,Y=-9.800000,Z=64.699997),NewHitPointType=NHP_GunOptics)
     NewVehHitpoints(1)=(PointRadius=15.000000,PointBone="Turret",PointOffset=(X=-12.000000),NewHitPointType=NHP_Traverse)
     NewVehHitpoints(2)=(PointRadius=15.000000,PointBone="Turret",PointOffset=(X=-12.000000),NewHitPointType=NHP_GunPitch)
     GunOpticsHitPointIndex=0
     FireAttachBone="body"
     FireEffectOffset=(X=103.000000,Y=-35.000000,Z=30.000000)
     PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-70.000000,Y=-25.000000,Z=110.000000),DriveRot=(Pitch=3850),DriveAnim="crouch_idle_binoc")
     PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-80.000000,Y=45.000000,Z=105.000000),DriveRot=(Pitch=4400,Yaw=-3100,Roll=-1700),DriveAnim="prone_idle_nade")
     FrontLeftAngle=340.000000
     FrontRightAngle=35.000000
     RearRightAngle=145.000000
     RearLeftAngle=201.000000
     MaxPitchSpeed=450.000000
     RumbleSound=Sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'
     TreadVelocityScale=55.000000
     LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L03'
     RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R03'
     LeftWheelBones(0)="Wheel_L_1"
     LeftWheelBones(1)="Wheel_L_2"
     LeftWheelBones(2)="Wheel_L_3"
     LeftWheelBones(3)="Wheel_L_4"
     LeftWheelBones(4)="Wheel_L_5"
     LeftWheelBones(5)="Wheel_L_6"
     LeftWheelBones(6)="Wheel_L_7"
     RightWheelBones(0)="Wheel_R_1"
     RightWheelBones(1)="Wheel_R_2"
     RightWheelBones(2)="Wheel_R_3"
     RightWheelBones(3)="Wheel_R_4"
     RightWheelBones(4)="Wheel_R_5"
     RightWheelBones(5)="Wheel_R_6"
     RightWheelBones(6)="Wheel_R_7"
     WheelRotationScale=20000.000000
     TreadHitMaxHeight=8.000000
     VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JPIVL48_turret_rot'
     VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JPIVL48_turret_look'
     VehicleHudTreadsPosX(0)=0.375000
     VehicleHudTreadsPosX(1)=0.605000
     VehicleHudTreadsPosY=0.465000
     VehicleHudTreadsScale=0.520000
     GearRatios(4)=0.720000
     TransRatio=0.100000
     LeftLeverBoneName="lever_L"
     LeftLeverAxis=AXIS_Y
     RightLeverBoneName="lever_R"
     RightLeverAxis=AXIS_Y
     ExhaustPipes(0)=(ExhaustPosition=(X=-140.000000,Y=-23.000000,Z=23.000000),ExhaustRotation=(Yaw=34000))
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Hetzer--leave_in_cache.DH_HetzerCannonPawn',WeaponBone="Turret_placement")
     PassengerWeapons(1)=(WeaponPawnClass=Class'DH_Hetzer--leave_in_cache.DH_HetzerMountedMGPawn',WeaponBone="Mg_placement")
     IdleSound=SoundGroup'Vehicle_Engines.Kv1s.KV1s_engine_loop'
     StartUpSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_start'
     ShutDownSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_stop'
     DestroyedVehicleMesh=StaticMesh'DH_Hetzer_stc_V3.Hetzer_destroyed'
     DamagedEffectOffset=(X=-60.000000,Y=25.000000)
     BeginningIdleAnim="periscope_idle_out"
     DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm_V3.Hetzer_body_int',TransitionUpAnim="periscope_out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,bDrawOverlays=True)
     DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm_V3.Hetzer_body_int',TransitionDownAnim="Periscope_in",ViewPitchUpLimit=3500,ViewPitchDownLimit=63000,ViewPositiveYawLimit=3500,ViewNegativeYawLimit=-3000)
     VehicleHudImage=Texture'DH_Hetzer--leave_in_cache.Hetzer_VehicleHudImage'
     VehicleHudOccupantsX(0)=0.440000
     VehicleHudOccupantsX(1)=0.540000
     VehicleHudOccupantsX(2)=0.440000
     VehicleHudOccupantsX(3)=0.450000
     VehicleHudOccupantsX(4)=0.560000
     VehicleHudOccupantsY(0)=0.330000
     VehicleHudOccupantsY(2)=0.500000
     VehicleHudOccupantsY(3)=0.610000
     VehicleHudOccupantsY(4)=0.610000
     VehicleHudEngineY=0.610000
     VehHitpoints(0)=(PointRadius=30.000000,PointOffset=(X=-60.000000))
     VehHitpoints(1)=(PointRadius=18.000000,PointScale=1.000000,PointBone="body",PointOffset=(Y=-28.299999,Z=-5.500000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(2)=(PointRadius=14.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=74.000000,Y=26.700001,Z=-9.400000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(3)=(PointRadius=14.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=29.000000,Y=26.700001,Z=-9.400000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(4)=(PointRadius=14.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=38.500000,Y=35.299999,Z=37.299999),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(5)=(PointRadius=14.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=1.000000,Y=35.299999,Z=37.299999),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
     DriverAttachmentBone=
     Begin Object Class=SVehicleWheel Name=LF_Steering
         bPoweredWheel=True
         SteerType=VST_Steered
         BoneName="steer_wheel_LF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=12.000000)
         WheelRadius=30.000000
     End Object
     Wheels(0)=SVehicleWheel'DH_Hetzer--leave_in_cache.DH_HetzerDestroyer.LF_Steering'

     Begin Object Class=SVehicleWheel Name=RF_Steering
         bPoweredWheel=True
         SteerType=VST_Steered
         BoneName="steer_wheel_RF"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=12.000000)
         WheelRadius=30.000000
     End Object
     Wheels(1)=SVehicleWheel'DH_Hetzer--leave_in_cache.DH_HetzerDestroyer.RF_Steering'

     Begin Object Class=SVehicleWheel Name=LR_Steering
         bPoweredWheel=True
         SteerType=VST_Inverted
         BoneName="steer_wheel_LR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-18.000000)
         WheelRadius=30.000000
     End Object
     Wheels(2)=SVehicleWheel'DH_Hetzer--leave_in_cache.DH_HetzerDestroyer.LR_Steering'

     Begin Object Class=SVehicleWheel Name=RR_Steering
         bPoweredWheel=True
         SteerType=VST_Inverted
         BoneName="steer_wheel_RR"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-18.000000)
         WheelRadius=30.000000
     End Object
     Wheels(3)=SVehicleWheel'DH_Hetzer--leave_in_cache.DH_HetzerDestroyer.RR_Steering'

     Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
         bPoweredWheel=True
         BoneName="drive_wheel_L"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-3.000000)
         WheelRadius=30.000000
     End Object
     Wheels(4)=SVehicleWheel'DH_Hetzer--leave_in_cache.DH_HetzerDestroyer.Left_Drive_Wheel'

     Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
         bPoweredWheel=True
         BoneName="drive_wheel_R"
         BoneRollAxis=AXIS_Y
         BoneOffset=(X=-3.000000)
         WheelRadius=30.000000
     End Object
     Wheels(5)=SVehicleWheel'DH_Hetzer--leave_in_cache.DH_HetzerDestroyer.Right_Drive_Wheel'

     VehicleMass=11.000000
     bDrawDriverInTP=False
     ExitPositions(0)=(X=90.000000,Y=-80.000000,Z=50.000000)
     ExitPositions(1)=(X=-10.000000,Y=50.000000,Z=120.000000)
     ExitPositions(2)=(X=-32.000000,Y=-10.000000,Z=120.000000)
     ExitPositions(3)=(X=-50.000000,Y=-80.000000,Z=50.000000)
     ExitPositions(4)=(X=-50.000000,Y=150.000000,Z=50.000000)
     ExitPositions(5)=(X=-160.000000,Y=20.000000,Z=50.000000)
     VehicleNameString="Jagdpanzer 38(t) 'Hetzer'"
     SpawnOverlay(0)=Texture'DH_Hetzer--leave_in_cache.Hetzer_SpawnOverlay'
     HealthMax=450.000000
     Health=450
     Mesh=SkeletalMesh'DH_Hetzer_anm_V3.Hetzer_body_ext'
     Skins(0)=Texture'DH_Hetzer_tex_V1.hetzer_body'
     Skins(1)=Texture'axis_vehicles_tex.Treads.Stug3_treads'
     Skins(2)=Texture'axis_vehicles_tex.Treads.Stug3_treads'
     Skins(3)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
     Skins(4)=Texture'DH_Hetzer_tex_V1.hetzer_int'
     Skins(5)=Texture'DH_Hetzer_tex_V1.Hetzer_driver_glass'
     Begin Object Class=KarmaParamsRBFull Name=KParams0
         KInertiaTensor(0)=1.000000
         KInertiaTensor(3)=3.000000
         KInertiaTensor(5)=3.000000
         KCOMOffset=(X=0.040000,Y=0.440000,Z=-1.000000)
         KLinearDamping=0.050000
         KAngularDamping=0.050000
         KStartEnabled=True
         bKNonSphericalInertia=True
         KMaxAngularSpeed=0.600000
         bHighDetailOnly=False
         bClientOnly=False
         bKDoubleTickRate=True
         bDestroyOnWorldPenetrate=True
         bDoSafetime=True
         KFriction=0.500000
         KImpactThreshold=700.000000
     End Object
     KParams=KarmaParamsRBFull'DH_Hetzer--leave_in_cache.DH_HetzerDestroyer.KParams0'

}
