//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTankCannon extends ROTankCannon
    abstract;

#exec OBJ LOAD FILE=..\sounds\DH_Vehicle_Reloads.uax

// Variables for up to three ammo types, plus new MG tracer
var   int               MainAmmoChargeExtra[3];
var() int               InitialTertiaryAmmo;
var() class<Projectile> TertiaryProjectileClass;

// Shot dispersion can be customized by round type
var() float SecondarySpread;
var() bool  bUsesSecondarySpread;
var() float TertiarySpread;
var() bool  bUsesTertiarySpread;

//Manual turret stuff
var   float ManualRotationsPerSecond;
var   float PoweredRotationsPerSecond;
var   bool  bManualTurret;

// Stuff for fire effects - Ch!cKeN
var() name                        FireAttachBone;
var() vector                      FireEffectOffset;
var   class<VehicleDamagedEffect> FireEffectClass;
var   VehicleDamagedEffect        TurretHatchFireEffect;
var   bool                        bOnFire; // set by Treadcraft base to notify when to start fire effects
var   float                       BurnTime;

// Armor Penetration stuff
var   bool  bIsAssaultGun; //used to defeat the Stug/JP bug
//var bool  bWasHEATRound;         // Matt: removed as not used in this class (gets set in vehicle class)
var   bool  bHasAddedSideArmor;
//var bool  bProjectilePenetrated; // Matt: removed as not used in this class (gets set in vehicle class)
//var bool  bWasShatterProne;      // Matt: deprecated
var   bool  bRoundShattered;

var   float FrontArmorFactor;
var   float RightArmorFactor;
var   float LeftArmorFactor;
var   float RearArmorFactor;

var   float FrontArmorSlope;
var   float RightArmorSlope;
var   float LeftArmorSlope;
var   float RearArmorSlope;

//var float DHArmorSlopeTable[16]; // Matt: deprecated

var() float FrontLeftAngle, FrontRightAngle, RearRightAngle, RearLeftAngle;

var   float MinCommanderHitHeight; // Matt: minimum height above which a projectile must have hit commander's collision box (hit location offset, relative to mesh origin)

// Turret collision static mesh (Matt: new col mesh actor allows us to use a col static mesh with a VehicleWeapon, like a tank turret)
var class<DH_VehicleWeaponCollisionMeshActor> CollisionMeshActorClass; // specify a valid class in default props & the col static mesh will automatically be used
var DH_VehicleWeaponCollisionMeshActor        CollisionMeshActor;

//Debugging help
var   bool  bDrawPenetration;
var   bool  bDebuggingText;
var   bool  bPenetrationText;
var   bool  bLogPenetration;
var   bool  bDriverDebugging;

// Debugging and calibration stuff
var   config bool bGunFireDebug;
var() config bool bGunsightSettingMode;

replication
{
    reliable if (bNetDirty && bNetOwner && Role == ROLE_Authority)
        MainAmmoChargeExtra;

    reliable if (bNetDirty && Role == ROLE_Authority)
        bOnFire;

    reliable if (Role == ROLE_Authority)
        bRoundShattered; // Matt: removed bProjectilePenetrated as deprecated

    reliable if ((bNetInitial || bNetDirty) && Role == ROLE_Authority)
        bManualTurret;
}
//==============================================================================

// Matt: modified to handle new collision static mesh actor, if one has been specified
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (CollisionMeshActorClass != none)
    {
        CollisionMeshActor = Spawn(CollisionMeshActorClass, self); // vital that this VehicleWeapon owns the col mesh actor

        if (CollisionMeshActor != none)
        {
            // Remove all collision from this VehicleWeapon class (instead let col mesh actor handle collision detection)
            SetCollision(false, false); // bCollideActors & bBlockActors both false
            bBlockNonZeroExtentTraces = false;
            bBlockZeroExtentTraces = false;

            // Attach col mesh actor to our yaw bone, so the col mesh will rotate with the turret
            CollisionMeshActor.bHardAttach = true;
            AttachToBone(CollisionMeshActor, YawBone);

            // The col mesh actor will be positioned on the yaw bone, so we want to reposition it to align with the turret
            CollisionMeshActor.SetRelativeLocation(Location - GetBoneCoords(YawBone).Origin);
        }
    }
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    if (bOnFire && TurretHatchFireEffect == none)
    {
        // Lets randomise the fire start times to desync them with the driver and engine ones
        if (Level.TimeSeconds - BurnTime > 0.2)
        {
            if (FRand() < 0.1)
            {
                TurretHatchFireEffect = Spawn(FireEffectClass);
                AttachToBone(TurretHatchFireEffect, FireAttachBone);
                TurretHatchFireEffect.SetRelativeLocation(FireEffectOffset);
                TurretHatchFireEffect.UpdateDamagedEffect(true, 0, false, false);
            }
            BurnTime = Level.TimeSeconds;
        }
    }

    if (DH_ROTankCannonPawn(Owner) != none)
    {
        if (bManualTurret)
        {
            RotationsPerSecond = ManualRotationsPerSecond;
            DH_ROTankCannonPawn(Owner).RotateSound = DH_ROTankCannonPawn(Owner).ManualRotateSound;
            DH_ROTankCannonPawn(Owner).PitchSound = DH_ROTankCannonPawn(Owner).ManualPitchSound;
            DH_ROTankCannonPawn(Owner).RotateAndPitchSound = DH_ROTankCannonPawn(Owner).ManualRotateAndPitchSound;
            DH_ROTankCannonPawn(Owner).MinRotateThreshold = DH_ROTankCannonPawn(Owner).ManualMinRotateThreshold;
            DH_ROTankCannonPawn(Owner).MaxRotateThreshold = DH_ROTankCannonPawn(Owner).ManualMaxRotateThreshold;
        }
        else
        {
            RotationsPerSecond = PoweredRotationsPerSecond;
            DH_ROTankCannonPawn(Owner).RotateSound = DH_ROTankCannonPawn(Owner).PoweredRotateSound;
            DH_ROTankCannonPawn(Owner).PitchSound = DH_ROTankCannonPawn(Owner).PoweredPitchSound;
            DH_ROTankCannonPawn(Owner).RotateAndPitchSound = DH_ROTankCannonPawn(Owner).PoweredRotateAndPitchSound;
            DH_ROTankCannonPawn(Owner).MinRotateThreshold = DH_ROTankCannonPawn(Owner).PoweredMinRotateThreshold;
            DH_ROTankCannonPawn(Owner).MaxRotateThreshold = DH_ROTankCannonPawn(Owner).PoweredMaxRotateThreshold;
        }
    }
}

