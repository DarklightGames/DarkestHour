//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHWeaponAttachment extends ROWeaponAttachment
    abstract;

var     name    PA_AssistedReloadAnim;
var     name    PA_MortarDeployAnim;
var     name    WA_MortarDeployAnim;

var     bool    bBarrelCanOverheat;

var     vector  SavedmHitLocation; // used so net client's PostNetReceive() can tell when we've received a new mHitLocation & spawn a hit effect

// SHAME: this is in here because of the laziness of previous developers;
// The correct solution would be to just fix the ejection port in the model.
// Unfortunately, we don't have access to these models any more so we can't fix them.
// TODO: specify exact rotation for ejection, don't rely on "down" to be correct
var     bool    bSpawnShellsOutBottom;

// Modified to avoid spawning a barrel steam emitter - instead wait until weapon is selected
simulated function PostBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer && mMuzFlashClass != none)
    {
        mMuzFlash3rd = Spawn(mMuzFlashClass);
        AttachToBone(mMuzFlash3rd, MuzzleBoneName);
    }
}

// Modified to remove setting bayonet & barrel variables (PostNetReceive handles it & bOldBayonetAttached is unused anyway)
simulated function PostNetBeginPlay()
{
    local DHGameReplicationInfo GRI; // TEMP DEBUG
    if (Role < ROLE_Authority && Instigator != none && Instigator.IsHumanControlled())
    {
        GRI = DHGameReplicationInfo(PlayerController(Instigator.Controller).GameReplicationInfo);
        if (GRI != none && GRI.bLogWeaponAttachment) Log(Tag @ "spawned");
    }
///////////////////////////////////////////////////////////////////////////

    super(WeaponAttachment).PostNetBeginPlay(); // skip over Super in ROWeaponAttachment

    if (ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).SetWeaponAttachment(self);
    }
}

// When new values of SpawnHitCount & mHitLocation are received, we spawn the hit effect, instead of letting ThirdPersonEffects() do it, as it does for other net modes
// That's because net client gets ThirdPersonEffects() called by native code before we have the new mHitLocation, so the effect spawns at location of last hit
// Also, non-owning net clients pick up changed value of bBarrelSteamActive here & it triggers toggling the steam emitter on/off
simulated function PostNetReceive()
{
    if (SpawnHitCount != OldSpawnHitCount && mHitLocation != SavedmHitLocation)
    {
        SavedmHitLocation = mHitLocation;
        SpawnHitEffect();
    }

    if (bBarrelSteamActive != bOldBarrelSteamActive)
    {
        bOldBarrelSteamActive = bBarrelSteamActive;
        SetBarrelSteamActive(bBarrelSteamActive);
    }
}

// Disabled as PostNetReceive is a much more efficient way of handling very occasional changes to bBarrelSteamActive
simulated function Tick(float DeltaTime)
{
    Disable('Tick');
}

// New function (replaces RO's ThirdPersonBarrelSteam), so we only spawn steam emitter when it's needed & so we have tighter control over whether it's triggered on or off
simulated function SetBarrelSteamActive(bool bSteaming)
{
    if (Role == ROLE_Authority)
    {
        bBarrelSteamActive = bSteaming; // on a server, this will replicate to each net client & trigger PostNetReceive, which calls this function on the client
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (ROMGSteamEmitter == none && bBarrelSteamActive && ROMGSteamEmitterClass != none)
        {
            ROMGSteamEmitter = Spawn(ROMGSteamEmitterClass, self);

            if (ROMGSteamEmitter != none)
            {
                AttachToBone(ROMGSteamEmitter, MuzzleBoneName);
            }
        }

        if (ROMGSteam(ROMGSteamEmitter) != none && ROMGSteam(ROMGSteamEmitter).bActive != bBarrelSteamActive)
        {
            ROMGSteamEmitter.Trigger(self, Instigator);
        }
    }
}

simulated function SpawnShells(float Frequency)
{
    local   rotator     EjectorRotation;
    local   vector      SpawnLocation;

    if (ROShellCaseClass != none &&
        Instigator != none &&
        !Instigator.IsFirstPerson())
    {
        if (default.bSpawnShellsOutBottom)
        {
            // TODO: this is technically incorrect, if gravity was up,
            // the ejection port would still be down.
            EjectorRotation = rotator(Normal(PhysicsVolume.Gravity));
        }
        else
        {
            EjectorRotation = GetBoneRotation(ShellEjectionBoneName);
        }

        SpawnLocation = GetBoneCoords(ShellEjectionBoneName).Origin;

        EjectorRotation.Pitch += Rand(1700);
        EjectorRotation.Yaw += Rand(1700);
        EjectorRotation.Roll += Rand(700);

        Spawn(ROShellCaseClass, Instigator,, SpawnLocation, EjectorRotation);
    }
}

// Modified to move functionality for spawning hit effects into a new SpawnHitEffect() function - on an authority role that's still called from here
// But for net client it gets called by PostNetReceive() when it receives updated SpawnHitCount & mHitLocation, so it knows where to spawn the effect
simulated event ThirdPersonEffects()
{
    if (Level.NetMode == NM_DedicatedServer || ROPawn(Instigator) == none)
    {
        return;
    }

    if (OldSpawnHitCount != SpawnHitCount && Role == ROLE_Authority)
    {
        SpawnHitEffect();
    }

    if (FlashCount > 0 && (FiringMode == 0 || bAltFireFlash))
    {
        if ((Level.TimeSeconds - LastRenderTime) > 0.2 && PlayerController(Instigator.Controller) == none)
        {
            return;
        }

        WeaponLight();

        if (mMuzFlash3rd != none)
        {
            mMuzFlash3rd.Trigger(self, none);
        }

        if (!bAnimNotifiedShellEjects)
        {
            SpawnShells(1.0);
        }
    }

    if (FlashCount == 0)
    {
        ROPawn(Instigator).StopFiring();

        AnimEnd(0);
    }
    else if (FiringMode == 0)
    {
        ROPawn(Instigator).StartFiring(false, bRapidFire);
    }
    else
    {
        ROPawn(Instigator).StartFiring(true, bAltRapidFire);
    }
}

