//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHFastAutoFire extends DHAutomaticFire;

// internal class vars
var     float                   LastCalcTime;           // Internal var used to calculate when to replicate the dual shots
var DHHighROFWeaponAttachment   HiROFWeaponAttachment;  // A high ROF WA that this class will use to pack fire info

// Animation
var     float                   LoopFireAnimRate;       // The rate to play the looped fire animation when hipped
var     float                   IronLoopFireAnimRate;   // The rate to play the looped fire animation when deployed or in iron sights

// sound
var     sound                   FireEndSound;           // The sound to play at the end of the ambient fire sound
var     float                   AmbientFireSoundRadius; // The sound radius for the ambient fire sound
var     sound                   AmbientFireSound;       // How loud to play the looping ambient fire sound
var     byte                    AmbientFireVolume;      // The ambient fire sound

// High ROF system
var     float                   PackingThresholdTime;   // If the shots are closer than this amount, the dual shot will be used

// Overridden to support packing two shots together to save net bandwidth
function DoFireEffect()
{
    local vector  StartProj, StartTrace, X, Y, Z;
    local rotator R, Aim;
    local vector  HitLocation, HitNormal;
    local Actor   Other;
    local int     ProjectileID;
    local int     SpawnCount;
    local float   theta;
    local coords  MuzzlePosition;

    Instigator.MakeNoise(1.0);

    Weapon.GetViewAxes(X, Y, Z);

    // if weapon in iron sights, spawn at eye position, otherwise spawn at muzzle tip
    if (Instigator.Weapon.bUsingSights || Instigator.bBipodDeployed)
    {
        StartTrace = Instigator.Location + Instigator.EyePosition();
        StartProj = StartTrace + X * ProjSpawnOffset.X;

        // check if projectile would spawn through a wall and adjust start location accordingly
        Other = Trace(HitLocation, HitNormal, StartProj, StartTrace, false);

        if (Other != none)
        {
            StartProj = HitLocation;
        }
    }
    else
    {
        MuzzlePosition = Weapon.GetMuzzleCoords();

        // Get the muzzle position and scale it down 5 times (since the model is scaled up 5 times in the editor)
        StartTrace = MuzzlePosition.Origin - Weapon.Location;
        StartTrace = StartTrace * 0.2;
        StartTrace = Weapon.Location + StartTrace;

        StartProj = StartTrace + MuzzlePosition.XAxis * FAProjSpawnOffset.X;

        Other = Trace(HitLocation, HitNormal, StartTrace, StartProj, true); // was false to only trace worldgeometry

        if (Other != none)
        {
            StartProj = HitLocation;
        }
    }

    Aim = AdjustAim(StartProj, AimError);

    // For free-aim, just use where the muzzlebone is pointing
    if (!Instigator.Weapon.bUsingSights && !Instigator.bBipodDeployed && Instigator.Weapon.bUsesFreeAim && Instigator.IsHumanControlled())
    {
        Aim = rotator(MuzzlePosition.XAxis);
    }

    SpawnCount = Max(1, ProjPerFire * int(Load));

    CalcSpreadModifiers();

    if (DHProjectileWeapon(Owner) != none && DHProjectileWeapon(Owner).bBarrelDamaged)
    {
        AppliedSpread = 4.0 * Spread;
    }
    else
    {
        AppliedSpread = Spread;
    }

    switch (SpreadStyle)
    {
        case SS_Random:

            X = vector(Aim);

            for (ProjectileID = 0; ProjectileID < SpawnCount; ++ProjectileID)
            {
                R.Yaw = AppliedSpread * ((FRand() - 0.5) / 1.5);
                R.Pitch = AppliedSpread * (FRand() - 0.5);
                R.Roll = AppliedSpread * (FRand() - 0.5);

                HandleProjectileSpawning(StartProj, rotator(X >> R));
            }

            break;

        case SS_Line:

            for (ProjectileID = 0; ProjectileID < SpawnCount; ++ProjectileID)
            {
                theta = AppliedSpread * PI / 32768.0 * (ProjectileID - float(SpawnCount - 1) / 2.0);
                X.X = Cos(theta);
                X.Y = Sin(theta);
                X.Z = 0.0;
                HandleProjectileSpawning(StartProj, rotator(X >> Aim));
            }

            break;

        default:
            HandleProjectileSpawning(StartProj, Aim);
    }
}

// This function handles combining the shots and when to replicate them
function HandleProjectileSpawning(vector SpawnPoint, rotator SpawnAim)
{
    if (Level.NetMode == NM_Standalone)
    {
        super(DHProjectileFire).SpawnProjectile(SpawnPoint, SpawnAim);

        return;
    }

    if (HiROFWeaponAttachment == none)
    {
        HiROFWeaponAttachment = DHHighROFWeaponAttachment(Weapon.ThirdPersonActor);
    }

    SpawnProjectile(SpawnPoint, SpawnAim);

    if (Level.NetMode == NM_Standalone)
    {
        return;
    }
    else if ((Level.TimeSeconds - LastCalcTime) > PackingThresholdTime)
    {
        HiROFWeaponAttachment.LastShot = HiROFWeaponAttachment.MakeShotInfo(SpawnPoint, SpawnAim);
        HiROFWeaponAttachment.bUnReplicatedShot = true;
    }
    else
    {
        if (HiROFWeaponAttachment.bFirstShot)
        {
            HiROFWeaponAttachment.LastShot = HiROFWeaponAttachment.MakeShotInfo(SpawnPoint, SpawnAim);
            HiROFWeaponAttachment.bFirstShot = false;
            HiROFWeaponAttachment.bUnReplicatedShot = true;
        }
        else
        {
            HiROFWeaponAttachment.SavedDualShot.FirstShot = HiROFWeaponAttachment.LastShot;
            HiROFWeaponAttachment.SavedDualShot.Secondshot = HiROFWeaponAttachment.MakeShotInfo(SpawnPoint, SpawnAim);
            HiROFWeaponAttachment.bFirstShot = true;

            // Skip 255 as we will use it for a special trigger
            if (HiROFWeaponAttachment.DualShotCount < 254)
            {
                HiROFWeaponAttachment.DualShotCount ++;
            }
            else
            {
                HiROFWeaponAttachment.DualShotCount = 1;
            }

            HiROFWeaponAttachment.NetUpdateTime = Level.TimeSeconds - 1;

            HiROFWeaponAttachment.bUnReplicatedShot = false;
        }
    }

    LastCalcTime = Level.TimeSeconds;
}

