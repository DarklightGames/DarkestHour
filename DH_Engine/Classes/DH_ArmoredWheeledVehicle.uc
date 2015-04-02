//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ArmoredWheeledVehicle extends DHTreadCraft
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
    var() float             PointRadius;       // squared radius of the head of the pawn that is vulnerable to headshots
    var() float             PointHeight;       // distance from base of neck to center of head - used for headshot calculation
    var() float             PointScale;
    var() name              PointBone;         // bone to reference in offset
    var() vector            PointOffset;       // amount to offset the hitpoint from the bone
    var() bool              bPenetrationPoint; // this is a penetration point, open hatch, etc
    var() float             DamageMultiplier;  // amount to scale damage to the vehicle if this point is hit
    var() ECarHitPointType  CarHitPointType;   // what type of hit point this is
};

var()   array<CarHitpoint>  CarVehHitpoints;   // an array of possible small points that can be hit (index zero is always the driver)

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
        // Shame on you Psyonix, for calling VSize() 3 times every tick, when it only needed to be called once.
        // VSize() is very CPU intensive - Ramm
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

// TakeDamage - overloaded to prevent bayonet and bash attacks from damaging vehicles
//              for Tanks, we'll probably want to prevent bullets from doing damage too
function TakeDamage(int Damage, Pawn instigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local int i;
    local float VehicleDamageMod;
    local int HitPointDamage;
    local int InstigatorTeam;
    local controller InstigatorController;

    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';
        super(ROVehicle).TakeDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        super(ROVehicle).TakeDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType);
    }

    // Quick fix for the thing giving itself impact damage
    if (instigatedBy == self && DamageType != VehicleBurningDamType)
    {
        return;
    }

    // Don't allow your own teammates to destroy vehicles in spawns (and you know some jerks would get off on doing that to thier team :))
    if (!bDriverAlreadyEntered)
    {
        if (InstigatedBy != none)
        {
            InstigatorController = instigatedBy.Controller;
        }

        if (InstigatorController == none)
        {
            if (DamageType.default.bDelayedDamage)
            {
                InstigatorController = DelayedDamageInstigatorController;
            }
        }

        if (InstigatorController != none)
        {
            InstigatorTeam = InstigatorController.GetTeamNum();

            if (GetTeamNum() != 255 && InstigatorTeam != 255 && GetTeamNum() == InstigatorTeam)
            {
                return;
            }
        }
    }

    // Hacked in APC damage mod for halftracks and armored cars, but bullets/bayo/nades/bashing still shouldn't work...
    if (DamageType != none)
    {
        if (class<ROWeaponDamageType>(DamageType) != none &&
            class<ROWeaponDamageType>(DamageType).default.APCDamageModifier >= 0.25)
        {
            VehicleDamageMod = class<ROWeaponDamageType>(DamageType).default.APCDamageModifier;
        }
        else if (class<ROVehicleDamageType>(DamageType) != none &&
            class<ROVehicleDamageType>(DamageType).default.APCDamageModifier >= 0.25)
        {
            VehicleDamageMod = class<ROVehicleDamageType>(DamageType).default.APCDamageModifier;
        }
    }

    for (i = 0; i < VehHitpoints.Length; ++i)
    {
        HitPointDamage = Damage;

        if (VehHitpoints[i].HitPointType == HP_Driver)
        {
            // Damage for large weapons
            if (class<ROWeaponDamageType>(DamageType) != none &&
                class<ROWeaponDamageType>(DamageType).default.VehicleDamageModifier > 0.25)
            {
                if (Driver != none && DriverPositions[DriverPositionIndex].bExposed && IsPointShot(HitLocation,Momentum, 1.0, i))
                {
                    Driver.TakeDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType);
                }
            }
            // Damage for small (non penetrating) arms
            else
            {
                if (Driver != none && DriverPositions[DriverPositionIndex].bExposed && IsPointShot(HitLocation,Momentum, 1.0, i, DriverHitCheckDist))
                {
                    Driver.TakeDamage(150, instigatedBy, HitLocation, Momentum, DamageType); //just kill the bloody driver
                }
            }
        }
        else if (IsPointShot(HitLocation, Momentum, 1.0, i))
        {
            HitPointDamage *= VehHitpoints[i].DamageMultiplier;
            HitPointDamage *= VehicleDamageMod;

            if (VehHitpoints[i].HitPointType == HP_Engine)
            {
                //extra check here prevents splashing HE/HEAT from triggering engine fires
                if (DamageType != none && (class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.TankDamageModifier > 0.5) && bProjectilePenetrated == true)
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Engine Hit Effective");
                    }

                    DamageEngine(HitPointDamage, instigatedBy, HitLocation, Momentum, DamageType);
                }
            }
            else if (VehHitpoints[i].HitPointType == HP_AmmoStore)
            {
                //extra check here prevents splashing HE/HEAT from triggering ammo detonation or fires; Engine hit will stop shell from passing through to cabin
                if (DamageType != none && (class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.TankDamageModifier > 0.5) && FRand() <= AmmoIgnitionProbability || (bWasHEATRound && FRand() < 0.85 && bProjectilePenetrated == true))
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Ammo Hit Effective");
                    }

                    Damage *= Health;
                }
                else  //either detonate above - or - set the sucker on fire!
                {
                }
                break;
            }
        }
    }

    if (bProjectilePenetrated)
    {
        if (!bWasTurretHit)
        {
            if (Driver != none && !bRearHit && FRand() < 0.5)
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Driver killed");
                }

                Driver.TakeDamage(150, instigatedBy, Location, vect(0.0, 0.0, 0.0), DamageType);
            }
        }
        else
        {
            if (WeaponPawns[0] != none)
            {
                if (WeaponPawns[0].Driver != none && FRand() < 0.85)
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Commander killed");
                    }

                    WeaponPawns[0].Driver.TakeDamage(150, instigatedBy, Location, vect(0.0, 0.0, 0.0), DamageType);
                }

                if (FRand() < Damage / 1000)
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Gun Pivot Damaged");
                    }

                    DHTankCannonPawn(WeaponPawns[0]).bGunPivotDamaged = true;
                }

                if (FRand() < Damage / 1250)
                {
                    if (bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Traverse Damaged");
                    }

                    DHTankCannonPawn(WeaponPawns[0]).bTurretRingDamaged = true;
                }
            }
        }
    }

    // If I allow randomised damage then things break once the hull catches fire
    if (DamageType != VehicleBurningDamType)
    {
        Damage *= RandRange(0.85, 1.15);
    }

    // Add in the Vehicle damage modifier for the actual damage to the vehicle itself
    Damage *= VehicleDamageMod;

    super(ROVehicle).TakeDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType);

    //This starts the hull fire; extra check added below to prevent HE splash from triggering Hull Fire Chance function
    if (!bOnFire && Damage > 0 && Health > 0 && (class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.TankDamageModifier > 0.5) && bProjectilePenetrated)
    {
        if ((DamageType != VehicleBurningDamType && FRand() < HullFireChance) || (bWasHEATRound && FRand() < HullFireHEATChance))
        {
            StartHullFire(InstigatedBy);
        }
    }

    bWasHEATRound = false;
    bProjectilePenetrated = false;
    bWasTurretHit = false;

    // If vehicle health is very low, kill the engine & start a fire
    if (Health >= 0 && Health <= HealthMax / 3)
    {
        EngineHealth = 0;
        bEngineOff = true;
        StartEngineFire(InstigatedBy);
    }
}

defaultproperties
{
    bAllowRiders=true
    PointValue=2.0
    FirstRiderPositionIndex=1
    bSpecialTankTurning=false
}
