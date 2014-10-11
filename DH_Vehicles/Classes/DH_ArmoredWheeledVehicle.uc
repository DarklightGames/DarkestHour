//==============================================================================
// DH_ArmoredWheeledVehicle
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Base class for all DH armored cars
//==============================================================================
class DH_ArmoredWheeledVehicle extends DH_ROTreadCraft
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

var     ECarHitPointType                    CarHitPointType;

struct CarHitpoint
{
    var() float             PointRadius;        // Squared radius of the head of the pawn that is vulnerable to headshots
    var() float             PointHeight;        // Distance from base of neck to center of head - used for headshot calculation
    var() float             PointScale;
    var() name              PointBone;          // Bone to reference in offset
    var() vector            PointOffset;        // Amount to offset the hitpoint from the bone
    var() bool              bPenetrationPoint;  // This is a penetration point, open hatch, etc
    var() float             DamageMultiplier;   // Amount to scale damage to the vehicle if this point is hit
    var() ECarHitPointType  CarHitPointType;    // What type of hit point this is
};

var()   array<CarHitpoint>      CarVehHitpoints;        // An array of possible small points that can be hit. Index zero is always the driver

//==============================================================================
// Empty Functions: we don't need for Armored Cars
//==============================================================================
simulated function UpdateMovementSound();
simulated function SetupTreads();
simulated function DestroyTreads();
function DamageTrack(bool bLeftTrack);

//==============================================================================
// Functions
//==============================================================================
// Returns true if this tank is disabled
simulated function bool IsDisabled()
{
    return (EngineHealth <= 0 || (Health >= 0 && Health <= HealthMax/3));
}

simulated function Destroyed()
{

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (DriverHatchFireEffect != none)
        {
            DriverHatchFireEffect.Destroy();
            DriverHatchFireEffect = none;
        }
    }
    //need to destroy dust and exhaust effects
    super(ROWheeledVehicle).Destroyed();       //Skip ROTreadCraft
}

simulated function PostBeginPlay()
{

    local float p;

    super(ROWheeledVehicle).PostBeginPlay();

    //Engine starting and stopping stuff
    bEngineOff=true;
    bEngineDead=false;
    bDisableThrottle=true;

    EngineHealth=EngineHealthMax;

    p = RandRange(0.15, 0.25);
    EngineFireDamagePerSec = EngineHealth * 0.09;  // Damage is dealt every 3 seconds, so this value is triple the intended per second amount
    DamagedEffectFireDamagePerSec = HealthMax * 0.02; //~100 seconds from regular tank fire threshold to detontation from full health, damage is every 2 seconds, so double intended
    PlayerFireDamagePerSec = p * 100.0; //flames inflict random amounts of low level damage to players every 2 seconds - hot! hot!

}

//overriding here because we don't want exhaust to work until
//engine start/stop AND we don't need tread stuff from TreadCraft
 simulated event DrivingStatusChanged()
{
    local PlayerController PC;


    PC = Level.GetLocalPlayerController();

    if (!bDriving || bEngineOff || bEngineDead)
    {
        // Not moving, so no motion sound
        MotionSoundVolume=0.0;
        UpdateMovementSound();
    }

    if (bDriving && PC != none && (PC.ViewTarget == none || !(PC.ViewTarget.IsJoinedTo(self))))
        bDropDetail = (Level.bDropDetail || (Level.DetailMode == DM_Low));
    else
        bDropDetail = false;

    if (bDriving || bOnFire || bEngineOnFire)
        Enable('Tick');
    else
        Disable('Tick');

    super(ROVehicle).DrivingStatusChanged();

}

