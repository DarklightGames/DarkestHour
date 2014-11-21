//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROAntiVehicleProjectile extends ROAntiVehicleProjectile
        abstract;

var     float       DHPenetrationTable[11];

var     float       ShellDiameter;                  // to assist in T/d calculations

var     bool        bIsHEATRound;                   // Triggers different penetration calcs for HEAT projectiles (generally rockets)
var     bool        bIsAlliedShell;                 // just for debugging stuff, maybe later for shell shatter
var     bool        bShatterProne;                  // assists with shatter gap calculations

var()   class<Emitter>  ShellShatterEffectClass;    // Effect for this shell shattering against a vehicle
var     sound           ShatterVehicleHitSound;     // sound of this shell shattering on the vehicle
var     sound           ShatterSound[4];            // sound of the round exploding

var     Effects     Corona;     // Shell tracer
var     bool        bHasTracer; // will be disabled for HE shells, and any others with no tracers
var class<Effects>  TracerEffect;

// camera shakes //
var()       vector              ShakeRotMag;                // how far to rot view
var()       vector              ShakeRotRate;               // how fast to rot view
var()       float               ShakeRotTime;               // how much time to rot the instigator's view
var()       vector              ShakeOffsetMag;             // max view offset vertically
var()       vector              ShakeOffsetRate;            // how fast to offset view vertically
var()       float               ShakeOffsetTime;            // how much time to offset view
var         float               BlurTime;                   // How long blur effect should last for this shell
var         float               BlurEffectScalar;
var         float               PenetrationMag;             //different for AP and HE shells and can be set by caliber too

// Debugging code - set to false on release
var     bool    bDebuggingText;

//Borrowed from AB: Just using a standard linear interpolation equation here
simulated function float GetPenetration(vector Distance)
{
    local float MeterDistance;
    local float PenetrationNumber;

    MeterDistance = VSize(Distance)/60.352;

    //Distance debugging
    //log(self$" traveled "$MeterDistance$" meters for penetration calculations");
    //Level.Game.Broadcast(self, self$" traveled "$MeterDistance$" meters for penetration calculations");

    if      (MeterDistance < 100)  PenetrationNumber = (DHPenetrationTable[0] + (100 - MeterDistance) * (DHPenetrationTable[0]-DHPenetrationTable[1]) / 100);
    else if (MeterDistance < 250)   PenetrationNumber = (DHPenetrationTable[1] + (250 - MeterDistance) * (DHPenetrationTable[0]-DHPenetrationTable[1]) / 150);
    else if (MeterDistance < 500)   PenetrationNumber = (DHPenetrationTable[2] + (500 - MeterDistance) * (DHPenetrationTable[1]-DHPenetrationTable[2]) / 250);
    else if (MeterDistance < 750)   PenetrationNumber = (DHPenetrationTable[3] + (750 - MeterDistance) * (DHPenetrationTable[2]-DHPenetrationTable[3]) / 250);
    else if (MeterDistance < 1000)  PenetrationNumber = (DHPenetrationTable[4] + (1000 - MeterDistance) * (DHPenetrationTable[3]-DHPenetrationTable[4]) / 250);
    else if (MeterDistance < 1250)  PenetrationNumber = (DHPenetrationTable[5] + (1250 - MeterDistance) * (DHPenetrationTable[4]-DHPenetrationTable[5]) / 250);
    else if (MeterDistance < 1500)  PenetrationNumber = (DHPenetrationTable[6] + (1500 - MeterDistance) * (DHPenetrationTable[5]-DHPenetrationTable[6]) / 250);
    else if (MeterDistance < 1750)  PenetrationNumber = (DHPenetrationTable[7] + (1750 - MeterDistance) * (DHPenetrationTable[6]-DHPenetrationTable[7]) / 250);
    else if (MeterDistance < 2000)  PenetrationNumber = (DHPenetrationTable[8] + (2000 - MeterDistance) * (DHPenetrationTable[7]-DHPenetrationTable[8]) / 250);
    else if (MeterDistance < 2500)  PenetrationNumber = (DHPenetrationTable[9] + (2500 - MeterDistance) * (DHPenetrationTable[8]-DHPenetrationTable[9]) / 500);
    else if (MeterDistance < 3000)  PenetrationNumber = (DHPenetrationTable[10] + (3000 - MeterDistance) * (DHPenetrationTable[9]-DHPenetrationTable[10]) / 500);
    else PenetrationNumber = DHPenetrationTable[10];

    if (NumDeflections > 0)
    {
        PenetrationNumber = PenetrationNumber * 0.04;  //just for now, until pen is based on velocity
    }

    return PenetrationNumber;

}

