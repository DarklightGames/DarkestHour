//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHThrowableHEATProjectile extends DHCannonShellHEAT;

// Obviously not a cannon shell but it is a HEAT explosive & by extending this we can make use of HEAT functionality & DH armour penetration calculations

//TO DO: implement proper mechanic for penetration of top armor. Currently it thinks its top armor hit if grenade falls vertically downwards, which isnt really a good assumption at all.
//A much better method would be looking at the angle of the armor, if armor is horizontal or close to horizontal - consider it to be top armor
//If this new method gets implemented it should be used for RPG-40, RPG-43, other similar weapons and may be even satchels

var     float           MinImpactSpeedToExplode;   // minimum impact speed at which grenade must hit a surface to explode on contact
var     float           MaxImpactAOIToExplode;     // maximum angle, in degrees, at which grenade must hit a surface to explode on contact
var     float           MaxVerticalAOIForTopArmor; // max impact angle from vertical (in degrees, relative to vehicle) that registers as a hit on relatively thin top armor
var class<WeaponPickup> PickupClass;               // pickup class if grenade is thrown but does not explode & lies on ground

// Functions entered out as not relevant to grenade
simulated static function int GetPitchForRange(int Range) { return 0; }
simulated static function float GetYAdjustForRange(int Range) { return 0; }
simulated function bool ShouldDrawDebugLines() { return false; }
function DebugShotDistanceAndSpeed();
simulated function HandleShellDebug(vector RealHitLocation);

// From DHThrowableExplosiveProjectile with ThrowerTeam stuff removed as not relevant
// Ignoring the DHGrenadeProjectile function as this doesn't use fuzed timer & we don't want grenade spin stuff as this grenade was stablised by a trailing crude 'minute chute'
// Also includes a necessary line from DHAntiVehicleProjectile & trims the inherited ExplosionSound array as we only have 3 sounds
simulated function PostBeginPlay()
{
    super(Projectile).PostBeginPlay();

    LaunchLocation = Location; // added from DHAntiVehicleProjectile & used in penetration functions

    ExplosionSound.Length = 3; // added remove unwanted 4th sound inherited from DHCannonShellHEAT

    if (Role == ROLE_Authority)
    {
        Velocity = Speed * vector(Rotation);

        if (Instigator != none && Instigator.HeadVolume != none && Instigator.HeadVolume.bWaterVolume)
        {
            Velocity = 0.25 * Velocity;
        }
    }

    Acceleration = 0.5 * PhysicsVolume.Gravity;
}

// Modified to skip over Super in DHAntiVehicleProjectile, so we simply destroy the actor
// This is a net temporary, torn off projectile, so it doesn't need the delayed destruction stuff used by a fully replicated cannon shell
simulated function HandleDestruction()
{
    Destroy();
}

// Modified to skip over Super in DHCannonShell, to avoid playing explosion effects when projectile is destroyed
// This is a net temporary, torn off projectile, so net client always handles its own destruction & so will always play explosion effects elsewhere if it needs to
simulated function Destroyed()
{
    super(DHProjectile).Destroyed();
}

// From DHThrowableExplosiveProjectile (collision mesh block checks bWontStopThrownProjectile instead of bWontStopShell)
simulated singular function Touch(Actor Other)
{
    local vector HitLocation, HitNormal;

    if (FluidSurfaceInfo(Other) != none)
    {
        CheckForSplash(Location);
    }

    if (Other == none || (!Other.bProjTarget && !Other.bBlockActors))
    {
        return;
    }

    if (Velocity == vect(0.0, 0.0, 0.0) || Other.IsA('Mover')
        || Other.TraceThisActor(HitLocation, HitNormal, Location, Location - (2.0 * Velocity), GetCollisionExtent()))
    {
        HitLocation = Location;
    }

    if (Other.IsA('DHCollisionMeshActor'))
    {
        if (DHCollisionMeshActor(Other).bWontStopThrownProjectile)
        {
            return;
        }

        Other = Other.Owner;
    }

    LastTouched = Other;
    ProcessTouch(Other, HitLocation);
    LastTouched = none;
}