simulated function Tick(float DeltaTime)
{
    local float MySpeed;

    // Only need these effects client side
    if (Level.Netmode != NM_DedicatedServer)
    {
        // Shame on you Psyonix, for calling VSize() 3 times every tick, when it only needed to be called once.
        // VSize() is very CPU intensive - Ramm
        MySpeed = VSize(Velocity);

        if (MySpeed >= MaxCriticalSpeed && Controller != none)
        {
            if (Controller.IsA('ROPlayer'))
                ROPlayer(Controller).aForward = -32768; //forces player to pull back on throttle
        }
    }

    if (bEngineOnFire || (bOnFire && Health > 0))
    {
        if (DamagedEffectHealthFireFactor != 1.0)
        {
            DamagedEffectHealthFireFactor = 1.0;
            DamagedEffect.UpdateDamagedEffect(true, 0, false, false);
        }

        if (bOnFire && DriverHatchFireEffect == none)
        {
            // Lets randomise the fire start times to desync them with the turret and engine ones
            if (Level.TimeSeconds - DriverHatchBurnTime > 0.2)
            {
                if (FRand() < 0.1)
                {
                    DriverHatchFireEffect = Spawn(FireEffectClass);
                    AttachToBone(DriverHatchFireEffect, FireAttachBone);
                    DriverHatchFireEffect.SetRelativeLocation(FireEffectOffset);
                    DriverHatchFireEffect.SetEffectScale(DamagedEffectScale);
                    DriverHatchFireEffect.UpdateDamagedEffect(true, 0, false, false);
                }
                DriverHatchBurnTime = Level.TimeSeconds;
            }
            else if (!bTurretFireTriggered)
            {
                DH_ROTankCannon(WeaponPawns[0].Gun).bOnFire = true;
                bTurretFireTriggered = true;
            }
        }

        TakeFireDamage(DeltaTime);
    }
    else if (EngineHealth <= 0 && Health > 0)
    {
        if (DamagedEffectHealthFireFactor != 0)
        {
            DamagedEffectHealthFireFactor = 0.0;
            DamagedEffectHealthHeavySmokeFactor = 1.0;
            DamagedEffect.UpdateDamagedEffect(false, 0, false, false); // reset fire effects
            DamagedEffect.UpdateDamagedEffect(false, 0, false, true);  // set the tank to smoke instead of burn
        }
    }

    Super(ROWheeledVehicle).Tick(DeltaTime);

    if (bEngineDead || bEngineOff)
    {
      velocity=vect(0,0,0);
      Throttle=0;
      ThrottleAmount=0;
      bWantsToThrottle=false;
      bDisableThrottle=true;
      Steering=0;
    }

    if (Level.NetMode != NM_DedicatedServer)
        CheckEmitters();
}

function KDriverEnter(Pawn p)
{
    local int x;

    DriverPositionIndex=InitialPositionIndex;
    PreviousPositionIndex=InitialPositionIndex;

    //check to see if Engine is already on when entering
    if (bEngineOff)
    {
        if (IdleSound != none)
        AmbientSound = none;

    }
    else if (bEngineDead)
    {
        if (IdleSound != none)
        AmbientSound = VehicleBurningSound;
    }
    else
    {
        if (IdleSound != none)
        AmbientSound = IdleSound;
    }

    ResetTime = Level.TimeSeconds - 1;
    Instigator = self;

    super(Vehicle).KDriverEnter(P);

    if (Weapons.Length > 0)
        Weapons[ActiveWeapon].bActive = true;

    Driver.bSetPCRotOnPossess = false; //so when driver gets out he'll be facing the same direction as he was inside the vehicle

    for (x = 0; x < Weapons.length; x++)
    {
        if (Weapons[x] == none)
        {
            Weapons.Remove(x, 1);
            x--;
        }
        else
        {
            Weapons[x].NetUpdateFrequency = 20;//20
            ClientRegisterVehicleWeapon(Weapons[x], x);
        }
    }
}

// Overridden here to force the server to go to state "ViewTransition", used to prevent players exiting before the unbutton anim has finished
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if (DriverPositionIndex < (DriverPositions.Length - 1))
        {
            PreviousPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;

            if (Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }

            if (Level.NetMode == NM_DedicatedServer)
            {
                if (DriverPositionIndex == UnbuttonedPositionIndex)
                    GoToState('ViewTransition');
            }
        }
    }
    else
    {
        if (DriverPositionIndex > 0)
        {
            PreviousPositionIndex = DriverPositionIndex;
            DriverPositionIndex--;

            if (Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }
        }
    }
}