// Matt: new generic function to handle 'should penetrate' calcs for any shell type
// Replaces DHShouldPenetrateAPC, DHShouldPenetrateAPDS, DHShouldPenetrateHVAP, DHShouldPenetrateHVAPLarge, DHShouldPenetrateHEAT (also DO's DHShouldPenetrateAP & DHShouldPenetrateAPBC)
simulated function bool DHShouldPenetrate(class<DH_ROAntiVehicleProjectile> P, vector HitLocation, vector HitRotation, float PenetrationNumber)
{
    local float   WeaponRotationDegrees, HitAngleDegrees, Side, InAngle, InAngleDegrees;
    local vector  LocDir, HitDir, X, Y, Z;
    local rotator AimRot;

    WeaponRotationDegrees = (CurrentAim.Yaw / 65536.0 * 360.0);

    if (bIsAssaultGun)
    {
        DH_ROTreadCraft(Base).bAssaultWeaponHit = true;

        return false;
    }

    // Figure out which side we hit
    LocDir = vector(Rotation);
    LocDir.Z = 0.0;
    HitDir =  Hitlocation - Location;
    HitDir.Z = 0.0;
    HitAngleDegrees = (Acos(Normal(LocDir) dot Normal(HitDir))) * 57.2957795131; // final multiplier converts the angle into degrees from radians
    GetAxes(Rotation, X, Y, Z);
    Side = Y dot HitDir;

    if (Side < 0.0)
    {
        HitAngleDegrees = 360.0 - HitAngleDegrees;
    }

    HitAngleDegrees -= WeaponRotationDegrees;

    if (HitAngleDegrees < 0.0)
    {
        HitAngleDegrees += 360.0;
        X = X >> CurrentAim;
        Y = Y >> CurrentAim;
    }

    // Penetration debugging
    if (bLogPenetration)
    {
        Log("Hit angle =" @ HitAngleDegrees @ "degrees, Weapon rotation =" @ WeaponRotationDegrees @ "degrees, Side =" @ Side);
    }

    if (bDebuggingText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Hit angle:" @ HitAngleDegrees @ "degrees");
    }

    if (bDrawPenetration)
    {
        ClearStayingDebugLines();
        AimRot = Rotation;
        AimRot.Yaw += (FrontLeftAngle / 360.0) * 65536.0;
        DrawStayingDebugLine(Location, Location + 2000.0 * vector(AimRot), 0, 255, 0);

        AimRot = Rotation;
        AimRot.Yaw += (FrontRightAngle / 360.0) * 65536.0;
        DrawStayingDebugLine(Location, Location + 2000.0 * vector(AimRot), 255, 255, 0);

        AimRot = Rotation;
        AimRot.Yaw += (RearRightAngle / 360.0) * 65536.0;
        DrawStayingDebugLine(Location, Location + 2000.0 * vector(AimRot), 0, 0, 255);

        AimRot = Rotation;
        AimRot.Yaw += (RearLeftAngle / 360.0) * 65536.0;
        DrawStayingDebugLine(Location, Location + 2000.0 * vector(AimRot), 0, 0, 0);
    }

    // Frontal hit
    if (HitAngleDegrees >= FrontLeftAngle || HitAngleDegrees < FrontRightAngle)
    {
        InAngle = Acos(Normal(-HitRotation) dot Normal(X));
        InAngleDegrees = InAngle * 57.2957795131;

        // Penetration debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(X), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DH_DebugTracer', self, , HitLocation, rotator(HitRotation));
            Log("We hit the front of the vehicle");
        }

        // Fix hit detection bug
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug: switching from front to REAR turret hit: base armor =" @ RearArmorFactor * 10.0 $ "mm");
            }

            // Run a pre-check
            if (RearArmorFactor > PenetrationNumber)
            {
                return false;
            }

            return CheckPenetration(P, RearArmorFactor, GetCompoundAngle(InAngle, RearArmorSlope), PenetrationNumber);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Front turret hit, base armor = "$FrontArmorFactor * 10.0 $ "mm");
        }

        // Run a pre-check
        if (FrontArmorFactor > PenetrationNumber)
        {
            return false;
        }

        return CheckPenetration(P, FrontArmorFactor, GetCompoundAngle(InAngle, FrontArmorSlope), PenetrationNumber);

    }

    // Right side hit
    else if (HitAngleDegrees >= FrontRightAngle && HitAngleDegrees < RearRightAngle)
    {
        // Don't penetrate with HEAT if there is added side armor
        if (bHasAddedSideArmor && P.default.RoundType == RT_HEAT) // Matt: using RoundType (was P.default.ShellImpactDamage != none && P.default.ShellImpactDamage.default.bArmorStops)
        {
            return false;
        }

        InAngle = Acos(Normal(-HitRotation) dot Normal(Y));
        InAngleDegrees = InAngle * 57.2957795131;

        // Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-Y), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DH_DebugTracer', self, , HitLocation, rotator(HitRotation));
            Log("We hit the right side of the vehicle");
        }

        // Fix hit detection bug
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug: switching from right to LEFT turret hit: base armor =" @ LeftArmorFactor * 10.0 $ "mm");
            }

            // Run a pre-check
            if (LeftArmorFactor > PenetrationNumber)
            {
                return false;
            }

            return CheckPenetration(P, LeftArmorFactor, GetCompoundAngle(InAngle, LeftArmorSlope), PenetrationNumber);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Right turret hit: base armor =" @ RightArmorFactor * 10.0 $ "mm");;
        }

        // Run a pre-check
        if (RightArmorFactor > PenetrationNumber)
        {
            return false;
        }

        return CheckPenetration(P, RightArmorFactor, GetCompoundAngle(InAngle, RightArmorSlope), PenetrationNumber);
    }

    // Rear hit
    else if (HitAngleDegrees >= RearRightAngle && HitAngleDegrees < RearLeftAngle)
    {
        InAngle = Acos(Normal(-HitRotation) dot Normal(-X));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-X), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DH_DebugTracer', self, , HitLocation, rotator(HitRotation));
            Log ("We hit the back of the vehicle");
        }

        // Fix hit detection bug
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug: switching from rear to FRONT turret hit: base armor =" @ FrontArmorFactor * 10.0 $ "mm");;
            }

            // Run a pre-check
            if (FrontArmorFactor > PenetrationNumber)
            {
                return false;
            }

            return CheckPenetration(P, FrontArmorFactor, GetCompoundAngle(InAngle, FrontArmorSlope), PenetrationNumber);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Rear turret hit: base armor =" @ RearArmorFactor * 10.0 $ "mm");;
        }

        // Run a pre-check
        if (RearArmorFactor > PenetrationNumber)
        {
            return false;
        }

        return CheckPenetration(P, RearArmorFactor, GetCompoundAngle(InAngle, RearArmorSlope), PenetrationNumber);
    }

    // Left side hit
    else if (HitAngleDegrees >= RearLeftAngle && HitAngleDegrees < FrontLeftAngle)
    {
        // Don't penetrate with HEAT if there is added side armor
        if (bHasAddedSideArmor && P.default.RoundType == RT_HEAT) // Matt: using RoundType (was P.default.ShellImpactDamage != none && P.default.ShellImpactDamage.default.bArmorStops)
        {
            return false;
        }

        InAngle = Acos(Normal(-HitRotation) dot Normal(-Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(Y), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DH_DebugTracer', self, , HitLocation, rotator(HitRotation));
            Log("We hit the left side of the vehicle");
        }

        // Fix hit detection bug
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug: switching from left to RIGHT turret hit: base armor =" @ RightArmorFactor * 10.0 $ "mm");;
            }

            // Run a pre-check
            if (RightArmorFactor > PenetrationNumber)
            {
                return false;
            }

            return CheckPenetration(P, RightArmorFactor, GetCompoundAngle(InAngle, RightArmorSlope), PenetrationNumber);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Left turret hit: base armor =" @ LeftArmorFactor * 10.0 $ "mm");;
        }

        // Run a pre-check
        if (LeftArmorFactor > PenetrationNumber)
        {
            return false;
        }

        return CheckPenetration(P, LeftArmorFactor, GetCompoundAngle(InAngle, LeftArmorSlope), PenetrationNumber);
    }

    // Should never happen !
    else
    {
       Log ("?!? We shoulda hit something !!!!");
       Level.Game.Broadcast(self, "?!? We shoulda hit something !!!!");

       return false;
    }
}