//DH CODE: Returns (T/d) for APC/APCBC shells
simulated function float GetOverMatch (float ArmorFactor, float ShellDiameter)
{
    local float OverMatchFactor;

    OverMatchFactor = (ArmorFactor / ShellDiameter);

    return OverMatchFactor;

}

// Matt: re-worked, with commentary below
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local ROVehicle       HitVehicle;
    local ROVehicleWeapon HitVehicleWeapon;
    local vector          TempHitLocation, HitNormal, SavedVelocity;
    local array<int>      HitPoints;
    local float           TouchAngle; // dummy variable passed to DHShouldPenetrate function (does not need a value setting)

    if (bDebuggingText) log("AP.ProcessTouch called: Other =" @ Other.Tag @ " SavedTouchActor =" @ SavedTouchActor @ " SavedHitActor =" @ SavedHitActor); // TEMP

    if (Other == none || SavedTouchActor == Other || Other.bDeleteMe || Other.IsA('ROBulletWhipAttachment') ||
        Other == Instigator || Other.Base == Instigator || Other.Owner == Instigator || (Other.IsA('Projectile') && !Other.bProjTarget))
    {
        return;
    }

    SavedTouchActor = Other;
    HitVehicleWeapon = ROVehicleWeapon(Other);
    HitVehicle = ROVehicle(Other.Base);

    // We hit a VehicleWeapon
    if (HitVehicleWeapon != none && HitVehicle != none)
    {
        // We hit the Driver's collision box, not the actual VehicleWeapon
        if (HitVehicleWeapon.HitDriverArea(HitLocation, Velocity))
        {
            // We actually hit the Driver
            if (HitVehicleWeapon.HitDriver(HitLocation, Velocity))
            {
                if (Drawdebuglines && Firsthit && Level.NetMode != NM_DedicatedServer)
                {
                    FirstHit = false;
                    DrawStayingDebugLine(Location, Location - (Normal(Velocity) * 500.0), 255, 0, 0);
                }

                if (bDebuggingText) log("AP.ProcessTouch: hit driver, authority should damage him & shell continue"); // TEMP
                if (Role == ROLE_Authority && VehicleWeaponPawn(HitVehicleWeapon.Owner) != none && VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver != none)
                {
                    VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
                }

                Velocity *= 0.8; // hitting the Driver's body doesn't cause shell to explode, but we'll slow it down a bit
            }
            else
            {
                if (bDebuggingText) log("AP.ProcessTouch: hit driver area but not driver, shell should continue"); // TEMP
                SavedTouchActor = none; // this isn't a real hit so we shouldn't save hitting this actor
            }

            return; // exit so shell carries on, as it only hit Driver's collision box not actual VehicleWeapon (even if we hit the Driver, his body won't stop shell)
        }

        SavedHitActor = HitVehicle;

        if (bDebuggingText && Role == ROLE_Authority)
        {
            if (bIsAlliedShell)
            {
                Level.Game.Broadcast(self, "Dist:" @ VSize(LaunchLocation - Location) / 66.002 @ "yards, ImpactVel:" @ VSize(Velocity) / 18.395 @ "fps");
            }
            else
            {
                Level.Game.Broadcast(self, "Dist:" @ VSize(LaunchLocation - Location) / 60.352 @ "m, ImpactVel:" @ VSize(Velocity) / 60.352 @ "m/s");
            }
        }

        // We hit a tank cannon (turret) but failed to penetrate
        if (HitVehicleWeapon.IsA('DH_ROTankCannon') && !DH_ROTankCannon(HitVehicleWeapon).DHShouldPenetrateAPC(HitLocation, Normal(Velocity),
            GetPenetration(LaunchLocation - HitLocation), TouchAngle, ShellDiameter, ShellImpactDamage, bShatterProne))
        {
            if (Drawdebuglines && Firsthit && Level.NetMode != NM_DedicatedServer)
            {
                FirstHit = false;
                DrawStayingDebugLine(Location, Location - (Normal(Velocity) * 500.0), 0, 255, 0);
            }

            // Round deflects off the turret
            if (!bShatterProne || !DH_ROTankCannon(HitVehicleWeapon).bRoundShattered)
            {
                if (bDebuggingText && Role == ROLE_Authority)
                {
                    Level.Game.Broadcast(self, "Turret ricochet!");
                }

                SavedHitActor = none; // don't save hitting this actor since we deflected
                bUpdateSimulatedPosition = false; // don't replicate the position any more

                DoShakeEffect();
                DeflectWithoutNormal(HitVehicleWeapon, HitLocation);

                if (Instigator != none && ROBot(Instigator.Controller) != none)
                {
                    ROBot(Instigator.Controller).NotifyIneffectiveAttack(HitVehicle);
                }
            }
            // Round shatters on turret
            else
            {
                if (bDebuggingText && Role == ROLE_Authority)
                {
                    Level.Game.Broadcast(self, "Round shattered on turret");
                }

                ShatterExplode(HitLocation + ExploWallOut * Normal(-Velocity), Normal(-Velocity));

                // Don't update the position any more and don't move the projectile any more
                bUpdateSimulatedPosition = false;
                SetPhysics(PHYS_None);
                SetDrawType(DT_None);

                HurtWall = none;
            }

            return;
        }

        // Don't update the position any more and don't move the projectile any more
        bUpdateSimulatedPosition = false;
        SavedVelocity = Velocity; // PHYS_None zeroes Velocity, so we have to save it
        SetPhysics(PHYS_None);
        SetDrawType(DT_None);

        if (Drawdebuglines && Firsthit && Level.NetMode != NM_DedicatedServer)
        {
            FirstHit = false;
            DrawStayingDebugLine(Location, Location - (Normal(SavedVelocity) * 500.0), 255, 0, 0);
        }

        if (Role == ROLE_Authority)
        {
            if (Instigator == none || Instigator.Controller == none)
            {
                HitVehicleWeapon.SetDelayedDamageInstigatorController(InstigatorController);
                HitVehicle.SetDelayedDamageInstigatorController(InstigatorController);
            }

            HitVehicleWeapon.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(SavedVelocity), ShellImpactDamage);

            if (DamageRadius > 0 && HitVehicle.Health > 0)
            {
                HitVehicle.DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, HitLocation);
            }

            HurtWall = HitVehicle;
        }

        Explode(HitLocation + ExploWallOut * Normal(-SavedVelocity), Normal(-SavedVelocity));
        HurtWall = none;

        return;
    }
    // We hit something other than a VehicleWeapon
    else
    {
        // We hit a soldier ... potentially - first we need to run a HitPointTrace to make sure we actually hit part of his body, not just his collision area
        if (Other.IsA('ROPawn'))
        {
            Other = HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535.0 * Normal(Velocity)), HitPoints, HitLocation,, 0);

            // We hit one of the body's hit points, so register a hit on the soldier
            if (Other != none)
            {
                if (bDebuggingText) log("AP.ProcessTouch: successful HitPointTrace on ROPawn, authority calling ProcessLocationalDamage on it"); // TEMP
                if (Role == ROLE_Authority)
                {
                    ROPawn(Other).ProcessLocationalDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage, HitPoints);
                }

                Velocity *= 0.8; // hitting a body doesn't cause shell to explode, but we'll slow it down a bit
            }
            else if (bDebuggingText) log("AP.ProcessTouch: unsuccessful HitPointTrace on ROPawn, doing nothing"); // TEMP

            return; // exit without exploding, so shell continues on its flight
        }
        // We hit some other kind of pawn or a destroyable mesh
        else if (Other.IsA('RODestroyableStaticMesh') || Other.IsA('Pawn'))
        {
            if (Role == ROLE_Authority)
            {
                Other.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
            }

            // We hit a destroyable mesh that is so weak it doesn't stop bullets (e.g. glass), so it won't make a shell explode
            if (Other.IsA('RODestroyableStaticMesh') && RODestroyableStaticMesh(Other).bWontStopBullets)
            {
                if (bDebuggingText) log("AP.ProcessTouch: exiting as hit destroyable SM but it doesn't stop bullets"); // TEMP
                return;
            }
            else if (bDebuggingText && Other.IsA('RODestroyableStaticMesh')) log("AP.ProcessTouch: exploding on destroyable SM"); // TEMP
            else if (bDebuggingText) log("AP.ProcessTouch: exploding on Pawn" @ Other.Tag @ "that is not an ROPawn"); // TEMP
        }
        // Otherwise we hit something we aren't going to damage
        else if (Role == ROLE_Authority && Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
        {
            if (bDebuggingText) log("AP.ProcessTouch: exploding on Actor" @ Other.Tag @ "that is not a Pawn or destroyable SM???"); // TEMP
            ROBot(Instigator.Controller).NotifyIneffectiveAttack();
        }

        // Don't update the position any more and don't move the projectile any more
        bUpdateSimulatedPosition = false;
        SetPhysics(PHYS_None);
        SetDrawType(DT_None);

        Explode(HitLocation, vect(0.0,0.0,1.0));
        HurtWall = none;
    }
}

