//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHThrownExplosiveFire extends DHProjectileFire
    abstract;

const   RANDOM_FUSE_TIME = 0.5;

var     float   MinimumThrowSpeed;      // minimum speed the explosive will have if just clicking, with no hold time
var     float   MaximumThrowSpeed;      // the maximum speed an explosive can have with holding (not including pawn speed)
var     float   SpeedFromHoldingPerSec; // speed increase projectile will have for each second the fire button is held
var     float   AddedFuseTime;          // additional fuse time to add to compensate for the pin pull animation
var     bool    bPullAnimCompensation;  // add time to the fuse time to compensate for the pin pull animation
var     bool    bIsSmokeGrenade;        // is a smoke grenade, which will not harm the thrower

// Modified to allow player to throw explosive while prone transitioning (removes restriction in Super)
simulated function bool AllowFire()
{
    local DHExplosiveWeapon W;

    W = DHExplosiveWeapon(Weapon);

    if (Level.NetMode == NM_Client &&
        Instigator != none && Instigator.IsLocallyControlled() &&
        W != none && W.AmmoAmount(ThisModeNum) < W.StartFireAmmoAmount)
    {
        return true;
    }

    return W != none && W.AmmoAmount(ThisModeNum) >= AmmoPerFire;
}

// Modified to consume ammo on the clients end
// Also to stop an already drawn back explosive from being thrown if player's weapons become locked (due to spawn killing)
event ModeDoFire()
{
    if (!AllowFire())
    {
        return;
    }

    // Stop an already drawn back explosive from being thrown if player's weapons become locked (due to spawn killing)
    // Happens because that forces the fire button to be released, which triggers this event
    // TODO: clean this up & perhaps find a better place to do this, it's just a quick fix with some problems (Matt, Jan 2017)
    if (Instigator != none && DHPlayer(Instigator.Controller) != none && DHPlayer(Instigator.Controller).AreWeaponsLocked())
    {
        return;
    }

    if (MaxHoldTime > 0.0)
    {
        HoldTime = FMin(HoldTime, MaxHoldTime);
    }

    // Server
    if (Weapon.Role == ROLE_Authority)
    {
        Weapon.ConsumeAmmo(ThisModeNum, Load);
        DoFireEffect();
        HoldTime = 0.0; // if bot decides to stop firing, HoldTime must be reset first

        if (Instigator == none || Instigator.Controller == none)
        {
            return;
        }

        if (AIController(Instigator.Controller) != none)
        {
            AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);
        }

        Instigator.DeactivateSpawnProtection();
    }

    // Client
    if (Instigator != none && Instigator.IsLocallyControlled())
    {
        if (!bDelayedRecoil)
        {
            HandleRecoil();
        }

        ShakeView();
        PlayFiring();

        // Consume ammo on the client as well, if the ammo count hasn't been net updated yet - this should prevent some of the ammo amount related lag bugs
        if (Level.NetMode == NM_Client && DHExplosiveWeapon(Weapon) != none && DHExplosiveWeapon(Weapon).StartFireAmmoAmount == Weapon.AmmoAmount(ThisModeNum))
        {
            Weapon.ConsumeAmmo(ThisModeNum, Load);
        }

        if (!bMeleeMode)
        {
            if (Instigator.IsFirstPerson() && !bAnimNotifiedShellEjects)
            {
                EjectShell();
            }

            FlashMuzzleFlash();
            StartMuzzleSmoke();
        }
    }
    // Server
    else
    {
        ServerPlayFiring();
    }

    Weapon.IncrementFlashCount(ThisModeNum);

    // Set the next firing time - must be careful here so client & server do not get out of sync
    if (bFireOnRelease)
    {
        if (bIsFiring)
        {
            NextFireTime += MaxHoldTime + FireRate;
        }
        else
        {
            NextFireTime = Level.TimeSeconds + FireRate;
        }
    }
    else
    {
        NextFireTime += FireRate;
        NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
    }

    Load = AmmoPerFire;
    HoldTime = 0.0;

    if (Instigator != none && Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != none)
    {
        bIsFiring = false;
        Weapon.PutDown();
    }

    Weapon.PostFire();

    if (ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).SetExplosiveHoldAnims(false);
    }
}