// Matt: new generic function to handle penetration calcs for any shell type
// Replaces PenetrationAPC, PenetrationAPDS, PenetrationHVAP, PenetrationHVAPLarge & PenetrationHEAT (also Darkest Orchestra's PenetrationAP & PenetrationAPBC)
simulated function bool CheckPenetration(class<DH_ROAntiVehicleProjectile> P, float ArmorFactor, float CompoundAngle, float PenetrationNumber)
{
    local float CompoundAngleDegrees, OverMatchFactor, SlopeMultiplier, EffectiveArmor, PenetrationRatio;

    // Convert angle back to degrees
    CompoundAngleDegrees = CompoundAngle * 57.2957795131;

    if (CompoundAngleDegrees > 90.0)
    {
        CompoundAngleDegrees = 180.0 - CompoundAngleDegrees;
    }

    // Calculate the SlopeMultiplier & EffectiveArmor, to give us the PenetrationRatio
    OverMatchFactor = ArmorFactor / P.default.ShellDiameter;
    SlopeMultiplier = GetArmorSlopeMultiplier(P, CompoundAngleDegrees, OverMatchFactor);
    EffectiveArmor = ArmorFactor * SlopeMultiplier;
    PenetrationRatio = PenetrationNumber / EffectiveArmor;

    // Penetration debugging
    if (Role == ROLE_Authority)
    {
        if (bDebuggingText)
        {
            Level.Game.Broadcast(self, "CompoundAngle:" @ CompoundAngleDegrees @ "SlopeMultiplier:" @ SlopeMultiplier);
        }

        if (bPenetrationText)
        {
            Level.Game.Broadcast(self, "Effective armor:" @ EffectiveArmor * 10.0 $ "mm" @ "Shot penetration:" @ PenetrationNumber * 10.0 $ "mm");
        }
    }

    // Now we have the necessary factors, check whether the round penetrates the armor
    if (PenetrationRatio >= 1.0)
    {
        // Check if the round should shatter on the armor
        if (P.default.bShatterProne)
        {
            CheckIfRoundShatters(P, PenetrationRatio, OverMatchFactor);
        }

        if (!bRoundShattered)
        {
            DH_ROTreadCraft(Base).bProjectilePenetrated = true;
            DH_ROTreadCraft(Base).bWasTurretHit = true;
            DH_ROTreadCraft(Base).bWasHEATRound = (P.default.RoundType == RT_HEAT); // Matt: would be much better to flag bIsHeatRound in the DamageType, but would need new DH_WeaponDamageType class

            return true;
        }
    }

    DH_ROTreadCraft(Base).bProjectilePenetrated = false;
    DH_ROTreadCraft(Base).bWasTurretHit = false;

    return false;
}

// Returns the compound hit angle
simulated function float GetCompoundAngle(float AOI, float ArmorSlopeDegrees)
{
    local float ArmorSlope, CompoundAngle;

//  AOI = Abs(AOI * 0.01745329252); // Matt: we now pass AOI to this function in radians, to save unnecessary processing to & from degrees
    ArmorSlope = Abs(ArmorSlopeDegrees * 0.01745329252); // convert the angle degrees to radians
    CompoundAngle = Acos(Cos(ArmorSlope) * Cos(AOI));

    return CompoundAngle;
}

// Matt: new generic function to work with generic DHShouldPenetrate & CheckPenetration functions
simulated function float GetArmorSlopeMultiplier(class<DH_ROAntiVehicleProjectile> P, float CompoundAngleDegrees, optional float OverMatchFactor)
{
    local float CompoundExp, CompoundAngleFixed;
    local float RoundedDownAngleDegrees, ExtraAngleDegrees, BaseSlopeMultiplier, NextSlopeMultiplier, SlopeMultiplierGap;

    if (P.default.RoundType == RT_HVAP)
    {
        if (P.default.ShellDiameter >= 9.0) // HVAP rounds of at least 90mm shell diameter, e.g. Jackson's 90mm cannon (instead of using separate RoundType RT_HVAPLarge)
        {
            if (CompoundAngleDegrees <= 30.0)
            {
               CompoundExp = CompoundAngleDegrees ** 1.75;

               return 2.71828 ** (CompoundExp * 0.000662);
            }
            else
            {
               CompoundExp = CompoundAngleDegrees ** 2.2;

               return 0.9043 * (2.71828 ** (CompoundExp * 0.0001987));
            }
        }
        else // smaller HVAP rounds
        {
            if (CompoundAngleDegrees <= 25.0)
            {
               CompoundExp = CompoundAngleDegrees ** 2.2;

               return 2.71828 ** (CompoundExp * 0.0001727);
            }
            else
            {
               CompoundExp = CompoundAngleDegrees ** 1.5;

               return 0.7277 * (2.71828 ** (CompoundExp * 0.003787));
            }
        }
    }
    else if (P.default.RoundType == RT_APDS)
    {
        CompoundExp = CompoundAngleDegrees ** 2.6;

        return 2.71828 ** (CompoundExp * 0.00003011);
    }
    else if (P.default.RoundType == RT_HEAT)
    {
        CompoundAngleFixed = Abs(CompoundAngleDegrees * 0.01745329252); // convert angle back to radians

        return 1.0 / Cos(CompoundAngleFixed);
    }
    else // should mean RoundType is RT_APC, RT_HE or RT_Smoke, but treating this as a catch-all default (will also handle DO's AP & APBC shells)
    {
        if (CompoundAngleDegrees < 10.0)
        {
            return CompoundAngleDegrees / 10.0 * ArmorSlopeTable(P, 10.0, OverMatchFactor);
        }
        else
        {
            RoundedDownAngleDegrees = Float(Int(CompoundAngleDegrees / 5.0)) * 5.0; // to nearest 5 degrees, rounded down
            ExtraAngleDegrees = CompoundAngleDegrees - RoundedDownAngleDegrees;
            BaseSlopeMultiplier = ArmorSlopeTable(P, RoundedDownAngleDegrees, OverMatchFactor);
            NextSlopeMultiplier = ArmorSlopeTable(P, RoundedDownAngleDegrees + 5.0, OverMatchFactor);
            SlopeMultiplierGap = NextSlopeMultiplier - BaseSlopeMultiplier;

            return BaseSlopeMultiplier + (ExtraAngleDegrees / 5.0 * SlopeMultiplierGap);
        }
    }

    return 1.0; // fail-safe neutral return value
}