simulated singular function HitWall(vector HitNormal, actor Wall)
{
    local vector SavedVelocity;
//  local PlayerController PC;

    local float HitAngle;

    HitAngle=1.57;

    if (Wall.Base != none && Wall.Base == instigator)
        return;

    SavedVelocity = Velocity;

    if (bDebuggingText && Role == ROLE_Authority)
    {
        if (!bIsAlliedShell)
        {
          Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/60.352)$"m, ImpactVel: "$VSize(Velocity) / 60.352$" m/s");
        }
        else
        {
          Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/66.002)$"yards, ImpactVel: "$VSize(Velocity) / 18.395$" fps");
        }
    }

    if (Wall.IsA('DH_ROTreadCraft') && !DH_ROTreadCraft(Wall).DHShouldPenetrateAPC(Location, Normal(Velocity), GetPenetration(LaunchLocation-Location), HitAngle, ShellDiameter, ShellImpactDamage, bShatterProne))
    {

        if (bDebuggingText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Hull Ricochet!");
        }

        if (Drawdebuglines && Firsthit)
        {
            FirstHit=false;
            DrawStayingDebugLine(Location, Location-(Normal(Velocity)*500), 0, 255, 0);
            // DrawStayingDebugLine(Location, Location + 1000*HitNormal, 255, 0, 255);
        }

        if (!bShatterProne || !DH_ROTreadCraft(Wall).bRoundShattered)
        {

            // Don't save hitting this actor since we deflected
            SavedHitActor = none;
            // Don't update the position any more
            bUpdateSimulatedPosition=false;

            DoShakeEffect();
            Deflect(HitNormal, Wall);

            if (Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
               ROBot(Instigator.Controller).NotifyIneffectiveAttack(ROVehicle(Wall));

            return;
        }
        else
        {
            if (Role == ROLE_Authority)
            {
                MakeNoise(1.0);
            }

            ShatterExplode(Location + ExploWallOut * HitNormal, HitNormal);

            // Don't update the position any more and don't move the projectile any more.
            bUpdateSimulatedPosition=false;
            SetPhysics(PHYS_None);
            SetDrawType(DT_None);

            HurtWall = none;
            return;
        }
    }

    if ((SavedHitActor == Wall) || (Wall.bDeleteMe))
        return;

    // Don't update the position any more and don't move the projectile any more.
    bUpdateSimulatedPosition=false;
    SetPhysics(PHYS_None);
    SetDrawType(DT_None);

    SavedHitActor = Pawn(Wall);

    Super(ROBallisticProjectile).HitWall(HitNormal, Wall);

    if (Role == ROLE_Authority)
    {
        if ((!Wall.bStatic && !Wall.bWorldGeometry) || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
        {
            if (Instigator == none || Instigator.Controller == none)
                Wall.SetDelayedDamageInstigatorController(InstigatorController);

            if (savedhitactor != none || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
            {
                if (Drawdebuglines && Firsthit)
                {
                    FirstHit=false;
                    DrawStayingDebugLine(Location, Location-(Normal(SavedVelocity)*500), 255, 0, 0);
                }
                Wall.TakeDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(SavedVelocity), ShellImpactDamage);
            }

            if (DamageRadius > 0 && Vehicle(Wall) != none && Vehicle(Wall).Health > 0)
                Vehicle(Wall).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, Location);
            HurtWall = Wall;
        }
        else
        {
            if (Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
                ROBot(Instigator.Controller).NotifyIneffectiveAttack();
        }
        MakeNoise(1.0);
    }

    Explode(Location + ExploWallOut * HitNormal, HitNormal);

    HurtWall = none;

}

simulated function DoShakeEffect()
{
    local PlayerController PC;
    local float Dist, Scale;

    //viewshake
    if (Level.NetMode != NM_DedicatedServer)
    {
        PC = Level.GetLocalPlayerController();
        if (PC != none && PC.ViewTarget != none)
        {
            Dist = VSize(Location - PC.ViewTarget.Location);

            if (Dist < PenetrationMag * 3.0 && ShellDiameter > 2.0)
            {
                scale = (PenetrationMag * 3.0  - Dist) / (PenetrationMag * 3.0);
                scale *= BlurEffectScalar;

                PC.ShakeView(ShakeRotMag*Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag*Scale, ShakeOffsetRate, ShakeOffsetTime);

                if (PC.Pawn != none && ROPawn(PC.Pawn) != none)
                {
                    scale = scale - (scale * 0.35 - ((scale * 0.35) * ROPawn(PC.Pawn).GetExposureTo(Location + 50 * -Normal(PhysicsVolume.Gravity))));
                }
                ROPlayer(PC).AddBlur(BlurTime*scale, FMin(1.0,scale));
            }
        }
    }
}

// AP shell shatter for when it hit a tank but didn't penetrate
simulated function ShatterExplode(vector HitLocation, vector HitNormal)
{
    if (bCollided)
        return;

    DoShakeEffect();

    if (!bDidExplosionFX)
    {
        PlaySound(ShatterVehicleHitSound,,5.5*TransientSoundVolume);
        if (EffectIsRelevant(Location, false))
        {
            Spawn(ShellShatterEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
        }

        PlaySound(ShatterSound[Rand(4)],,5.5*TransientSoundVolume);

        bDidExplosionFX=true;
    }

    if (Corona != none)
        Corona.Destroy();

    // Save the hit info for when the shell is destroyed
    SavedHitLocation = HitLocation;
    SavedHitNormal = HitNormal;
    AmbientSound=none;

    BlowUp(HitLocation);

    // Give the projectile a little time to play the hit effect client side before destroying the projectile
    if (Level.NetMode == NM_DedicatedServer)
    {
        bCollided = true;
        SetCollision(false, false);
    }
    else
    {
        Destroy();
    }
}

defaultproperties
{
     bIsAlliedShell=true
     ShellShatterEffectClass=class'DH_Effects.DH_TankAPShellShatter'
     ShatterVehicleHitSound=SoundGroup'ProjectileSounds.cannon_rounds.HE_deflect'
     ShatterSound(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
     ShatterSound(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
     ShatterSound(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
     ShatterSound(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'
     ShakeRotMag=(Y=50.000000,Z=200.000000)
     ShakeRotRate=(Y=500.000000,Z=1500.000000)
     ShakeRotTime=3.000000
     ShakeOffsetMag=(Z=10.000000)
     ShakeOffsetRate=(Z=200.000000)
     ShakeOffsetTime=5.000000
     BlurTime=3.000000
     BlurEffectScalar=1.900000
     PenetrationMag=100.000000
}
