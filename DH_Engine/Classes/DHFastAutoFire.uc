//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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

// Modified to support packing two shots together to save net bandwidth
// The high rate of fire system packs shots together, replicates the shot info to net clients & then they spawn their own client bullets
// Bullet actor replication is disabled
function Projectile SpawnProjectile(vector Start, rotator Dir)
{
    local Projectile SpawnedProjectile;

    // Start by spawning the projectile as normal
    SpawnedProjectile = super.SpawnProjectile(Start, Dir);

    if (Level.NetMode == NM_Standalone)
    {
        return SpawnedProjectile; // remaining network stuff isn't relevant to single player
    }

    // Stop a server from replicating the bullet actor to net clients
    if (DHBullet(SpawnedProjectile) != none)
    {
        DHBullet(SpawnedProjectile).SetAsServerBullet();
    }

    // Update the weapon attachment's packed shot info, which gets replicated to net clients, causing them to spawn their own bullets
    if (HiROFWeaponAttachment == none && Weapon != none)
    {
        HiROFWeaponAttachment = DHHighROFWeaponAttachment(Weapon.ThirdPersonActor);
    }

    if (HiROFWeaponAttachment != none)
    {
        if (Level.TimeSeconds - LastCalcTime > PackingThresholdTime)
        {
            HiROFWeaponAttachment.LastShot = HiROFWeaponAttachment.MakeShotInfo(Start, Dir);
            HiROFWeaponAttachment.bUnReplicatedShot = true;
        }
        else if (HiROFWeaponAttachment.bFirstShot)
        {
            HiROFWeaponAttachment.LastShot = HiROFWeaponAttachment.MakeShotInfo(Start, Dir);
            HiROFWeaponAttachment.bFirstShot = false;
            HiROFWeaponAttachment.bUnReplicatedShot = true;
        }
        else
        {
            HiROFWeaponAttachment.SavedDualShot.FirstShot = HiROFWeaponAttachment.LastShot;
            HiROFWeaponAttachment.SavedDualShot.Secondshot = HiROFWeaponAttachment.MakeShotInfo(Start, Dir);
            HiROFWeaponAttachment.bFirstShot = true;

            if (HiROFWeaponAttachment.DualShotCount < 254) // skip 255 as we will use it for a special trigger
            {
                HiROFWeaponAttachment.DualShotCount ++;
            }
            else
            {
                HiROFWeaponAttachment.DualShotCount = 1;
            }

            HiROFWeaponAttachment.NetUpdateTime = Level.TimeSeconds - 1.0;

            HiROFWeaponAttachment.bUnReplicatedShot = false;
        }
    }

    LastCalcTime = Level.TimeSeconds;

    return SpawnedProjectile;
}

// Implemented to send the fire class to the looping state
function StartFiring()
{
    GotoState('FireLoop');
}

// New function to handles toggling the weapon attachment's ambient sound on & off
function PlayAmbientSound(sound aSound)
{
    local WeaponAttachment WA;

    if (Weapon != none)
    {
        WA = WeaponAttachment(Weapon.ThirdPersonActor);
    }

    if (WA != none)
    {
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
}

// Make sure we are in the fire looping state when we fire
event ModeDoFire()
{
    if (ROWeapon(Owner) != none && !ROWeapon(Owner).IsBusy() && AllowFire() && (IsInState('FireLoop') || bWaitForRelease))
    {
        super.ModeDoFire();
    }
}

// New state to handle looping the firing animations & ambient fire sounds as well as firing rounds
state FireLoop
{
    function BeginState()
    {
        local name Anim;

        NextFireTime = Level.TimeSeconds - 0.1; // fire now!

        if (Weapon != none && Weapon.Mesh != none)
        {
            if (!IsPlayerHipFiring())
            {
                if (Weapon.HasAnim(BipodDeployFireLoopAnim) && Instigator != none && Instigator.bBipodDeployed)
                {
                    Anim = BipodDeployFireLoopAnim;
                }
                else if (Weapon.HasAnim(FireIronLoopAnim))
                {
                    Anim = FireIronLoopAnim;
                }
            }

            if (Anim != '')
            {
                Weapon.LoopAnim(Anim, IronLoopFireAnimRate, 0.0);
            }
            else if (Weapon.HasAnim(FireLoopAnim))
            {
                Weapon.LoopAnim(FireLoopAnim, LoopFireAnimRate, 0.0);
            }
        }

        PlayAmbientSound(AmbientFireSound);
    }

    // Emptied out because we play an ambient fire sound
    function PlayFiring() { }
    function ServerPlayFiring() { }

    function EndState()
    {
        PlayAmbientSound(none);

        if (Weapon != none)
        {
            Weapon.AnimStopLooping();
            Weapon.PlayOwnedSound(FireEndSound, SLOT_None, FireVolume,, AmbientFireSoundRadius);
            Weapon.StopFire(ThisModeNum);

            if (!Weapon.IsInState('LoweringWeapon') && Weapon.IsA('ROWeapon'))
            {
                ROWeapon(Weapon).GotoState('Idle'); // if we are not switching weapons, go to the idle state
            }
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

            HiROFWeaponAttachment.NetUpdateTime = Level.TimeSeconds - 1.0;
        }

        GotoState('');
    }

    // Modified to make sure we leave this state if weapon has stopped firing, or the magazine is empty, or barrel has failed due to overheating
    function ModeTick(float DeltaTime)
    {
        super(WeaponFire).ModeTick(DeltaTime);

        if (!bIsFiring || (ROWeapon(Weapon) != none && ROWeapon(Weapon).IsBusy()) || !AllowFire() || (DHProjectileWeapon(Weapon) != none && DHProjectileWeapon(Weapon).bBarrelFailed))
        {
            GotoState('');
        }
    }
}

function float MaxRange()
{
    return 4500.0; // about 75 meters
}

defaultproperties
{
    PackingThresholdTime=0.1
    MaxVerticalRecoilAngle=300
    MaxHorizontalRecoilAngle=90
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_smg'
    AmbientFireVolume=255
    AmbientFireSoundRadius=750.0
    PreFireAnim="Shoot1_start"
    LoopFireAnimRate=1.0
    IronLoopFireAnimRate=1.0
}