// From DHThrowableExplosiveProjectile, with slight modification to use exclusion list from start of DHAntiVehicleProjectile & to record SavedTouchActor
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local vector TempHitLocation, HitNormal;

    if (Other == none || SavedTouchActor == Other || Other.IsA('ROBulletWhipAttachment') || Other == Instigator || Other.Base == Instigator || Other.Owner == Instigator
        || Other.bDeleteMe || (Other.IsA('Projectile') && !Other.bProjTarget))
    {
        return;
    }

    SavedTouchActor = Other;
    Trace(TempHitLocation, HitNormal, HitLocation + Normal(Velocity) * 50.0, HitLocation - Normal(Velocity) * 50.0, true); // get a reliable HitNormal for a deflection

    HitWall(HitNormal, Other);
}



// Based on DHCannonShellHEAT with elements from DHGrenadeProjectile
// Modified to handle possible explosion on impact, depending on impact speed
simulated function HitWall(vector HitNormal, Actor Wall)
{
    local RODestroyableStaticMesh DestroMesh;
    local Actor  TraceHitActor;
    local vector Direction, TempHitLocation, TempHitNormal, VehicleRelativeVertical, X, Y;
    local int    ImpactSpeed, xH, TempMaxWall, i;
    local bool   bExplodeOnImpact, bFailedToPenetrate;
    local float  ImpactAOI;  // Angle of incidence, in degrees
    local float  ImpactDamageMultiplier;

    // Exit without doing anything if we hit something we don't want to count a hit on (allowing Wall == none as grenade's Landed() passes none)
    if (bInHitWall || (Wall != none && (SavedHitActor == Wall || (Wall.Base != none && Wall.Base == Instigator) || Wall.bDeleteMe))) // HEAT adds bInHitWall check to prevent recursive calls
    {
        return;
    }

    SavedHitActor = Pawn(Wall);

    // If we didn't hit a pawn, lets see if we hit a VehicleWeapon and if so get that weapon's base pawn and set it
    if (SavedHitActor == none && VehicleWeapon(Wall) != none && VehicleWeapon(Wall).Base != none && Pawn(VehicleWeapon(Wall).Base) != none)
    {
        SavedHitActor = Pawn(VehicleWeapon(Wall).Base);
    }

    // Return here, this was causing the famous "nade bug"
    if (ROCollisionAttachment(Wall) != none)
    {
        return;
    }

    DestroMesh = RODestroyableStaticMesh(Wall);
    ImpactDamageMultiplier = 0.25;

    // We hit a destroyable mesh that is so weak it doesn't stop bullets (e.g. glass), so we'll probably break it instead of bouncing off it
    if (DestroMesh != none && DestroMesh.bWontStopBullets)
    {
        // On a server (single player), we'll simply cause enough damage to break the mesh
        if (Role == ROLE_Authority)
        {
            DestroMesh.TakeDamage(DestroMesh.Health + 1, Instigator, Location, MomentumTransfer * Normal(Velocity), class'DHWeaponBashDamageType');

            // But it will only take damage if it's vulnerable to a weapon bash - so check if it's been reduced to zero Health & if so then we'll exit without deflecting
            if (DestroMesh.Health < 0)
            {
                return;
            }
        }
        // Problem is that a client needs to know right now whether or not the mesh will break, so it can decide whether or not to bounce off
        // So as a workaround we'll loop through the meshes TypesCanDamage array & check if the server's weapon bash DamageType will have broken the mesh
        else
        {
            for (i = 0; i < DestroMesh.TypesCanDamage.Length; ++i)
            {
                // The destroyable mesh will be damaged by a weapon bash, so we'll exit without deflecting
                if (DestroMesh.TypesCanDamage[i] == class'DHWeaponBashDamageType' || ClassIsChildOf(class'DHWeaponBashDamageType', DestroMesh.TypesCanDamage[i]))
                {
                    return;
                }
            }
        }
    }

    bOrientToVelocity = false; // disable this after we hit something as the stabilising 'mini chute' will no longer have any effect

    // Check whether grenade explodes on impact or bounces off, depending on what it hit, how fast & at what angle
    // Made it so it grenade never explodes if it hits a player & always bounces off (discourages throwing at other players)
    if (ROPawn(Wall) == none)
    {
        ImpactSpeed = VSize(Velocity);
        ImpactAOI = Abs(class'UUnits'.static.RadiansToDegrees(Acos(HitNormal dot Normal(Velocity))) - 180.0);

        // Grenade will explode if impact speed is high enough & it angle of incidence is low enough (that prevents glancing hits from detonating it)
        // TODO: maybe use CheckWall() to get hit surface Hardness & use that to calculate required ImpactSpeed?
        if (ImpactSpeed >= default.MinImpactSpeedToExplode && ImpactAOI <= default.MaxImpactAOIToExplode)
        {
            // We hit an armored vehicle
            // 1st check if we should pen. a side hit
            // 2nd check whether it's a downwards hit, which probably means grenade dropped onto relatively thin top surface armour (a common tactic)
            // If so we'll assume HEAT grenade's substantial penetration will defeat top armour of any vehicle's hull or turret, so skip penetration check
            // Top hits or armor are not modelled in this game, but it's a reasonable assumption as even heavy tanks only had 30-40mm top armor
            // Otherwise do normal armour penetration check & exit if it fails to penetrate (with suitable effects)
            //TO DO: make a more proper method of handling of top armor hit. Ideally it should look at the angle of armor and detect if armor is horizontal or close to horizontal, then consider it a top armor
            if (DHArmoredVehicle(Wall) != none || DHVehicleCannon(Wall) != none)
            {
                if (((Wall.IsA('DHArmoredVehicle') && !DHArmoredVehicle(Wall).ShouldPenetrate(self, Location, Normal(Velocity), GetMaxPenetration(LaunchLocation, Location)))
                    || (Wall.IsA('DHVehicleCannon') && !DHVehicleCannon(Wall).ShouldPenetrate(self, Location, Normal(Velocity), GetMaxPenetration(LaunchLocation, Location)))))
                {
                    bFailedToPenetrate = true;
                }

                // If we have failed to pen the side, then see if it was a top hit
                if (bFailedToPenetrate)
                {
                    // Re-calc AOI, this time relative to a line 'straight up' from the vehicle (relative to its rotation)
                    Wall.GetAxes(Wall.Rotation, X, Y, VehicleRelativeVertical);
                    ImpactAOI = class'UUnits'.static.RadiansToDegrees(Acos(-Normal(Velocity) dot VehicleRelativeVertical));

                    if (ImpactAOI <= default.MaxVerticalAOIForTopArmor)
                    {
                        // We hit top armor and at the right angle
                        bFailedToPenetrate = false;
                        ImpactDamageMultiplier = 3.0;
                    }
                }

                if (bFailedToPenetrate)
                {
                    FailToPenetrateArmor(Location, HitNormal, Wall);
                    return;
                }
            }

            bExplodeOnImpact = true;
        }
    }

    // Deflect without exploding if grenade failed to detonate
    if (!bExplodeOnImpact)
    {
        Deflect(Location, HitNormal, Wall);

        return;
    }

    // Check & record whether we hit a world object we can penetrate
    if (Wall != none && (Wall.bStatic || Wall.bWorldGeometry) && !Wall.bCanBeDamaged)
    {
        bHitWorldObject = true;
    }

    if (Role == ROLE_Authority)
    {
        if (!bHitWorldObject)
        {
            if (SavedHitActor != none || Wall.bCanBeDamaged)
            {
                if (ShouldDrawDebugLines())
                {
                    DrawStayingDebugLine(Location, Location - (Normal(Velocity) * 500.0), 255, 0, 0);
                }

                UpdateInstigator();

                if (ShellImpactDamage.default.bDelayedDamage && InstigatorController != none)
                {
                    Wall.SetDelayedDamageInstigatorController(InstigatorController);
                }

                Wall.TakeDamage(ImpactDamage * ImpactDamageMultiplier, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
            }

            if (DamageRadius > 0.0 && ROVehicle(Wall) != none && ROVehicle(Wall).Health > 0)
            {
                CheckVehicleOccupantsRadiusDamage(ROVehicle(Wall), Damage, DamageRadius, MyDamageType, MomentumTransfer, Location);
            }

            HurtWall = Wall;
        }
        else if (bBotNotifyIneffective && ROBot(InstigatorController) != none)
        {
            ROBot(InstigatorController).NotifyIneffectiveAttack();
        }
    }

    Explode(Location + ExploWallOut * HitNormal, HitNormal);

    bInHitWall = true; // set flag to prevent recursive calls

    // Do the MaxWall calculations
    Direction = vector(Rotation);
    CheckWall(HitNormal, Direction);
    xH = 1.0 / Hardness;
    MaxWall = EnergyFactor * xH * PenetrationScale * WScale;

    // Due to MaxWall getting into very high ranges we need to make shorter trace checks till we reach the full MaxWall value
    if (MaxWall > 16.0)
    {
        do
        {
            if ((TempMaxWall + 16.0) <= MaxWall)
            {
                TempMaxWall += 16.0;
            }
            else
            {
                TempMaxWall = MaxWall;
            }

            TraceHitActor = Trace(TempHitLocation, TempHitNormal, Location, Location + (Direction * TempMaxWall), false);

            // Due to static meshes resulting in a hit even with the trace starting right inside of them (terrain and BSP 'space' would return none)
            if (TraceHitActor != none && !SetLocation(TempHitLocation + (vect(0.5, 0.0, 0.0) * Direction)))
            {
                TraceHitActor = none;
            }
        }
        until (TraceHitActor != none || TempMaxWall >= MaxWall)
    }
    else
    {
        TraceHitActor = Trace(TempHitLocation, TempHitNormal, Location, Location + (Direction * MaxWall), false);
    }

    if (TraceHitActor != none && SetLocation(TempHitLocation + (vect(0.5, 0.0, 0.0) * Direction)))
    {
        WorldPenetrationExplode(TempHitLocation + (PeneExploWallOut * TempHitNormal), TempHitNormal);

        bInHitWall = false;

        if (MaxWall >= 1.0)
        {
            return;
        }
    }

    HandleDestruction();
}

// Modified to use grenade bounce functionality from DHThrowableExplosiveProjectile
// In that class it's at the end of HitWall(), but here conveniently moved into Deflect() function of our DHAntiVehicleProjectile parent class
simulated function Deflect(vector HitLocation, vector HitNormal, Actor Wall)
{
    local ESurfaceTypes ST;
    local vector        VNorm;

    GetHitSurfaceType(ST, HitNormal);
    GetDampenAndSoundValue(ST); // gets the deflect dampen factor & the hit sound, based on the type of surface the projectile hit

    // Don't let grenade bounce too often
    if (NumDeflections > 5)
    {
        bBounce = false;
    }
    // Reflect off Wall with damping
    else
    {
        VNorm = (Velocity dot HitNormal) * HitNormal;
        Velocity = -VNorm * DampenFactor + ((Velocity - VNorm) * DampenFactorParallel);
        Speed = VSize(Velocity);
        NumDeflections++;
    }

    if (Level.NetMode != NM_DedicatedServer && Speed > 150.0 && ImpactSound != none)
    {
        PlaySound(ImpactSound, SLOT_Misc, 1.1);
    }
}

// From DHThrowableExplosiveProjectile
simulated function GetHitSurfaceType(out ESurfaceTypes ST, vector HitNormal)
{
    local vector   HitLoc, HitNorm;
    local material HitMat;

    Trace(HitLoc, HitNorm, Location - (HitNormal * 16.0), Location, false,, HitMat);

    if (HitMat == none)
    {
        ST = EST_Default;
    }
    else
    {
        ST = ESurfaceTypes(HitMat.SurfaceType);
    }
}

// From DHThrowableExplosiveProjectile
simulated function GetDampenAndSoundValue(ESurfaceTypes ST)
{
    switch (ST)
    {
        case EST_Default:
            DampenFactor = 0.15;
            DampenFactorParallel = 0.5;
            ImpactSound = Sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Rock:
            DampenFactor = 0.2;
            DampenFactorParallel = 0.5;
            ImpactSound = Sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Dirt:
            DampenFactor = 0.1;
            DampenFactorParallel = 0.45;
            ImpactSound = Sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Metal:
            DampenFactor = 0.2;
            DampenFactorParallel = 0.5;
            ImpactSound = Sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Wood:
            DampenFactor = 0.15;
            DampenFactorParallel = 0.4;
            ImpactSound = Sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Plant:
            DampenFactor = 0.1;
            DampenFactorParallel = 0.1;
            ImpactSound = Sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Flesh:
            DampenFactor = 0.1;
            DampenFactorParallel = 0.3;
            ImpactSound = Sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Ice:
            DampenFactor = 0.2;
            DampenFactorParallel = 0.55;
            ImpactSound = Sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Snow:
            DampenFactor = 0.0;
            DampenFactorParallel = 0.0;
            ImpactSound = Sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Water:
            DampenFactor = 0.0;
            DampenFactorParallel = 0.0;
            ImpactSound = WaterHitSound;
            break;

        case EST_Glass:
            DampenFactor = 0.3;
            DampenFactorParallel = 0.55;
            ImpactSound = Sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Custom01: //Sand
            DampenFactor = 0.1;
            DampenFactorParallel = 0.45;
            ImpactSound = Sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Custom02: //SandBag
            DampenFactor = 0.2;
            DampenFactorParallel = 0.55;
            ImpactSound = Sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Custom03: //Brick
            DampenFactor = 0.2;
            DampenFactorParallel = 0.5;
            ImpactSound = Sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Custom04: //Hedgerow
            DampenFactor = 0.15;
            DampenFactorParallel = 0.55;
            ImpactSound = Sound'Inf_Weapons_Foley.grenadeland';
            break;
    }
}

// From DHThrowableExplosiveProjectile
simulated function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    if (NewVolume != none && NewVolume.bWaterVolume)
    {
        Velocity *= 0.25;
        CheckForSplash(Location);
    }
}