// Plays the animation at the end of firing the weapon
function PlayFireEnd()
{
    local DHProjectileWeapon RPW;

    RPW = DHProjectileWeapon(Weapon);

    if (RPW.HasAnim(FireEndAnim) && !RPW.bUsingSights && !Instigator.bBipodDeployed)
    {
        RPW.PlayAnim(FireEndAnim, FireEndAnimRate, TweenTime);
    }
    else if (RPW.HasAnim(FireIronEndAnim) && (RPW.bUsingSights || Instigator.bBipodDeployed))
    {
        RPW.PlayAnim(FireIronEndAnim, FireEndAnimRate, TweenTime);
    }
}

// Sends the fire class to the looping state
function StartFiring()
{
   GotoState('FireLoop');
}

// Handles toggling the weapon attachment's ambient sound on and off
function PlayAmbientSound(sound aSound)
{
    local WeaponAttachment WA;

    WA = WeaponAttachment(Weapon.ThirdPersonActor);

    if (Weapon == none || WA == none)
    {
        return;
    }

    if (aSound == none)
    {
        WA.SoundVolume = WA.default.SoundVolume;
        WA.SoundRadius = WA.default.SoundRadius;
    }
    else
    {
        WA.SoundVolume = AmbientFireVolume;
        WA.SoundRadius = AmbientFireSoundRadius;
    }

    WA.AmbientSound = aSound;
}

// Make sure we are in the fire looping state when we fire
event ModeDoFire()
{
    if (!ROWeapon(Owner).IsBusy() && AllowFire() && IsInState('FireLoop'))
    {
        super.ModeDoFire();
    }
}

// This state handles looping the firing animations and ambient fire sounds as well as firing rounds.
state FireLoop
{
    function BeginState()
    {
        local DHProjectileWeapon RPW;

        NextFireTime = Level.TimeSeconds - 0.1; // fire now!

        RPW = DHProjectileWeapon(Weapon);

        if (!RPW.bUsingSights && !Instigator.bBipodDeployed)
        {
            Weapon.LoopAnim(FireLoopAnim, LoopFireAnimRate, TweenTime);
        }
        else
        {
            Weapon.LoopAnim(FireIronLoopAnim, IronLoopFireAnimRate, TweenTime);
        }

        PlayAmbientSound(AmbientFireSound);
    }

    // Overridden because we play an ambient fire sound
    function PlayFiring() { }
    function ServerPlayFiring() { }

    function EndState()
    {
        Weapon.AnimStopLooping();
        PlayAmbientSound(none);
        Weapon.PlayOwnedSound(FireEndSound, SLOT_None, FireVolume,, AmbientFireSoundRadius);
        Weapon.StopFire(ThisModeNum);

        //If we are not switching weapons, go to the idle state
        if (!Weapon.IsInState('LoweringWeapon'))
        {
            ROWeapon(Weapon).GotoState('Idle');
        }
    }

    function StopFiring()
    {
        if (Level.NetMode == NM_DedicatedServer && HiROFWeaponAttachment != none && HiROFWeaponAttachment.bUnReplicatedShot)
        {
            HiROFWeaponAttachment.SavedDualShot.FirstShot = HiROFWeaponAttachment.LastShot;

            if (HiROFWeaponAttachment.DualShotCount == 255)
            {
                HiROFWeaponAttachment.DualShotCount = 254;
            }
            else
            {
                HiROFWeaponAttachment.DualShotCount = 255;
            }

            HiROFWeaponAttachment.NetUpdateTime = Level.TimeSeconds - 1;
        }

        GotoState('');
    }

    function ModeTick(float DeltaTime)
    {
        super(WeaponFire).ModeTick(DeltaTime);

        // Stopped firing, magazine empty or barrel overheat // WeaponTODO: see how to properly reimplement this
        if (!bIsFiring || ROWeapon(Weapon).IsBusy() || !AllowFire() || (DHProjectileWeapon(Weapon) != none && DHProjectileWeapon(Weapon).bBarrelFailed))
        {
            GotoState('');

            return;
        }
    }
}

// Modified to disable bullet replication, so actor won't be replicated to clients (was the only difference in the server bullet class)
function Projectile SpawnProjectile(vector Start, rotator Dir)
{
    local Projectile SpawnedProjectile;

    SpawnedProjectile = super.SpawnProjectile(Start, Dir);

    if (DHBullet(SpawnedProjectile) != none)
    {
        DHBullet(SpawnedProjectile).SetAsServerBullet();
    }

    return SpawnedProjectile;
}

function float MaxRange()
{
    return 4500.0; // about 75 meters
}

defaultproperties
{
    LoopFireAnimRate=1.0
    IronLoopFireAnimRate=1.0
    PackingThresholdTime=0.1
    NoAmmoSound=sound'Inf_Weapons_Foley.Misc.dryfire_smg'
}