// Matt: new generic function to work with new GetArmorSlopeMultiplier for APC shells (also handles Darkest Orchestra's AP & APBC shells)
simulated function float ArmorSlopeTable(class<DH_ROAntiVehicleProjectile> P, float CompoundAngleDegrees, float OverMatchFactor)
{
    // after Bird & Livingston:
    if (P.default.RoundType == RT_AP) // from Darkest Orchestra
    {
        if      (CompoundAngleDegrees <= 10.0)  return 0.98  * (OverMatchFactor ** 0.0637); // at 10 degrees
        else if (CompoundAngleDegrees <= 15.0)  return 1.00  * (OverMatchFactor ** 0.0969);
        else if (CompoundAngleDegrees <= 20.0)  return 1.04  * (OverMatchFactor ** 0.13561);
        else if (CompoundAngleDegrees <= 25.0)  return 1.11  * (OverMatchFactor ** 0.16164);
        else if (CompoundAngleDegrees <= 30.0)  return 1.22  * (OverMatchFactor ** 0.19702);
        else if (CompoundAngleDegrees <= 35.0)  return 1.38  * (OverMatchFactor ** 0.22546);
        else if (CompoundAngleDegrees <= 40.0)  return 1.63  * (OverMatchFactor ** 0.26313);
        else if (CompoundAngleDegrees <= 45.0)  return 2.00  * (OverMatchFactor ** 0.34717);
        else if (CompoundAngleDegrees <= 50.0)  return 2.64  * (OverMatchFactor ** 0.57353);
        else if (CompoundAngleDegrees <= 55.0)  return 3.23  * (OverMatchFactor ** 0.69075);
        else if (CompoundAngleDegrees <= 60.0)  return 4.07  * (OverMatchFactor ** 0.81826);
        else if (CompoundAngleDegrees <= 65.0)  return 6.27  * (OverMatchFactor ** 0.91920);
        else if (CompoundAngleDegrees <= 70.0)  return 8.65  * (OverMatchFactor ** 1.00539);
        else if (CompoundAngleDegrees <= 75.0)  return 13.75 * (OverMatchFactor ** 1.074);
        else if (CompoundAngleDegrees <= 80.0)  return 21.87 * (OverMatchFactor ** 1.17973);
        else                                    return 34.49 * (OverMatchFactor ** 1.28631); // at 85 degrees
    }
    else if (P.default.RoundType == RT_APBC) // from Darkest Orchestra
    {
        if      (CompoundAngleDegrees <= 10.0)  return 1.04 * (OverMatchFactor ** 0.01555); // at 10 degrees
        else if (CompoundAngleDegrees <= 15.0)  return 1.06 * (OverMatchFactor ** 0.02315);
        else if (CompoundAngleDegrees <= 20.0)  return 1.08 * (OverMatchFactor ** 0.03448);
        else if (CompoundAngleDegrees <= 25.0)  return 1.11 * (OverMatchFactor ** 0.05134);
        else if (CompoundAngleDegrees <= 30.0)  return 1.16 * (OverMatchFactor ** 0.07710);
        else if (CompoundAngleDegrees <= 35.0)  return 1.22 * (OverMatchFactor ** 0.11384);
        else if (CompoundAngleDegrees <= 40.0)  return 1.31 * (OverMatchFactor ** 0.16952);
        else if (CompoundAngleDegrees <= 45.0)  return 1.44 * (OverMatchFactor ** 0.24604);
        else if (CompoundAngleDegrees <= 50.0)  return 1.68 * (OverMatchFactor ** 0.37910);
        else if (CompoundAngleDegrees <= 55.0)  return 2.11 * (OverMatchFactor ** 0.56444);
        else if (CompoundAngleDegrees <= 60.0)  return 3.50 * (OverMatchFactor ** 1.07411);
        else if (CompoundAngleDegrees <= 65.0)  return 5.34 * (OverMatchFactor ** 1.46188);
        else if (CompoundAngleDegrees <= 70.0)  return 9.48 * (OverMatchFactor ** 1.81520);
        else if (CompoundAngleDegrees <= 75.0)  return 20.22 * (OverMatchFactor ** 2.19155);
        else if (CompoundAngleDegrees <= 80.0)  return 56.20 * (OverMatchFactor ** 2.56210);
        else                                    return 221.3 * (OverMatchFactor ** 2.93265); // at 85 degrees
    }
    else // should mean RoundType is RT_APC (also covers APCBC) or RT_HE, but treating this as a catch-all default
    {
        if      (CompoundAngleDegrees <= 10.0)  return 1.01  * (OverMatchFactor ** 0.0225); // at 10 degrees
        else if (CompoundAngleDegrees <= 15.0)  return 1.03  * (OverMatchFactor ** 0.0327);
        else if (CompoundAngleDegrees <= 20.0)  return 1.10  * (OverMatchFactor ** 0.0454);
        else if (CompoundAngleDegrees <= 25.0)  return 1.17  * (OverMatchFactor ** 0.0549);
        else if (CompoundAngleDegrees <= 30.0)  return 1.27  * (OverMatchFactor ** 0.0655);
        else if (CompoundAngleDegrees <= 35.0)  return 1.39  * (OverMatchFactor ** 0.0993);
        else if (CompoundAngleDegrees <= 40.0)  return 1.54  * (OverMatchFactor ** 0.1388);
        else if (CompoundAngleDegrees <= 45.0)  return 1.72  * (OverMatchFactor ** 0.1655);
        else if (CompoundAngleDegrees <= 50.0)  return 1.94  * (OverMatchFactor ** 0.2035);
        else if (CompoundAngleDegrees <= 55.0)  return 2.12  * (OverMatchFactor ** 0.2427);
        else if (CompoundAngleDegrees <= 60.0)  return 2.56  * (OverMatchFactor ** 0.2450);
        else if (CompoundAngleDegrees <= 65.0)  return 3.20  * (OverMatchFactor ** 0.3354);
        else if (CompoundAngleDegrees <= 70.0)  return 3.98  * (OverMatchFactor ** 0.3478);
        else if (CompoundAngleDegrees <= 75.0)  return 5.17  * (OverMatchFactor ** 0.3831);
        else if (CompoundAngleDegrees <= 80.0)  return 8.09  * (OverMatchFactor ** 0.4131);
        else                                    return 11.32 * (OverMatchFactor ** 0.4550); // at 85 degrees
    }

    return 1.0; // fail-safe neutral return value
}

