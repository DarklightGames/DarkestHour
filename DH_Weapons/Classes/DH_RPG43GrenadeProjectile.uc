//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_RPG43GrenadeProjectile extends DHCannonShellHEAT;
// Obviously not a cannon shell but it is a HEAT explosive & by extending this we can make use of HEAT functionality & DH armour penetration calculations

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

    // Added splash if projectile hits a fluid surface
    if (FluidSurfaceInfo(Other) != none)
    {
        CheckForSplash(Location);
    }

    if (Other == none || (!Other.bProjTarget && !Other.bBlockActors))
    {
        return;
    }

    // We use TraceThisActor do a simple line check against the actor we've hit, to get an accurate HitLocation to pass to ProcessTouch()
    // It's more accurate than using our current location as projectile has often travelled a little further by the time this event gets called
    // But if that trace returns true then it somehow didn't hit the actor, so we fall back to using our current location as the HitLocation
    // Also skip trace & use location as HitLocation if our velocity is somehow zero (collided immediately on launch?) or we hit a Mover actor
    if (Velocity == vect(0.0, 0.0, 0.0) || Other.IsA('Mover')
        || Other.TraceThisActor(HitLocation, HitNormal, Location, Location - (2.0 * Velocity), GetCollisionExtent()))
    {
        HitLocation = Location;
    }

    // Special handling for hit on a collision mesh actor - switch hit actor to CM's owner & proceed as if we'd hit that actor
    if (Other.IsA('DHCollisionMeshActor'))
    {
        if (DHCollisionMeshActor(Other).bWontStopThrownProjectile)
        {
            return; // exit, doing nothing, if col mesh actor is set not to stop a thrown projectile, e.g. grenade or satchel
        }

        Other = Other.Owner;
    }

    // Now call ProcessTouch(), which is the where the class-specific Touch functionality gets handled
    // Record LastTouched to make sure that if HurtRadius() gets called to give blast damage, it will always 'find' the hit actor
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

// From DHThrowableExplosiveProjectile, modified so when projectile lands without having detonated it becomes a pickup
// Also to adjust rotation on ground to compensate for static mesh being modelled facing forwards instead of up (required due to nature of this grenade's flight)
// Also to remove 'Fear' stuff, as grenade does not explode after landing (if fails to detonate on impact)
// Makes use of inherited NumDeflections variable as replacement for grenade's Bounces (works in reverse, counting up to 5 instead of down from 5)
simulated function Landed(vector HitNormal)
{
    local rotator NewRotation;
    local WeaponPickup P;

    if (NumDeflections > 5)
    {
        if (Role == ROLE_Authority)
        {
            bOrientToVelocity = false; // disable this after grenade lands as it will have no velocity & we want to preserve its rotation on the ground
            SetPhysics(PHYS_None);
            NewRotation = QuatToRotator(QuatProduct(QuatFromRotator(rotator(HitNormal)), QuatFromAxisAndAngle(HitNormal, class'UUnits'.static.UnrealToRadians(Rotation.Yaw))));
            NewRotation.Pitch -= 16384; // somewhat hacky fix for static mesh rotation
            SetRotation(NewRotation);

            P = Spawn(default.PickupClass,,, Location + vect(0.0, 0.0, 2.0), Rotation);

            if (P != none)
            {
                P.InitDroppedPickupFor(none);
                P.AmmoAmount[0] = 1;
            }
        }

        Destroy();
    }
    else
    {
        HitWall(HitNormal, none);
    }
}