// Modified to ignore weapon stuff like sights, bipod & muzzle position
function DoFireEffect()
{
    local vector  StartProj, StartTrace, X, Y, Z, HitLocation, HitNormal;
    local rotator R, Aim;
    local Actor   Other;
    local int     ProjectileID, SpawnCount;
    local float   Theta;

    Instigator.MakeNoise(1.0);

    Weapon.GetViewAxes(X, Y, Z);

    // Check if projectile would spawn through a wall & adjust start location accordingly
    StartTrace = Instigator.Location + Instigator.EyePosition();
    StartProj = StartTrace + (X * ProjSpawnOffset.X);
    Other = Trace(HitLocation, HitNormal, StartProj, StartTrace, false);

    if (Other != none)
    {
        StartProj = HitLocation;
    }

    Aim = AdjustAim(StartProj, AimError);
    SpawnCount = Max(1, ProjPerFire * int(Load));
    CalcSpreadModifiers();
    AppliedSpread = Spread;

    switch (SpreadStyle)
    {
        case SS_Random:

            X = vector(Aim);

            for (ProjectileID = 0; ProjectileID < SpawnCount; ++ProjectileID)
            {
                R.Yaw = AppliedSpread * ((FRand() - 0.5) / 1.5);
                R.Pitch = AppliedSpread * (FRand() - 0.5);
                R.Roll = AppliedSpread * (FRand() - 0.5);
                SpawnProjectile(StartProj, rotator(X >> R));
            }

            break;

        case SS_Line:

            for (ProjectileID = 0; ProjectileID < SpawnCount; ++ProjectileID)
            {
                Theta = AppliedSpread * PI / 32768.0 * (ProjectileID - float(SpawnCount - 1) / 2.0);
                X.X = Cos(Theta);
                X.Y = Sin(Theta);
                X.Z = 0.0;
                SpawnProjectile(StartProj, rotator(X >> Aim));
            }

            break;

        default:
            SpawnProjectile(StartProj, Aim);
    }

    // Nade blew up in hand - kill the holder if they aren't already
    if (DHExplosiveWeapon(Weapon) != none && DHExplosiveWeapon(Weapon).bAlreadyExploded && !bIsSmokeGrenade && ROPawn(Weapon.Instigator) != none)
    {
        ROPawn(Weapon.Instigator).KilledSelf(ProjectileClass.default.MyDamageType);
    }
}

// Modified to ignore weapon stuff like sights, bipod, etc
function CalcSpreadModifiers()
{
    local ROPawn ROP;
    local float  PlayerSpeed, MovementPctModifier;

    ROP = ROPawn(Instigator);

    if (ROP == none)
    {
        return;
    }

    // Calc spread based on movement speed
    PlayerSpeed = VSize(ROP.Velocity);
    MovementPctModifier = PlayerSpeed / ROP.default.GroundSpeed;
    Spread = default.Spread + default.Spread * MovementPctModifier;

    // Increase the spread if you're jumping
    if (ROP.Physics == PHYS_Falling)
    {
        Spread *= 3.0;
    }
}