// Matt: new generic function to work with new CheckPenetration function - checks if the round should shatter, based on the 'shatter gap' for different round types
simulated function CheckIfRoundShatters(class<DH_ROAntiVehicleProjectile> P, float PenetrationRatio, optional float OverMatchFactor)
{
    local bool bShattered;

    if (P.default.RoundType == RT_HVAP)
    {
        // Matt: TEST - maybe this should include 88mm APCR, which is same as HVAP?
        if (P.default.ShellDiameter >= 9.0) // HVAP rounds of at least 90mm shell diameter, e.g. Jackson's 90mm cannon (instead of using separate RoundType RT_HVAPLarge)
        {
            if (PenetrationRatio >= 1.10 && PenetrationRatio <= 1.27)
            {
                bShattered = true;
            }
        }
        else // smaller HVAP rounds
        {
            if (PenetrationRatio >= 1.10 && PenetrationRatio <= 1.34)
            {
                bShattered = true;
            }
        }
    }
    else if (P.default.RoundType == RT_APDS)
    {
        if (PenetrationRatio >= 1.06 && PenetrationRatio <= 1.20)
        {
            bShattered = true;
        }
    }
    else if (P.default.RoundType == RT_HEAT) // no chance of shatter for HEAT round
    {
    }
    else // should mean RoundType is RT_APC, RT_HE or RT_Smoke, but treating this as a catch-all default (will also handle DO's AP & APBC shells)
    {
        if (OverMatchFactor > 0.8 && PenetrationRatio >= 1.06 && PenetrationRatio <= 1.19)
        {
            bShattered = true;
        }
    }

    bRoundShattered = bShattered; // now we set the replicated variable
}

function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
    }

    // Matt: shell's ProcessTouch now calls TD on VehicleWeapon instead of VehicleBase, but for tank cannon this is counted as hit on vehicle so we call TD on that
    else if (VehicleWeaponPawn(Owner) != none && VehicleWeaponPawn(Owner).VehicleBase != none)
    {
        if (DamageType.default.bDelayedDamage && InstigatedBy != none) // added bDelayedDamage as otherwise this isn't relevant
        {
            VehicleWeaponPawn(Owner).VehicleBase.SetDelayedDamageInstigatorController(InstigatedBy.Controller);
        }

        VehicleWeaponPawn(Owner).VehicleBase.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
    }

    // Matt: removed as shell & bullet's ProcessTouch now call TakeDamage directly on Driver if he was hit
//  if (HitDriver(Hitlocation, Momentum))
//  {
//      ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
//  }

    // Reset everything // Matt: removed these variables as none are used in this class (they get set in the vehicle class)
//  bWasHEATRound = false;
//  bProjectilePenetrated = false;
//  bWasShatterProne = false;

    bRoundShattered = false;
}

// Returns the name of the various round types as well as a 0-based int
// specifying which type is the active one
simulated function int GetRoundsDescription(out array<string> Descriptions)
{
    local int i;

    Descriptions.Length = 0;
    
    for (i = 0; i < ProjectileDescriptions.length; i++)
    {
        Descriptions[i] = ProjectileDescriptions[i];
    }

    if (ProjectileClass == PrimaryProjectileClass)
    {
        return 0;
    }
    else if (ProjectileClass == SecondaryProjectileClass)
    {
        return 1;
    }
    else if (ProjectileClass == TertiaryProjectileClass)
    {
        return 2;
    }
    else
    {
        return 3;
    }
}

// Returns a 0-based int specifying which round type is the pending round
simulated function int GetPendingRoundIndex()
{
    if (PendingProjectileClass != none)
    {
        if (PendingProjectileClass == PrimaryProjectileClass)
        {
            return 0;
        }
        else if (PendingProjectileClass == SecondaryProjectileClass)
        {
            return 1;
        }
        else if (PendingProjectileClass == TertiaryProjectileClass)
        {
            return 2;
        }
        else
        {
            return 3;
        }
    }
    else
    {
        if (ProjectileClass == PrimaryProjectileClass)
        {
            return 0;
        }
        else if (ProjectileClass == SecondaryProjectileClass)
        {
            return 1;
        }
        else if (ProjectileClass == TertiaryProjectileClass)
        {
            return 2;
        }
        else
        {
            return 3;
        }
    }
}

function ToggleRoundType()
{
    if (PendingProjectileClass == PrimaryProjectileClass || PendingProjectileClass == none)
    {
        if (!HasAmmo(1) && !HasAmmo(2))
        {
            return;
        }

        if (HasAmmo(1))
        {
            PendingProjectileClass = SecondaryProjectileClass;
        }
        else if (HasAmmo(2))
        {
            PendingProjectileClass = TertiaryProjectileClass;
        }
    }
    else if (PendingProjectileClass == SecondaryProjectileClass)
    {
        if (!HasAmmo(0) && !HasAmmo(2))
        {
            return;
        }

        if (HasAmmo(2))
        {
            PendingProjectileClass = TertiaryProjectileClass;
        }
        else if (HasAmmo(0))
        {
            PendingProjectileClass = PrimaryProjectileClass;
        }
    }
    else if (PendingProjectileClass == TertiaryProjectileClass)
    {
        if (!HasAmmo(0) && !HasAmmo(1))
        {
            return;
        }

        if (HasAmmo(0))
        {
            PendingProjectileClass = PrimaryProjectileClass;
        }
        else if (HasAmmo(1))
        {
            PendingProjectileClass = SecondaryProjectileClass;
        }
    }
}

event bool AttemptFire(Controller C, bool bAltFire)
{
    local float s;

    if (Role != ROLE_Authority || bForceCenterAim)
    {
        return false;
    }

    s = FRand();

    if ((!bAltFire && CannonReloadState == CR_ReadyToFire && bClientCanFireCannon) || (bAltFire && FireCountdown <= 0.0))
    {
        CalcWeaponFire(bAltFire);

        if (bCorrectAim)
        {
            WeaponFireRotation = AdjustAim(bAltFire);
        }

        if (bAltFire)
        {
            if (AltFireSpread > 0.0)
            {
                WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * AltFireSpread);
            }
        }
        else if (SecondarySpread > 0.0 && bUsesSecondarySpread && ProjectileClass == SecondaryProjectileClass)
        {
            if (s < 0.6)
            {
                WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * SecondarySpread);
                WeaponFireRotation += rot(1,6,0); // correction to the aim point and to center the spread pattern
            }
            else
            {
                WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * 0.0015);
                WeaponFireRotation += rot(1,6,0); //correction to the aim point and to center the spread pattern
            }
        }
        else if (TertiarySpread > 0 && bUsesTertiarySpread && ProjectileClass == TertiaryProjectileClass)
        {
              WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * TertiarySpread);
              WeaponFireRotation += rot(1,6,0); //correction to the aim point and to center the spread pattern
        }
        else if (Spread > 0.0)
        {
              WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * Spread);
              WeaponFireRotation += rot(1,6,0); //correction to the aim point and to center the spread pattern
        }

        DualFireOffset *= -1.0;

        Instigator.MakeNoise(1.0);

        if (bAltFire)
        {
            if (!ConsumeAmmo(3))
            {
                VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                HandleReload();

                return false;
            }

            FireCountdown = AltFireInterval;
            AltFire(C);

            if (AltAmmoCharge < 1)
            {
                HandleReload();
            }
        }
        else
        {
            if (bMultipleRoundTypes)
            {
                if (ProjectileClass == PrimaryProjectileClass)
                {
                    if (!ConsumeAmmo(0))
                    {
                        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);

                        return false;
                    }
                    else if (!HasAmmo(0))
                    {
                        if (HasAmmo(1))
                        {
                            PendingProjectileClass = SecondaryProjectileClass;
                        }
                        else if (HasAmmo(2))
                        {
                            PendingProjectileClass = TertiaryProjectileClass;
                        }
                    }
                }
                else if (ProjectileClass == SecondaryProjectileClass)
                {
                    if (!ConsumeAmmo(1))
                    {
                        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);

                        return false;
                    }
                    else if (!HasAmmo(1))
                    {
                        if (HasAmmo(0))
                        {
                            PendingProjectileClass = PrimaryProjectileClass;
                        }
                        else if (HasAmmo(2))
                        {
                            PendingProjectileClass = TertiaryProjectileClass;
                        }
                    }
                }
                else if (ProjectileClass == TertiaryProjectileClass)
                {
                    if (!ConsumeAmmo(2))
                    {
                        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);

                        return false;
                    }
                    else if (!HasAmmo(2))
                    {
                        if (HasAmmo(0))
                        {
                            PendingProjectileClass = PrimaryProjectileClass;
                        }
                        else if (HasAmmo(1))
                        {
                            PendingProjectileClass = SecondaryProjectileClass;
                        }
                    }
                }
            }
            else if (!ConsumeAmmo(0))
            {
                VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);

                return false;
            }

            if (Instigator != none && ROPlayer(Instigator.Controller) != none && ROPlayer(Instigator.Controller).bManualTankShellReloading)
            {
                CannonReloadState = CR_Waiting;
            }
            else
            {
                CannonReloadState = CR_Empty;
                SetTimer(0.01, false);
            }

            bClientCanFireCannon = false;

            Fire(C);
        }

        AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

        return true;
    }

    return false;
}