// New function to spawn projectile hit effects - functionality moved here from ThirdPersonEffects(), from where it is still called on an authority role
// But for net client this gets called by PostNetReceive() when it receives updated SpawnHitCount & mHitLocation, so it knows where to spawn the effect
simulated function SpawnHitEffect()
{
    local PlayerController   PC;
    local ROVehicleHitEffect VehEffect;

    if (FiringMode == 0)
    {
        OldSpawnHitCount = SpawnHitCount;

        if (Role < ROLE_Authority) // authority roles will already have this info
        {
            GetHitInfo();
        }

        PC = Level.GetLocalPlayerController();

        if ((Instigator != none && Instigator.Controller == PC) || VSizeSquared(PC.ViewTarget.Location - mHitLocation) < 16000000.0) // squared distances for efficient processing
        {
            if (Vehicle(mHitActor) != none || ROVehicleWeapon(mHitActor) != none) // removed call to GetVehicleHitInfo(), as it's pointless & just repeats same trace as GetHitInfo()
            {
                VehEffect = Spawn(class'ROVehicleHitEffect',,, mHitLocation, rotator(-mHitNormal));
                VehEffect.InitHitEffects(mHitLocation, mHitNormal);
            }
            else
            {
                Spawn(class'DHBulletHitEffect',,, mHitLocation, rotator(-mHitNormal));
                CheckForSplash();
            }
        }
    }
}

// Modified to force a quick new update, as we really want the new mHitLocation asap, so net clients can spawn a hit effect
// Also removes setting unused & unreplicated variables on a dedicated server, & deprecates mVehHitNormal
function UpdateHit(Actor HitActor, vector HitLocation, vector HitNormal)
{
    // If by remote coincidence the hit location is identical to the last one, & we're a server, fudge the new mHitLocation to make it slightly different
    // That makes the server replicate the changed value, as bet client will only spawn hit effect if it detects a changed, replicated value of mHitLocation
    if (HitLocation == mHitLocation && Level.NetMode != NM_Standalone)
    {
        mHitLocation = HitLocation + vect(0.0, 0.0, 1.0);
    }
    else
    {
        mHitLocation = HitLocation;
    }

    SpawnHitCount++;
    NetUpdateTime = Level.TimeSeconds - 1.0;

    if (Level.NetMode != NM_DedicatedServer)
    {
        mHitActor = HitActor;
        mHitNormal = HitNormal;
//      mVehHitNormal = HitNormal; // pointless, just use mHitNormal
    }
}

// Modified to use bTraceActors option in the trace (making GetVehicleHitInfo() redundant), to use MuzzleBone location for more accurate trace,
// to handle new collision mesh actor, to remove pointlessly setting NetUpdateTime on net client,
// & to skip function on any authority role & not just standalone (listen server will also already have the info)
simulated function GetHitInfo()
{
    local vector Offset, HitLocation;

    if (Role < ROLE_Authority)
    {
        Offset = 20.0 * Normal(GetBoneCoords(MuzzleBoneName).Origin - mHitLocation);
        mHitActor = Trace(HitLocation, mHitNormal, mHitLocation - Offset, mHitLocation + Offset, true);

        // If hit a collision mesh actor, we switch mHitActor to col mesh's owner & proceed as if we'd hit that actor
        if (DHCollisionMeshActor(mHitActor) != none)
        {
            if (DHCollisionMeshActor(mHitActor).bWontStopBullet)
            {
                mHitActor = none;

                return; // exit, doing nothing, if col mesh actor is set not to stop a bullet
            }

            mHitActor = mHitActor.Owner;
        }

        // Debug option - draws a line representing the trace (enabled if DHBullet.bDebugROBallistics is set true in config file or in bullet's default properties)
        if (Instigator != none && Instigator.Weapon != none && class<DHBullet>(Instigator.Weapon.default.FireModeClass[0].default.ProjectileClass) != none
            && class<DHBullet>(Instigator.Weapon.default.FireModeClass[0].default.ProjectileClass).default.bDebugROBallistics)
        {
            Log(Tag $ ".GetHitInfo: traced mHitActor =" @ mHitActor);
            ClearStayingDebugLines();

            if (mHitActor != none)
            {
                DrawStayingDebugLine(mHitLocation + Offset, HitLocation, 0, 255, 0); // green, hit something
            }
            else
            {
                DrawStayingDebugLine(mHitLocation + Offset, mHitLocation - Offset, 255, 0, 0); // red, hit nothing
            }
        }
    }
}

// Emptied out as deprecated
simulated function Actor GetVehicleHitInfo()
{
    return none;
}

simulated function Hide(bool NewbHidden) // TEMP DEBUG
{
    bHidden = NewbHidden;
    if (Instigator != none && DHPlayer(Instigator.Controller) != none && DHPlayer(Instigator.Controller).bLogWeaponAttachment) Log(Tag @ "Hide setting bHidden =" @ bHidden);
}

defaultproperties
{
    bNetNotify=true
    bSpawnShellsOutBottom=false
    ROMGSteamEmitterClass=class'ROEffects.ROMGSteam'
}