defaultproperties
{
    // Properties from usual grenade parent classes (DHGrenadeProjectile & DHThrowableExplosiveProjectile)
    Physics=PHYS_Falling
    bBounce=true
    TossZ=150.0
    DampenFactor=0.05
    DampenFactorParallel=0.8
    MomentumTransfer=3000.0
    bSwitchToZeroCollision=true
    bBlockHitPointTraces=false
    CollisionHeight=2.0
    CollisionRadius=4.0
    ShakeRotTime=4.0
    ShakeOffsetTime=6.0
    PenetrationMag=3.0
    BlurTime=4.0
    BlurEffectScalar=1.35
    LightType=LT_Pulse
    LightEffect=LE_NonIncidence
    LightPeriod=3
    LightBrightness=200
    LightHue=30
    LightSaturation=150
    LightRadius=5.0

    // Override unwanted properties inherited from cannon shell parent classes
    bTrueBallistics=false
    bUpdateSimulatedPosition=false
    bNetTemporary=true // doesn't use replicated FuzeLengthTimer to make it explode, like other grenades (& short range weapon without ongoing movement replication like cannon shell)
    TransientSoundRadius=300.0
    TransientSoundVolume=0.3
    AmbientSound=none
    AmbientGlow=0
    FluidSurfaceShootStrengthMod=0.0
    RotationRate=(Roll=0)
    DesiredRotation=(Roll=0)
    ForceType=FT_None
    bHasTracer=false
}