function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile        P;
    local VehicleWeaponPawn WeaponPawn;
    local vector            StartLocation, HitLocation, HitNormal, Extent;
    local rotator           FireRot;

    FireRot = WeaponFireRotation;

    // used only for Human players. Lets cannons with non centered aim points have a different aiming location
    if (Instigator != none && Instigator.IsHumanControlled())
    {
        FireRot.Pitch += AddedPitch;
    }

    if (!bAltFire)
    {
        FireRot.Pitch += ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    }

    if (bCannonShellDebugging)
    {
        Log("GetPitchForRange for" @ CurrentRangeIndex @ "=" @ ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]));
    }

    if (bDoOffsetTrace)
    {
        Extent = ProjClass.default.CollisionRadius * vect(1.0,1.0,0.0);
        Extent.Z = ProjClass.default.CollisionHeight;

        WeaponPawn = VehicleWeaponPawn(Owner);

        if (WeaponPawn != none && WeaponPawn.VehicleBase != none)
        {
            if (!WeaponPawn.VehicleBase.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, 
                WeaponFireLocation + vector(WeaponFireRotation) * (WeaponPawn.VehicleBase.CollisionRadius * 1.5), Extent))
            {
                StartLocation = HitLocation;
            }
            else
            {
                StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
            }
        }
        else
        {
            if (!Owner.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (Owner.CollisionRadius * 1.5), Extent))
            {
                StartLocation = HitLocation;
            }
            else
            {
                StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
            }
        }
    }
    else
    {
        StartLocation = WeaponFireLocation;
    }

    if (bCannonShellDebugging)
    {
        Trace(TraceHitLocation, HitNormal, WeaponFireLocation + 65355.0 * vector(WeaponFireRotation), WeaponFireLocation, false);
    }

    P = spawn(ProjClass, none, , StartLocation, FireRot); 

    // Swap to the next round type after firing
    if (PendingProjectileClass != none && ProjClass == ProjectileClass && ProjectileClass != PendingProjectileClass)
    {
        ProjectileClass = PendingProjectileClass;
    }

    if (P != none)
    {
        if (bInheritVelocity)
        {
            P.Velocity = Instigator.Velocity;
        }

        FlashMuzzleFlash(bAltFire);

        // Play firing noise
        if (bAltFire)
        {
            if (bAmbientAltFireSound)
            {
                AmbientSound = AltFireSoundClass;
                SoundVolume = AltFireSoundVolume;
                SoundRadius = AltFireSoundRadius;
                AmbientSoundScaling = AltFireSoundScaling;
            }
            else
            {
                PlayOwnedSound(AltFireSoundClass, SLOT_None, FireSoundVolume / 255.0, , AltFireSoundRadius, , false);
            }
        }
        else
        {
            if (bAmbientFireSound)
            {
                AmbientSound = FireSoundClass;
            }
            else
            {
                PlayOwnedSound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume / 255.0, , FireSoundRadius, , false);
            }
        }
    }

    return P;
}

function CeaseFire(Controller C, bool bWasAltFire)
{
    super(ROVehicleWeapon).CeaseFire(C, bWasAltFire);

    if (bWasAltFire && !HasAmmo(3))
    {
        HandleReload();
    }
}

simulated function bool HasAmmo(int Mode)
{
    switch (Mode)
    {
        case 0:
            return (MainAmmoChargeExtra[0] > 0);
            break;
        case 1:
            return (MainAmmoChargeExtra[1] > 0);
            break;
        case 2:
            return (MainAmmoChargeExtra[2] > 0);
            break;
        case 3:
            return (AltAmmoCharge > 0);
            break;
        default:
            return false;
    }

    return false;
}

simulated function bool ReadyToFire(bool bAltFire)
{
    local int Mode;

    if (bAltFire)
    {
        Mode = 3;
    }
    else if (ProjectileClass == PrimaryProjectileClass)
    {
        Mode = 0;
    }
    else if (ProjectileClass == SecondaryProjectileClass)
    {
        Mode = 1;
    }
    else if (ProjectileClass == TertiaryProjectileClass)
    {
        Mode = 2;
    }

    if (HasAmmo(Mode))
    {
        return true;
    }

    return false;
}

simulated function int PrimaryAmmoCount()
{
    if (bMultipleRoundTypes)
    {
        if (ProjectileClass == PrimaryProjectileClass)
        {
            return MainAmmoChargeExtra[0];
        }
        else if (ProjectileClass == SecondaryProjectileClass)
        {
            return MainAmmoChargeExtra[1];
        }
        else if (ProjectileClass == TertiaryProjectileClass)
        {
            return MainAmmoChargeExtra[2];
        }
    }
    else
    {
        return MainAmmoChargeExtra[0];
    }
}

simulated function bool ConsumeAmmo(int Mode)
{
    if (!HasAmmo(Mode))
        return false;

    switch (Mode)
    {
        case 0:
            MainAmmoChargeExtra[0]--;
            return true;
        case 1:
            MainAmmoChargeExtra[1]--;
            return true;
        case 2:
            MainAmmoChargeExtra[2]--;
            return true;
        case 3:
            AltAmmoCharge--;
            return true;
        default:
            return false;
    }

    return false;
}