// Based on DHCannonShellHEAT with elements from DHGrenadeProjectile
// Modified to handle possible explosion on impact, depending on impact speed
simulated function HitWall(vector HitNormal, Actor Wall)
{
    local RODestroyableStaticMesh DestroMesh;
    local Actor  TraceHitActor;
    local vector Direction, TempHitLocation, TempHitNormal, VehicleRelativeVertical, X, Y;
    local int    ImpactSpeed, xH, TempMaxWall, i;
    local bool   bExplodeOnImpact;
    local float  ImpactAOI;  // Angle of incidence, in degrees

    // Exit without doing anything if we hit something we don't want to count a hit on (allowing Wall == none as grenade's Landed() passes none)
    if (bInHitWall || (Wall != none && (SavedHitActor == Wall || (Wall.Base != none && Wall.Base == Instigator) || Wall.bDeleteMe))) // HEAT adds bInHitWall check to prevent recursive calls
    {
        return;
    }

    SavedHitActor = Pawn(Wall);

    // Return here, this was causing the famous "nade bug"
    if (ROCollisionAttachment(Wall) != none)
    {
        return;
    }

    DestroMesh = RODestroyableStaticMesh(Wall);

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
            // 1st check whether it's a downwards hit, which probably means grenade dropped onto relatively thin top surface armour (a common tactic)
            // If so we'll assume HEAT grenade's substantial penetration will defeat top armour of any vehicle's hull or turret, so skip penetration check
            // Top hits or armor are not modelled in this game, but it's a reasonable assumption as even heavy tanks only had 30-40mm top armor
            // Otherwise do normal armour penetration check & exit if it fails to penetrate (with suitable effects)
            if (DHArmoredVehicle(Wall) != none || DHVehicleCannon(Wall) != none)
            {
                // Re-calc AOI, this time relative to a line 'straight up' from the vehicle (relative to its rotation)
                Wall.GetAxes(Wall.Rotation, X, Y, VehicleRelativeVertical);
                ImpactAOI = class'UUnits'.static.RadiansToDegrees(Acos(-Normal(Velocity) dot VehicleRelativeVertical));

                if (ImpactAOI > default.MaxVerticalAOIForTopArmor &&
                    ((Wall.IsA('DHArmoredVehicle') && !DHArmoredVehicle(Wall).ShouldPenetrate(self, Location, Normal(Velocity), GetMaxPenetration(LaunchLocation, Location)))
                    || (Wall.IsA('DHVehicleCannon') && !DHVehicleCannon(Wall).ShouldPenetrate(self, Location, Normal(Velocity), GetMaxPenetration(LaunchLocation, Location)))))
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
    if (Wall != none && (Wall.bStatic || Wall.bWorldGeometry) && !Wall.IsA('RODestroyableStaticMesh') && !Wall.IsA('Mover'))
    {
        bHitWorldObject = true;
    }

    if (Role == ROLE_Authority)
    {
        if (!bHitWorldObject)
        {
            if (SavedHitActor != none || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
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

                Wall.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
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
        until (TraceHitActor != none || TempMaxWall >= MaxWall);
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
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Rock:
            DampenFactor = 0.2;
            DampenFactorParallel = 0.5;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Dirt:
            DampenFactor = 0.1;
            DampenFactorParallel = 0.45;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Metal:
            DampenFactor = 0.2;
            DampenFactorParallel = 0.5;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Wood:
            DampenFactor = 0.15;
            DampenFactorParallel = 0.4;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Plant:
            DampenFactor = 0.1;
            DampenFactorParallel = 0.1;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Flesh:
            DampenFactor = 0.1;
            DampenFactorParallel = 0.3;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Ice:
            DampenFactor = 0.2;
            DampenFactorParallel = 0.55;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Snow:
            DampenFactor = 0.0;
            DampenFactorParallel = 0.0;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
            break;

        case EST_Water:
            DampenFactor = 0.0;
            DampenFactorParallel = 0.0;
            ImpactSound = WaterHitSound;
            break;

        case EST_Glass:
            DampenFactor = 0.3;
            DampenFactorParallel = 0.55;
            ImpactSound = sound'Inf_Weapons_Foley.grenadeland';
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
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.RPG43Grenade_throw' // TODO: add trailing 'mini chute' to thrown static mesh
    Speed=900.0
    bOrientToVelocity=true // so grenade doesn't spin & faces the way it's travelling, as was stablised by trailing crude 'minute chute'
    LifeSpan=15.0          // used in case the grenade fails to detonate on impact (will lie around for a bit for effect, then disappear)
    bExplodesOnHittingWater=false
    bHasTracer=false

    // Armour penetration
    ShellDiameter=9.5
    DHPenetrationTable(0)=7.5
    DHPenetrationTable(1)=7.5
    DHPenetrationTable(2)=7.5
    DHPenetrationTable(3)=7.5
    DHPenetrationTable(4)=7.5
    DHPenetrationTable(5)=7.5
    DHPenetrationTable(6)=7.5
    DHPenetrationTable(7)=7.5
    DHPenetrationTable(8)=7.5
    DHPenetrationTable(9)=7.5
    DHPenetrationTable(10)=7.5

    // Damage
    ImpactDamage=250
    Damage=200.0
    DamageRadius=180.0
    ShellImpactDamage=class'DH_Weapons.DH_RPG43GrenadeImpactDamType'
    MyDamageType=class'DH_Weapons.DH_RPG43GrenadeDamType'

    // Effects
    ShellHitDirtEffectClass=class'GrenadeExplosion'
    ShellHitWoodEffectClass=class'GrenadeExplosion'
    ShellHitRockEffectClass=class'GrenadeExplosion'
    ShellHitSnowEffectClass=class'GrenadeExplosionSnow'
    ShellHitWaterEffectClass=class'ROEffects.ROBulletHitWaterEffect'
    ShellHitVehicleEffectClass=class'ROEffects.PanzerfaustHitTank'
    ShellDeflectEffectClass=class'GrenadeExplosion'
    ExplosionDecal=class'ROEffects.GrenadeMark'
    ExplosionDecalSnow=class'ROEffects.GrenadeMarkSnow'

    // Sounds
    VehicleHitSound=SoundGroup'DH_WeaponSounds.RPG43.RPG43_explode01'
    VehicleDeflectSound=sound'Inf_Weapons_Foley.grenadeland'
    ImpactSound=sound'Inf_Weapons_Foley.grenadeland'
    DirtHitSound=sound'Inf_Weapons_Foley.grenadeland'
    RockHitSound=sound'Inf_Weapons_Foley.grenadeland'
    WoodHitSound=sound'Inf_Weapons_Foley.grenadeland'
    WaterHitSound=SoundGroup'ProjectileSounds.Bullets.Impact_Water'
    ExplosionSound(0)=SoundGroup'DH_WeaponSounds.RPG43.RPG43_explode01'
    ExplosionSound(1)=SoundGroup'DH_WeaponSounds.RPG43.RPG43_explode02'
    ExplosionSound(2)=SoundGroup'DH_WeaponSounds.RPG43.RPG43_explode03'

    // Properties from usual grenade parent classes (DHGrenadeProjectile & DHThrowableExplosiveProjectile)
    Physics=PHYS_Falling
    bBounce=true
    MaxSpeed=1500.0
    TossZ=150.0
    DampenFactor=0.05
    DampenFactorParallel=0.8
    MomentumTransfer=8000.0
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
    ExplosionSoundVolume=3.0 // seems high but TransientSoundVolume is only 0.3, compared to 1.0 for a shell
    AmbientSound=none
    AmbientGlow=0
    FluidSurfaceShootStrengthMod=0.0
    RotationRate=(Roll=0)
    DesiredRotation=(Roll=0)
    ForceType=FT_None

    // RPG-43 specific variables
    MaxImpactAOIToExplode=35.0
    MinImpactSpeedToExplode=900.0
    MaxVerticalAOIForTopArmor=25.0
    PickupClass=class'DH_Weapons.DH_RPG43GrenadePickup'
}
