//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
var     float   MinHoldTime;            // require weapon to be primed for a certain time before throwing

// Modified to allow player to throw explosive while prone transitioning (removes restriction in Super)
simulated function bool AllowFire()
{
    if (Level.NetMode == NM_Client && Instigator != none && Instigator.IsLocallyControlled()
        && DHExplosiveWeapon(Weapon) != none && Weapon.AmmoAmount(ThisModeNum) < DHExplosiveWeapon(Weapon).StartFireAmmoAmount)
    {
        return true;
    }

    return Weapon != none && Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire;
}

// Modified to immediately consume ammo on a net client, without waiting for a reduced ammo count to replicate
// We know if it hasn't already been reduced by comparing client's current ammo count to StartFireAmmoAmount recorded at start of fire process
// Also to set the 'hold' animations on the player's pawn, & to call PostFire() on the explosive weapon
// And to stop an already drawn back explosive from being thrown if player's weapons become locked (due to spawn killing)
event ModeDoFire()
{
    if (HoldTime < MinHoldTime)
    {
        HoldTime = 0.0;

        if (Weapon != none)
        {
            Weapon.PutDown();
            Weapon.PostFire();
        }

        return;
    }

    // Stop an already drawn back explosive from being thrown if player's weapons become locked (due to spawn killing)
    // Happens because that forces the fire button to be released, which triggers this event
    // TODO: clean this up & perhaps find a better place to do this, it's just a quick fix with some problems (Matt, Jan 2017)
    if (Instigator != none && DHPlayer(Instigator.Controller) != none && DHPlayer(Instigator.Controller).AreWeaponsLocked())
    {
        return;
    }

    super.ModeDoFire();

    // Consume ammo on the client as well, if the ammo count hasn't been net updated yet - this should prevent some of the ammo amount related lag bugs
    if (Level.NetMode == NM_Client && Instigator != none && Instigator.IsLocallyControlled() &&
        DHExplosiveWeapon(Weapon) != none && DHExplosiveWeapon(Weapon).StartFireAmmoAmount == Weapon.AmmoAmount(ThisModeNum))
    {
        Weapon.ConsumeAmmo(ThisModeNum, Load);
    }

    if (Weapon != none)
    {
        Weapon.PostFire();
    }

    if (ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).SetExplosiveHoldAnims(false);
    }
}

// Modified so if the explosive blew up in the player's hand, we kill the player if he isn't already dead
function DoFireEffect()
{
    super.DoFireEffect();

    if (!bIsSmokeGrenade && DHExplosiveWeapon(Weapon) != none && DHExplosiveWeapon(Weapon).bAlreadyExploded && ROPawn(Weapon.Instigator) != none)
    {
        ROPawn(Weapon.Instigator).KilledSelf(ProjectileClass.default.MyDamageType);
    }
}

// Modified to ignore weapon stuff like sights, bipod, etc
function CalcSpreadModifiers()
{
    local float PlayerSpeed, MovementPctModifier;

    if (Instigator != none)
    {
        // Calculate base spread based on movement speed
        PlayerSpeed = VSize(Instigator.Velocity);
        MovementPctModifier = PlayerSpeed / Instigator.default.GroundSpeed;
        Spread = (1.0 + MovementPctModifier) * default.Spread;

        // Increase the spread if you're jumping
        if (Instigator.Physics == PHYS_Falling)
        {
            Spread *= 3.0;
        }
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
                if (DHExplosiveWeapon(Weapon) != none)
                {
                    SetFuseTime = DHExplosiveWeapon(Weapon).CurrentFuzeTime;
                }

                SetFuseTime = FMax(0.1, SetFuseTime + RandRange(0.0, RANDOM_FUSE_TIME));
                DHThrowableExplosiveProjectile(SpawnedProjectile).FuzeLengthTimer = SetFuseTime;
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
    if (Weapon != none)
    {
        if (Weapon.Mesh != none && Weapon.HasAnim(FireAnim))
        {
            Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
        }

        if (Weapon.IsA('DHExplosiveWeapon'))
        {
            DHExplosiveWeapon(Weapon).InstantPrime();
        }
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

simulated function bool IsPlayerHipFiring()
{
    return false;
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