simulated state ViewTransition
{
    simulated function HandleTransition()
    {
         if (Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone || Level.Netmode == NM_ListenServer)
         {
             if (DriverPositions[DriverPositionIndex].PositionMesh != none && !bDontUsePositionMesh)
                 LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
         }

         //log("HandleTransition!");

         if (PreviousPositionIndex < DriverPositionIndex && HasAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim))
         {
             SetTimer(GetAnimDuration(DriverPositions[PreviousPositionIndex].TransitionUpAnim, 1.0),false);

             //log("HandleTransition Player Transition Up!");
                 PlayAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim);
         }
         else if (HasAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim))
         {
             SetTimer(GetAnimDuration(DriverPositions[PreviousPositionIndex].TransitionDownAnim, 1.0),false);

             //log("HandleTransition Player Transition Down!");
                 PlayAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim);
         }

         if (Driver != none && Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim))
             Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
    }

    simulated function Timer()
    {
        SetTimer(1.0, false);
        GotoState('');
    }

    simulated function AnimEnd(int channel)
    {
        if (IsLocallyControlled())
            GotoState('');
    }

    simulated function EndState()
    {
        if (PlayerController(Controller) != none)
        {
            PlayerController(Controller).SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
            PlayerController(Controller).SetRotation(rot(0, 0, 0));
        }
    }

Begin:
    //log("ViewTransition Begin!");
    HandleTransition();
    Sleep(0.2);
}

// Overridden to prevent players exiting unless unbuttoned first
function bool KDriverLeave(bool bForceLeave)
{

    // if player is not unbuttoned and is trying to exit rather than switch positions, don't let them out
    // bForceLeave is always true for position switch, so checking against false means no risk of locking someone in one slot
    if (!bForceLeave && (DriverPositionIndex < UnbuttonedPositionIndex || Instigator.IsInState('ViewTransition')))
    {
        DenyEntry(Instigator, 4); // I realise that this is actually denying EXIT, but the function does the exact same thing - Ch!cken
        return false;
    }
    else
        Super.KDriverLeave(bForceLeave);

}

