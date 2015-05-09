//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHArmoredWheeledVehicle extends DHTreadCraft
    abstract;

enum ECarHitPointType
{
    CHP_Normal,
    CHP_RFTire,
    CHP_RRTire,
    CHP_LFTire,
    CHP_LRTire,
    CHP_Petrol,
};

var     ECarHitPointType    CarHitPointType;

struct CarHitpoint
{
    var float               PointRadius;       // squared radius of the head of the pawn that is vulnerable to headshots
    var float               PointHeight;       // distance from base of neck to center of head - used for headshot calculation
    var float               PointScale;
    var name                PointBone;         // bone to reference in offset
    var vector              PointOffset;       // amount to offset the hitpoint from the bone
    var bool                bPenetrationPoint; // this is a penetration point, open hatch, etc
    var float               DamageMultiplier;  // amount to scale damage to the vehicle if this point is hit
    var ECarHitPointType    CarHitPointType;   // what type of hit point this is
};

var     array<CarHitpoint>  CarVehHitpoints;   // an array of possible small points that can be hit (index zero is always the driver)

// Empty functions that we don't need for armored cars:
simulated function UpdateMovementSound();
simulated function SetupTreads();
simulated function DestroyTreads();
function DamageTrack(bool bLeftTrack);
simulated function SetDamagedTracks();
exec function DamTrack(string Track);

// Modified to ignore damaged treads & to disable if vehicle takes major damage, as well as if engine is dead
// This should give time for troops to bail out & escape before vehicle blows
simulated function bool IsDisabled()
{
    return (EngineHealth <= 0 || (Health >= 0 && Health <= HealthMax / 3));
}

simulated function Tick(float DeltaTime)
{
    local float MySpeed;

    // Only need these effects client side
    if (Level.NetMode != NM_DedicatedServer)
    {
        // VSize() is very CPU intensive
        MySpeed = VSize(Velocity);

        if (MySpeed >= MaxCriticalSpeed && Controller != none)
        {
            if (Controller.IsA('ROPlayer'))
            {
                ROPlayer(Controller).aForward = -32768; //forces player to pull back on throttle
            }
        }
    }

    super(ROWheeledVehicle).Tick(DeltaTime);

    if (bEngineOff)
    {
        Velocity = vect(0.0, 0.0, 0.0);
        Throttle = 0;
        ThrottleAmount = 0;
        Steering = 0;
    }
}