// Modified to use DH's MainAmmoChargeExtra array
function bool GiveInitialAmmo()
{
    if (MainAmmoChargeExtra[0] != InitialPrimaryAmmo || MainAmmoChargeExtra[1] != InitialSecondaryAmmo || MainAmmoChargeExtra[2] != InitialTertiaryAmmo || 
        AltAmmoCharge != InitialAltAmmo || NumAltMags != default.NumAltMags)
    {
        MainAmmoChargeExtra[0] = InitialPrimaryAmmo;
        MainAmmoChargeExtra[1] = InitialSecondaryAmmo;
        MainAmmoChargeExtra[2] = InitialTertiaryAmmo;
        AltAmmoCharge = InitialAltAmmo;
        NumAltMags = default.NumAltMags;

        return true;
    }

    return false;
}

// Matt: modified so only sets timer if the new reload state needs it
simulated function ClientSetReloadState(ECannonReloadState NewState)
{
    CannonReloadState = NewState;

    if (CannonReloadState != CR_Waiting  && CannonReloadState != CR_ReadyToFire)
    {
        SetTimer(0.01, false);
    }
}

simulated function Timer()
{
    if (VehicleWeaponPawn(Owner) == none || VehicleWeaponPawn(Owner).Controller == none)
    {
        SetTimer(0.05, true);
    }
    else if (CannonReloadState == CR_Empty)
    {
        if (Role == ROLE_Authority)
        {
            PlayOwnedSound(ReloadSoundOne, SLOT_Misc, FireSoundVolume / 255.0, , 150, , false);
        }
        else
        {
            PlaySound(ReloadSoundOne, SLOT_Misc, FireSoundVolume / 255.0, , 150, , false);
        }

        CannonReloadState = CR_ReloadedPart1;
        GetSoundDuration(ReloadSoundThree) + GetSoundDuration(ReloadSoundFour);
        SetTimer(GetSoundDuration(ReloadSoundOne), false);
    }
    else if (CannonReloadState == CR_ReloadedPart1)
    {
        if (Role == ROLE_Authority)
        {
            PlayOwnedSound(ReloadSoundTwo, SLOT_Misc, FireSoundVolume / 255.0, , 150, , false);
        }
        else
        {
            PlaySound(ReloadSoundTwo, SLOT_Misc, FireSoundVolume / 255.0, , 150, , false);
        }

        CannonReloadState = CR_ReloadedPart2;
        GetSoundDuration(ReloadSoundFour);
        SetTimer(GetSoundDuration(ReloadSoundTwo), false);
    }
    else if (CannonReloadState == CR_ReloadedPart2)
    {
        if (Role == ROLE_Authority)
        {
            PlayOwnedSound(ReloadSoundThree, SLOT_Misc, FireSoundVolume / 255.0, , 150, , false);
        }
        else
        {
            PlaySound(ReloadSoundThree, SLOT_Misc, FireSoundVolume / 255.0, , 150, , false);
        }

        CannonReloadState = CR_ReloadedPart3;
        SetTimer(GetSoundDuration(ReloadSoundThree), false);
    }
    else if (CannonReloadState == CR_ReloadedPart3)
    {
        if (Role == ROLE_Authority)
        {
            PlayOwnedSound(ReloadSoundFour, SLOT_Misc, FireSoundVolume / 255.0, , 150, , false);
        }
        else
        {
            PlaySound(ReloadSoundFour, SLOT_Misc, FireSoundVolume / 255.0, , 150, , false);
        }

        CannonReloadState = CR_ReloadedPart4;
        SetTimer(GetSoundDuration(ReloadSoundFour), false);
   }
   else if (CannonReloadState == CR_ReloadedPart4)
   {
        if (Role == ROLE_Authority)
        {
            bClientCanFireCannon = true;
        }

        CannonReloadState = CR_ReadyToFire;
        SetTimer(0.0, false);
   }
}

//overriden: to remove shake from co-ax MG's
simulated function ShakeView(bool bWasAltFire)
{
    local PlayerController P;

    if (Instigator == none)
    {
        return;
    }

    P = PlayerController(Instigator.Controller);

    if (P != none)
    {
        if (bWasAltFire)
        {
            //P.WeaponShakeView(AltShakeRotMag, AltShakeRotRate, AltShakeRotTime, AltShakeOffsetMag, AltShakeOffsetRate, AltShakeOffsetTime);
        }
        else
        {
            P.WeaponShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime, ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);
        }
    }
}

/*
// Matt: deprecated function, along with MaxDriverHitAngle variable - is now handled using new MinCommanderHitHeight variable in re-worked HitDriverArea function
// Returns true if the bullet hits below the angle that would hit the commander
simulated function bool BelowDriverAngle(vector Loc, vector Ray)
{
    local float  InAngle;
    local vector X, Y, Z, HitDir, HeadLoc;
    local coords C;

    GetAxes(Rotation, X, Y, Z);

    C = GetBoneCoords(VehHitpoints[0].PointBone);
    HeadLoc = C.Origin + (VehHitpoints[0].PointHeight * VehHitpoints[0].PointScale * C.XAxis);
    HeadLoc = HeadLoc + (VehHitpoints[0].PointOffset >> Rotator(C.Xaxis));

    HitDir = Loc - HeadLoc;

    InAngle= Acos(Normal(HitDir) dot Normal(C.ZAxis));

    if (bDriverDebugging)
    {
        Log("InAngle =" @ InAngle @ "MaxDriverHitAngle =" @ MaxDriverHitAngle);

        if (Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "InAngle =" @ InAngle @ "MaxDriverHitAngle =" @ MaxDriverHitAngle);
        }

        ClearStayingDebugLines();
        DrawStayingDebugLine(HeadLoc, (HeadLoc + (30.0 * Normal(C.ZAxis))), 255, 0, 0); // SLOW! Use for debugging only!
        DrawStayingDebugLine(Loc, (Loc + (45.0 * Normal(Ray))), 0, 255, 0);             // SLOW! Use for debugging only!
    }

    if (InAngle > MaxDriverHitAngle)
    {
        if (bDriverDebugging && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Hit angle is too low to hit commander");
        }

        return true;
    }

    return false;
}
*/
// Matt: slightly different concept to work more accurately & simply with projectiles: think of this function as asking "did we hit the commander's collision box?"
simulated function bool HitDriverArea(vector HitLocation, vector Momentum)
{
    local vector HitOffset;

    HitOffset = (Hitlocation - Location) << Rotation; // hit offset in local space (after actor's 3D rotation applied)

    // We must have hit the commander's collision box (HitOffset.Z is how far the HitLocation is above the mesh origin)
    if (HitOffset.Z >= MinCommanderHitHeight)
    {
        if (bDriverDebugging)
        {
            Log("HitOffset.Z =" @ HitOffset.Z @ "MinCommanderHitHeight =" @ MinCommanderHitHeight @ " Assume hit commander's collision box");

            if (Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "HitOffset.Z =" @ HitOffset.Z @ "MinCommanderHitHeight =" @ MinCommanderHitHeight @ " Assume hit commander's collision box");
            }
        }

        return true;
    }
    // We can't have hit the commander so we must have hit the turret (or some other collision box)
    else
    {
        if (bDriverDebugging)
        {
            Log("HitOffset.Z =" @ HitOffset.Z @ "MinCommanderHitHeight =" @ MinCommanderHitHeight @ " Must have missed commander's collision box");

            if (Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "HitOffset.Z =" @ HitOffset.Z @ "MinCommanderHitHeight =" @ MinCommanderHitHeight @ " Must have missed commander's collision box");
            }
        }

        return false;
    }
}