// Send a message on why they can't get in the vehicle
function DenyEntry(Pawn P, int MessageNum)
{
    P.ReceiveLocalizedMessage(class'DH_VehicleMessage', MessageNum);
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
        DamageType = Class'ROSuicided';
        Super(ROVehicle).TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        super(ROVehicle).TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
    }

    // Quick fix for the thing giving itself impact damage
    if (instigatedBy == self && DamageType != VehicleBurningDamType)
        return;

    // Don't allow your own teammates to destroy vehicles in spawns (and you know some jerks would get off on doing that to thier team :))
    if (!bDriverAlreadyEntered)
    {
        if (InstigatedBy != none)
            InstigatorController = instigatedBy.Controller;

        if (InstigatorController == none)
        {
            if (DamageType.default.bDelayedDamage)
                InstigatorController = DelayedDamageInstigatorController;
        }

        if (InstigatorController != none)
        {
            InstigatorTeam = InstigatorController.GetTeamNum();

            if ((GetTeamNum() != 255) && (InstigatorTeam != 255))
            {
                if (GetTeamNum() == InstigatorTeam)
                {
                    return;
                }
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

    for(i=0; i<VehHitpoints.Length; i++)
    {
        HitPointDamage=Damage;

        if (VehHitpoints[i].HitPointType == HP_Driver)
        {
            // Damage for large weapons
            if (    class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.VehicleDamageModifier > 0.25)
            {
                if (Driver != none && DriverPositions[DriverPositionIndex].bExposed && IsPointShot(Hitlocation,Momentum, 1.0, i))
                {
                    //Level.Game.Broadcast(self, "Hit Driver"); //re-comment when fixed
                    Driver.TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
                }
            }
            // Damage for small (non penetrating) arms
            else
            {
                if (Driver != none && DriverPositions[DriverPositionIndex].bExposed && IsPointShot(Hitlocation,Momentum, 1.0, i, DriverHitCheckDist))
                {
                    //Level.Game.Broadcast(self, "Hit Driver");  //re-comment when fixed
                    Driver.TakeDamage(150, instigatedBy, Hitlocation, Momentum, damageType); //just kill the bloody driver
                }
            }
        }
        else if (IsPointShot(Hitlocation,Momentum, 1.0, i))
        {
            HitPointDamage *= VehHitpoints[i].DamageMultiplier;
            HitPointDamage *= VehicleDamageMod;

            if (VehHitpoints[i].HitPointType == HP_Engine)
            {
                //extra check here prevents splashing HE/HEAT from triggering engine fires
                if (DamageType != none && (class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.TankDamageModifier > 0.5) && bProjectilePenetrated == true)
                {
                    if (bDebuggingText)
                    Level.Game.Broadcast(self, "Engine Hit Effective");
                    DamageEngine(HitPointDamage, instigatedBy, Hitlocation, Momentum, damageType);
                }
            }
            else if (VehHitpoints[i].HitPointType == HP_AmmoStore)
            {
                //extra check here prevents splashing HE/HEAT from triggering ammo detonation or fires; Engine hit will stop shell from passing through to cabin
                if (DamageType != none && (class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.TankDamageModifier > 0.5) && FRand() <= AmmoIgnitionProbability || (bWasHEATRound && FRand() < 0.85 && bProjectilePenetrated == true))
                {
                   if (bDebuggingText)
                   Level.Game.Broadcast(self, "Ammo Hit Effective");
                   Damage *= Health;//VehHitpoints[i].DamageMultiplier;
                }
                else  //either detonate above - or - set the sucker on fire!
                {
                }
                break;
            }
        }
    }

    if (bProjectilePenetrated == true)
    {
        if (bWasTurretHit == false)
        {
            if (Driver != none && !bRearHit && FRand() < 0.50)
            {
                if (bDebuggingText)
                Level.Game.Broadcast(self, "Driver killed");
                Driver.TakeDamage(150, instigatedBy, Location, vect(0,0,0), DamageType);
            }
        }
        else
        {
            if (WeaponPawns[0] != none)
            {
                if (WeaponPawns[0].Driver != none && FRand() < 0.85)
                {
                    if (bDebuggingText)
                    Level.Game.Broadcast(self, "Commander killed");
                    WeaponPawns[0].Driver.TakeDamage(150, instigatedBy, Location, vect(0,0,0), DamageType);
                }

                if (FRand() < Damage/1000)
                {
                    if (bDebuggingText)
                    Level.Game.Broadcast(self, "Gun Pivot Damaged");
                    DH_ROTankCannonPawn(WeaponPawns[0]).bGunPivotDamaged = true;
                }

                if (FRand() < Damage/1250)
                {
                    if (bDebuggingText)
                    Level.Game.Broadcast(self, "Traverse Damaged");
                    DH_ROTankCannonPawn(WeaponPawns[0]).bTurretRingDamaged = true;
                }
            }
        }
    }

    // If I allow randomised damage then things break once the hull catches fire
    if (DamageType != VehicleBurningDamType)
        Damage *= RandRange(0.85, 1.15);

    // Add in the Vehicle damage modifier for the actual damage to the vehicle itself
    Damage *= VehicleDamageMod;

    super(ROVehicle).TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);

    //This starts the hull fire; extra check added below to prevent HE splash from triggering Hull Fire Chance function
    if (!bOnFire && Damage > 0 && Health > 0 && (class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.TankDamageModifier > 0.50) && bProjectilePenetrated)
    {
        if ((DamageType != VehicleBurningDamType && FRand() < HullFireChance) || (bWasHEATRound && FRand() < HullFireHEATChance))
        {
            if (bDebuggingText)
              Level.Game.Broadcast(self, "Hull on Fire");

            bOnFire = true;
            WhoSetOnFire = instigatedBy.Controller;
            DelayedDamageInstigatorController = WhoSetOnFire;
            FireStarterTeam = WhoSetOnFire.GetTeamNum();
        }
        else if (DamageType == VehicleBurningDamType)
        {
            bOnFire = true;
            WhoSetOnFire = WhoSetEngineOnFire;
            FireStarterTeam = WhoSetOnFire.GetTeamNum();
        }
    }

    bWasHEATRound = false;
    bProjectilePenetrated = false;
    bWasTurretHit = false;

    if (Health >= 0 && Health <= HealthMax / 3)
    {
        bDisableThrottle=true;
        bEngineDead=true;
        DamagedEffectHealthFireFactor=1.0; //play fire effect
        IdleSound=VehicleBurningSound;
        StartUpSound=none;
        ShutDownSound=none;
        AmbientSound=VehicleBurningSound;
        SoundVolume=255;
        SoundRadius=600;
    }
}

defaultproperties
{
    bAllowRiders=true
    PointValue=2.000000
    bSpecialTankTurning=false
}