// Custom projectile spawning for thrown explosives
function Projectile SpawnProjectile(vector Start, rotator Dir)
{
    local Projectile SpawnedProjectile;
    local float      PawnSpeed, ThrowSpeed, SetFuseTime;
    local vector     X, Y, Z;

    // Spawn the projectile
    Dir.Pitch += AddedPitch; // this will increase the angle the grenade is thrown at

    if (Instigator != none && Instigator.Health > 0)
    {
        SpawnedProjectile = Spawn(ProjectileClass, Instigator.Controller,, Start, Dir);
    }
    else
    {
        SpawnedProjectile = Spawn(ProjectileClass, none,, Start, Dir); // the thrower is dead, so set owner to none so no one gets credit/penalty for deaths
    }

    if (SpawnedProjectile == none)
    {
        return none;
    }

    if (Instigator != none)
    {
        // Dead 'nade (thrower died)
        if (Instigator.Health <= 0)
        {
            // Set the remaining fuze length
            if (DHThrowableExplosiveProjectile(SpawnedProjectile) != none)
            {
                DHThrowableExplosiveProjectile(SpawnedProjectile).FuzeLengthTimer = FMax(0.1, DHExplosiveWeapon(Weapon).CurrentFuzeTime) + RandRange(0.0, RANDOM_FUSE_TIME);
            }

            // Have the grenade go in the direction the thrower was going, then exit
            SpawnedProjectile.Velocity = Instigator.Velocity;

            return SpawnedProjectile;
        }

        // Get the thrower's movement speed (relative to the throw direction)
        Weapon.GetViewAxes(X, Y, Z);
        PawnSpeed = X dot Instigator.Velocity;
    }

    // Calculate projectile thrown speed from the hold time, then add the thrower's movement speed to the grenade
    ThrowSpeed = HoldTime * SpeedFromHoldingPerSec;
    SpawnedProjectile.Speed = FClamp(ThrowSpeed, MinimumThrowSpeed, MaximumThrowSpeed);
    SpawnedProjectile.Speed += PawnSpeed;
    SpawnedProjectile.Velocity = SpawnedProjectile.Speed * vector(Dir);

    // Set the remaining fuse time
    if (DHThrowableExplosiveProjectile(SpawnedProjectile) != none)
    {
        SetFuseTime = FMax(0.1, DHExplosiveWeapon(Weapon).CurrentFuzeTime);

        if (bPullAnimCompensation && HoldTime > AddedFuseTime)
        {
            SetFuseTime += AddedFuseTime;
        }

        SetFuseTime += RandRange(0.0, RANDOM_FUSE_TIME);

        DHThrowableExplosiveProjectile(SpawnedProjectile).FuzeLengthTimer = SetFuseTime;
    }

    return SpawnedProjectile;
}

// Modified to prime the explosive weapon when thrown, & also to simply play the FireAnim
function PlayFiring()
{
    if (Weapon.Mesh != none)
    {
        Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
    }

    if (DHExplosiveWeapon(Weapon) != none)
    {
        DHExplosiveWeapon(Weapon).InstantPrime();
    }

    ClientPlayForceFeedback(FireForce);
}

// Modified to prime the explosive weapon when thrown
function ServerPlayFiring()
{
    if (DHExplosiveWeapon(Weapon) != none)
    {
        DHExplosiveWeapon(Weapon).InstantPrime();
    }
}

// Implemented so explosive will blow up in player's hand if he holds a primed weapon too long
event ModeTick(float DeltaTime)
{
    local DHExplosiveWeapon Exp;

    if (Weapon.Role == ROLE_Authority)
    {
        Exp = DHExplosiveWeapon(Weapon);

        if (Exp != none && Exp.bPrimed && HoldTime > 0.0)
        {
            if (Exp.CurrentFuzeTime > (AddedFuseTime * -1.0))
            {
                Exp.CurrentFuzeTime -= DeltaTime;
            }
            else if (!Exp.bAlreadyExploded)
            {
                Exp.bAlreadyExploded = true;

                if (!bIsSmokeGrenade) // added check so a smoke grenade doesn't blows up in player's hand
                {
                    Weapon.ConsumeAmmo(ThisModeNum, Weapon.AmmoAmount(ThisModeNum));
                    DoFireEffect();
                    HoldTime = 0.0;
                }
            }
        }
    }
}

// Modified to prime the explosive weapon when held before throwing, unless it has a lever that only primes weapon when thrown
// Also to set the 'hold' animations on the player's pawn
event ModeHoldFire()
{
    if (Weapon != none && Weapon.Role == ROLE_Authority && !(DHExplosiveWeapon(Weapon) != none && DHExplosiveWeapon(Weapon).bHasReleaseLever))
    {
        DHExplosiveWeapon(Weapon).bPrimed = true;
    }

    if (ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).SetExplosiveHoldAnims(true);
    }
}

defaultproperties
{
    bTossed=true
    bFireOnRelease=true
    bWaitForRelease=true
    bShouldBlurOnFire=false
    bUsePreLaunchTrace=false
    FireRate=50.0 // set FireRate ridiculously high since we manually set the next fire time each time you bring up another explosive

    MinimumThrowSpeed=600.0
    MaximumThrowSpeed=1000.0
    SpeedFromHoldingPerSec=850.0
    AddedPitch=3000
    Spread=75.0

    PreFireAnim="Pre_Fire"
    FireAnim="Throw"
    TweenTime=0.01
    FireForce="RocketLauncherFire"

    // Bots
    bSplashDamage=true
    bRecommendSplashDamage=true
    AimError=200.0
}