// Matt: slightly different concept to work more accurately & simply with projectiles
// Think of this function as asking "is there an exposed commander there & did we actually hit him, not just his collision box?"
simulated function bool HitDriver(vector Hitlocation, vector Momentum)
{
    local ROVehicleWeaponPawn PwningPawn;

    PwningPawn = ROVehicleWeaponPawn(Owner);

    // Commander is present & is not buttoned up & we hit commander's collision box & hit one of the hit points representing his head or torso
    if (PwningPawn != none && PwningPawn.Driver != none && !PwningPawn.DriverPositions[PwningPawn.DriverPositionIndex].bExposed && 
        HitDriverArea(HitLocation, Momentum) && IsPointShot(HitLocation, Normal(Momentum), 1.0, 0) || IsPointShot(HitLocation, Normal(Momentum), 1.0, 1))
    {
        return true;
    }

    return false;
}

// Matt: had to re-state as a simulated function so can be called on net client by HitDriver/HitDriverArea, giving correct clientside effects for projectile hits
simulated function bool IsPointShot(vector Loc, vector Ray, float AdditionalScale, int Index)
{
    local  coords  C;
    local  vector  HeadLoc, B, M, Diff;
    local  float   t, DotMM, Distance;

    if (VehHitpoints.Length <= Index || VehHitpoints[Index].PointBone == '') // added check against array length to avoid "out of bounds" errors
    {
        return false;
    }

    C = GetBoneCoords(VehHitpoints[Index].PointBone);
    HeadLoc = C.Origin + (VehHitpoints[Index].PointHeight * VehHitpoints[Index].PointScale * AdditionalScale * C.XAxis);
    HeadLoc = HeadLoc + (VehHitpoints[Index].PointOffset >> rotator(C.Xaxis));

    // Express snipe trace line in terms of B + tM
    B = Loc;
    M = Ray * 150.0;

    // Find point-line squared distance
    Diff = HeadLoc - B;
    t = M dot Diff;

    if (t > 0.0)
    {
        DotMM = M dot M;

        if (t < DotMM)
        {
            t = t / DotMM;
            Diff = Diff - (t * M);
        }
        else
        {
            t = 1.0;
            Diff -= M;
        }
    }
    else
    {
        t = 0.0;
    }

    Distance = Sqrt(Diff Dot Diff);

    return (Distance < (VehHitpoints[Index].PointRadius * VehHitpoints[Index].PointScale * AdditionalScale));
}

simulated function UpdatePrecacheStaticMeshes()
{
    if (TertiaryProjectileClass != none)
    {
        Level.AddPrecacheStaticMesh(TertiaryProjectileClass.default.StaticMesh);
    }

    super.UpdatePrecacheStaticMeshes();
}

// ARMORED BEASTS CODE: Functions extended for easy tuning of gunsights in PRACTICE mode
// bGunsightSettingMode has to be enabled and gun not loaded, then the range control buttons change sight adjustment up and down
function IncrementRange()
{
    if (bGunsightSettingMode && CannonReloadState != CR_ReadyToFire)
    {
        IncreaseAddedPitch();
        GiveInitialAmmo();
    }
    else
    {
        super.IncrementRange();
    }
}

function DecrementRange()
{
    if (bGunsightSettingMode && CannonReloadState != CR_ReadyToFire)
    {
        DecreaseAddedPitch();
        GiveInitialAmmo();
    }
    else
    {
        super.DecrementRange();
    }
}

// Functions making AddedPitch (gunsight correction) adjustment and display:
function IncreaseAddedPitch()
{
    local int MechanicalRangesValue, Correction;

    AddedPitch += 2;

    MechanicalRangesValue = ProjectileClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    Correction = AddedPitch - default.AddedPitch;

    if (Instigator != none && ROPlayer(Instigator.Controller) != none)
    {
        ROPlayer(Instigator.Controller).ClientMessage("Sight old value =" @ MechanicalRangesValue @ "       new value =" @ MechanicalRangesValue+Correction @ "       correction =" @ Correction);
    }
}

function DecreaseAddedPitch()
{
    local int MechanicalRangesValue, Correction;

    AddedPitch -= 2;

    MechanicalRangesValue = ProjectileClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    Correction = AddedPitch - default.AddedPitch;

    if (Instigator != none && ROPlayer(Instigator.Controller) != none)
    {
        ROPlayer(Instigator.Controller).ClientMessage("Sight old value =" @ MechanicalRangesValue @ "       new value =" @ MechanicalRangesValue+Correction @ "       correction =" @ Correction);
    }
}

simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (TurretHatchFireEffect != none)
    {
        TurretHatchFireEffect.Destroy();
    }
}

simulated function int LimitYaw(int yaw)
{
    local DH_ROTankCannonPawn P;

    P = DH_ROTankCannonPawn(Owner);

    if (!bLimitYaw)
    {
        return yaw;
    }

    if (P != none)
    {
        if (P.DriverPositionIndex >= P.PeriscopePositionIndex)
        {
            return yaw;
        }

        return Clamp(yaw, P.DriverPositions[P.DriverPositionIndex].ViewNegativeYawLimit, P.DriverPositions[P.DriverPositionIndex].ViewPositiveYawLimit);
    }

    return Clamp(yaw, MaxNegativeYaw, MaxPositiveYaw);
}

function bool ResupplyAmmo()
{
    local bool bDidResupply;

    if (MainAmmoChargeExtra[0] < InitialPrimaryAmmo)
    {
        ++MainAmmoChargeExtra[0];

        bDidResupply = true;
    }

    if (MainAmmoChargeExtra[1] < InitialSecondaryAmmo)
    {
        ++MainAmmoChargeExtra[1];

        bDidResupply = true;
    }

    if (MainAmmoChargeExtra[2] < InitialTertiaryAmmo)
    {
        ++MainAmmoChargeExtra[2];

        bDidResupply = true;
    }

    if (NumAltMags < default.NumAltMags)
    {
        ++NumAltMags;

        bDidResupply = true;
    }

    return bDidResupply;
}

simulated function Destroyed() // Matt: added
{
    if (CollisionMeshActor != none)
    {
        CollisionMeshActor.Destroy();
    }

    super.Destroyed();
}

defaultproperties
{
    bUsesSecondarySpread=true
    bUsesTertiarySpread=true
    ManualRotationsPerSecond=0.011111
    PoweredRotationsPerSecond=0.050000
    FireAttachBone="com_player"
    FireEffectOffset=(Z=-20.000000)
    FireEffectClass=class'ROEngine.VehicleDamagedEffect'
    bManualTurret=true
    CannonReloadState=CR_Waiting
    AltFireSpread=0.002000
}