// Modified to avoid track damage & other tank damage stuff, that isn't relevant to an armored car, & also to use the APCDamageModifier
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local DHTankCannonPawn CannonPawn;
    local Controller       InstigatorController;
    local float            VehicleDamageMod, HitCheckDistance;
    local int              InstigatorTeam, PossibleDriverDamage, i;
    local bool             bAmmoDetonation;

    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }

    // Quick fix for the thing giving itself impact damage
    if (InstigatedBy == self && DamageType != VehicleBurningDamType)
    {
        ResetTakeDamageVariables();

        return;
    }

    // Don't allow your own teammates to destroy vehicles in spawns (and you know some jerks would get off on doing that to their team :))
    if (!bDriverAlreadyEntered)
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

    // Set damage modifier from the DamageType, using APCDamageModifier instead of TankDamageModifier
    if (class<ROWeaponDamageType>(DamageType) != none)
    {
        if (class<ROWeaponDamageType>(DamageType).default.APCDamageModifier >= 0.25)
        {
            VehicleDamageMod = class<ROWeaponDamageType>(DamageType).default.APCDamageModifier;
        }
    }
    else if (class<ROVehicleDamageType>(DamageType) != none)
    {
        if (class<ROVehicleDamageType>(DamageType).default.APCDamageModifier >= 0.25)
        {
            VehicleDamageMod  = class<ROVehicleDamageType>(DamageType).default.APCDamageModifier;
        }
    }

    // Add in the DamageType's vehicle damage modifier & a little damage randomisation (but not for fire damage as it messes up timings)
    if (DamageType != VehicleBurningDamType)
    {
        Damage *= RandRange(0.75, 1.08);
    }

    PossibleDriverDamage = Damage; // saved in case we need to damage driver, as VehicleDamageMod isn't relevant to driver
    Damage *= VehicleDamageMod;

    // Check RO VehHitPoints (driver, engine, ammo)
    for (i = 0; i < VehHitpoints.Length; ++i)
    {
        // Series of checks to see if we hit the vehicle driver
        if (VehHitpoints[i].HitPointType == HP_Driver)
        {
            if (Driver != none && DriverPositions[DriverPositionIndex].bExposed)
            {
                // Non-penetrating rounds have a limited HitCheckDistance
                // For penetrating rounds, HitCheckDistance will remain default zero, meaning no limit on check distance in IsPointShot()
                if (!bProjectilePenetrated)
                {
                    HitCheckDistance = DriverHitCheckDist;
                }

                if (IsPointShot(Hitlocation,Momentum, 1.0, i, HitCheckDistance))
                {
                    Driver.TakeDamage(PossibleDriverDamage, InstigatedBy, Hitlocation, Momentum, DamageType);
                }
            }
        }
        else if (bProjectilePenetrated && IsPointShot(Hitlocation, Momentum, 1.0, i))
        {
            if (bLogPenetration)
            {
                Log("We hit" @ GetEnum(enum'EHitPointType', VehHitpoints[i].HitPointType) @ "hitpoint");
            }

            // Engine hit
            if (VehHitpoints[i].HitPointType == HP_Engine)
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Hit vehicle engine");
                }

                DamageEngine(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
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
                    bAmmoDetonation = true; // stops unnecessary penetration checks, as the vehicle is going to explode anyway
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

    if (bProjectilePenetrated && !bAmmoDetonation)
    {
        // Turret penetration
        if (bTurretPenetration)
        {
            CannonPawn = DHTankCannonPawn(WeaponPawns[0]);

            if (CannonPawn != none)
            {
                // Random chance of shrapnel killing commander
                if (CannonPawn.Driver != none && FRand() < (Float(Damage) / CommanderKillChance))
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Commander killed by shrapnel");
                    }

                    CannonPawn.Driver.TakeDamage(150, InstigatedBy, Location, vect(0.0, 0.0, 0.0), DamageType);
                }

                // Random chance of shrapnel damaging gun pivot mechanism
                if (FRand() < (Float(Damage) / GunDamageChance))
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Gun pivot damaged by shrapnel");
                    }

                    CannonPawn.bGunPivotDamaged = true;
                }

                // Random chance of shrapnel damaging gun traverse mechanism
                if (FRand() < (Float(Damage) / TraverseDamageChance))
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Gun/turret traverse damaged by shrapnel");
                    }

                    CannonPawn.bTurretRingDamaged = true;
                }
            }
        }
        // Hull penetration
        else
        {
            // Random chance of shrapnel killing driver
            if (Driver != none && FRand() < (Float(Damage) / DriverKillChance))
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Driver killed by shrapnel");
                }

                Driver.TakeDamage(150, InstigatedBy, Location, vect(0.0, 0.0, 0.0), DamageType);
            }
        }
    }

    // Call the Super from Vehicle (skip over others)
    super(Vehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);

    // Vehicle is still alive, so check for possibility of a penetration causing hull fire to break out
    if (bProjectilePenetrated && !bOnFire && Damage > 0 && Health > 0)
    {
        // Random chance of hull fire breaking out
        if ((bHEATPenetration && FRand() < HullFireHEATChance) || (!bHEATPenetration && FRand() < HullFireChance))
        {
            StartHullFire(InstigatedBy);
        }
    }

    // If vehicle health is very low, kill the engine & start a fire
    if (Health >= 0 && Health <= HealthMax / 3)
    {
        EngineHealth = 0;
        bEngineOff = true;
        StartEngineFire(InstigatedBy);
    }

    ResetTakeDamageVariables();
}

defaultproperties
{
    bAllowRiders=true
    PointValue=2.0
    FirstRiderPositionIndex=1
    bSpecialTankTurning=false
    DriverKillChance=900.0
    CommanderKillChance=600.0
    GunDamageChance=1000.0
    TraverseDamageChance=1250.0
}
