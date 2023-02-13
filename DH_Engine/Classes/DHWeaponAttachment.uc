//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHWeaponAttachment extends ROWeaponAttachment
    abstract;

var     name        PA_MortarDeployAnim;
var     name        WA_MortarDeployAnim;

var     name        PA_AssistedReloadAnim;
var     name        PA_ProneAssistedReloadAnim;
var     name        PA_CrouchReloadAnim;
var     name        PA_CrouchReloadEmptyAnim;
var     name        WA_CrouchReload;
var     name        WA_CrouchReloadEmpty;
var     name        WA_BayonetCrouchReload;
var     name        WA_BayonetCrouchReloadEmpty;

var     bool        bStaticReload; // Reload animations will take over the
                                   // entire body (useful for deployed weapons).

var     vector      SavedmHitLocation; // used so net client's PostNetReceive() can tell when we've received a new mHitLocation & spawn a hit effect

// SHAME: this is in here because of the laziness of previous developers;
// The correct solution would be to just fix the ejection port in the model.
// Unfortunately, we don't have access to these models any more so we can't fix them.
// TODO: specify exact rotation for ejection, don't rely on "down" to be correct
var     bool    bSpawnShellsOutBottom;

// Mesh offsets for when the weapon is on the back.
var     vector  BackAttachmentLocationOffset;
var     rotator BackAttachmentRotationOffset;

// Modified to actual use the muzzle bone name instead of a hard-coded "tip" bone
simulated function vector GetTipLocation()
{
    local Coords C;
    C = GetBoneCoords(MuzzleBoneName);
    return C.Origin;
}

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
    super(WeaponAttachment).PostNetBeginPlay(); // skip over Super in ROWeaponAttachment

    if (ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).SetWeaponAttachment(self);
    }
}

// Modified so we spawn the hit effects from a replicated pre-launch trace, when a changed value of mHitLocation is received
// Now doing this here instead of letting ThirdPersonEffects() do it, as it does for other net modes, to solve a bug
// Net client gets ThirdPersonEffects() called by native code before we have the new mHitLocation, so the effect used to spawn at the location of the last hit!
// Also modified so non-owning net clients pick up changed value of bBarrelSteamActive here & it triggers toggling the steam emitter on/off
simulated function PostNetReceive()
{
    // Have deprecated use of replicated byte SpawnHitCount, which used to trigger hit effects, as changing mHitLocation is enough & any more is wasted replication
    if (mHitLocation != SavedmHitLocation)
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

    if (ROShellCaseClass != none && ShellEjectionBoneName != '' && Instigator != none && !Instigator.IsFirstPerson())
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
    local DHVehicleHitEffect VehEffect;

    OldSpawnHitCount = SpawnHitCount;

    GetHitInfo(); // authority roles will already have this info & only access a debug option here

    PC = Level.GetLocalPlayerController();

    // Check effect is relevant to player - must either be the local player who fired, or effect would be within a set distance for other players
    // Using squared distances for efficient processing of distance check (equivalent to 4000 units or 66m)
    if ((Instigator != none && Instigator.Controller == PC) || VSizeSquared(PC.ViewTarget.Location - mHitLocation) < 16000000.0)
    {
        if (Vehicle(mHitActor) != none || ROVehicleWeapon(mHitActor) != none) // removed call to GetVehicleHitInfo(), as it's pointless & just repeats same trace as GetHitInfo()
        {
            VehEffect = Spawn(class'DHVehicleHitEffect',,, mHitLocation, rotator(-mHitNormal));
            VehEffect.InitHitEffects(mHitLocation, mHitNormal);
        }
        else
        {
            Spawn(class'DHBullet'.default.ImpactEffect,,, mHitLocation, rotator(-mHitNormal));
            CheckForSplash();
        }
    }
}

// Modified to play water splash sound, & to use pawn's eye position as trace start as it's much closer to bullet's spawn location than pawn's location (strangely, even when hip firing)
simulated function CheckForSplash()
{
    local Actor  HitActor;
    local vector HitLocation, HitNormal;

    // No splash if detail settings are low, or if projectile is already in a water volume
    if (Level.Netmode != NM_DedicatedServer && !Level.bDropDetail && Level.DetailMode != DM_Low && Instigator != none
        && !(Instigator.PhysicsVolume != none && Instigator.PhysicsVolume.bWaterVolume))
    {
        // Trace to see if bullet hits water - from firing point to end hit location, because bullet may splash in water in between
        bTraceWater = true;
        HitActor = Trace(HitLocation, HitNormal, mHitLocation, Instigator.Location + Instigator.EyePosition(), true);
        bTraceWater = false;

        // We hit a water volume or a fluid surface, so play splash effects
        if ((PhysicsVolume(HitActor) != none && PhysicsVolume(HitActor).bWaterVolume) || FluidSurfaceInfo(HitActor) != none)
        {
            PlaySound(class'DHBullet'.default.WaterHitSound);

            if (SplashEffect != none && EffectIsRelevant(HitLocation, false))
            {
                Spawn(SplashEffect,,, HitLocation, rot(16384, 0, 0));
            }
        }
    }
}

// Modified to force a quick new update, as we really want the new mHitLocation asap, so net clients can spawn a hit effect
// And have deprecated use of replicated byte SpawnHitCount, which used to trigger hit effects, as changing mHitLocation is enough & any more is wasted replication
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

    //SpawnHitCount++; // unnecessary replication (changing mHitLocation is enough)
    NetUpdateTime = Level.TimeSeconds - 1.0;

    if (Level.NetMode != NM_DedicatedServer)
    {
        mHitActor = HitActor;
        mHitNormal = HitNormal;
//      mVehHitNormal = HitNormal; // pointless, just use mHitNormal

        // Little trick to make single player or listen server spawn hit effects, since we are no longer incrementing SpawnHitCount & they check old vs new values
        OldSpawnHitCount++;
    }
}

// Modified to use bTraceActors option in the trace (making GetVehicleHitInfo() redundant),
// to use pawn's eye position as trace start as it's much closer to bullet's spawn location than pawn's location (strangely, even when hip firing)
// to handle new collision mesh actor, to remove pointlessly setting NetUpdateTime on net client, to add a debug option,
// & to skip function on any authority role & not just standalone (listen server will also already have the info)
simulated function GetHitInfo()
{
    local vector Offset, HitLocation;

    if (Role < ROLE_Authority && Instigator != none)
    {
        // Do a very short trace spanning the replicated hit location, to check what type of object we hit, so we know what hit effect to spawn
        Offset = 20.0 * Normal((Instigator.Location + Instigator.EyePosition()) - mHitLocation);
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
    }

    // Debug option - draws a line representing the trace
    if (class'DHBullet'.default.bDebugROBallistics)
    {
        Log(Tag $ ".GetHitInfo: traced mHitActor =" @ mHitActor);
        ClearStayingDebugLines();

        if (Role == ROLE_Authority) // single player or listen server will have won't have calculated these above & needs them to draw debug lines
        {
            HitLocation = mHitLocation;
            Offset = 20.0 * Normal(mHitLocation - (Instigator.Location + Instigator.EyePosition()));
        }

        if (mHitActor != none)
        {
            DrawStayingDebugLine(mHitLocation - Offset, HitLocation, 0, 255, 0); // green, hit something
        }
        else
        {
            DrawStayingDebugLine(mHitLocation - Offset, mHitLocation + Offset, 255, 0, 0); // red, hit nothing
        }
    }
}

// Emptied out as deprecated
simulated function Actor GetVehicleHitInfo()
{
    return none;
}

// Modified to fix UT2004 bug affecting non-owning net players in any vehicle with bPCRelativeFPRotation (nearly all), often causing effects to be skipped
// Vehicle's rotation was not being factored into calcs using the PlayerController's rotation, which effectively randomised the result of this function
// Also re-factored to make it a little more optimised, direct & easy to follow (without repeated use of bResult)
simulated function bool EffectIsRelevant(vector SpawnLocation, bool bForceDedicated)
{
    local PlayerController PC;

    // Only relevant on a dedicated server if the bForceDedicated option has been passed
    if (Level.NetMode == NM_DedicatedServer)
    {
        return bForceDedicated;
    }

    // Always relevant for the owning net player, i.e. the player that fired the projectile
    if (Role < ROLE_Authority && Instigator != none && Instigator.IsHumanControlled())
    {
        return true;
    }

    PC = Level.GetLocalPlayerController();

    if (PC == none || PC.ViewTarget == none)
    {
        return false;
    }

    // Check to see whether effect would spawn off to the side or behind where player is facing, & if so then only spawn if within quite close distance
    // Using PC's CalcViewRotation, which is the last recorded camera rotation, so a simple way of getting player's non-relative view rotation, even in vehicles
    // (doesn't apply to the player that fired the projectile)
    if (PC.Pawn != Instigator && vector(PC.CalcViewRotation) dot (SpawnLocation - PC.ViewTarget.Location) < 0.0)
    {
        return VSizeSquared(PC.ViewTarget.Location - SpawnLocation) < 2560000.0; // equivalent to 1600 UU or 26.5m (changed to VSizeSquared as more efficient)
    }

    // Effect relevance is based on normal distance check
    return CheckMaxEffectDistance(PC, SpawnLocation);
}

// Emptied out as is never called in RO/DHBullet
// In the unused 'XPawn' class it was called in PlayTakeHit() function, but in ROPawn Ramm removed that call, commenting "this doesn't really fit our system")
simulated function PlayDirectionalHit(Vector HitLoc)
{
}

simulated function PlayIdle()
{
    if (bBayonetAttached)
    {
        if (bOutOfAmmo && WA_BayonetIdleEmpty != '')
        {
            LoopAnim(WA_BayonetIdleEmpty);
        }
        else if (WA_BayonetIdle != '')
        {
            LoopAnim(WA_BayonetIdle);
        }
    }
    else
    {
        if (bOutOfAmmo && WA_IdleEmpty != '')
        {
            LoopAnim(WA_IdleEmpty);
        }
        else if (WA_Idle != '')
        {
            LoopAnim(WA_Idle);
        }
    }
}

simulated function name GetReloadPlayerAnim(DHPawn Pawn)
{
    if (Pawn == none)
    {
        return '';
    }

    if (bOutOfAmmo)
    {
        if (Pawn.bIsCrawling)
        {
            return PA_ProneReloadEmptyAnim;
        }
        else if (Pawn.bIsCrouched && PA_CrouchReloadEmptyAnim != '')
        {
            return PA_CrouchReloadEmptyAnim;
        }
        else
        {
            return PA_ReloadEmptyAnim;
        }
    }
    else
    {
        if (Pawn.bIsCrawling)
        {
            return PA_ProneReloadAnim;
        }
        else if (Pawn.bIsCrouched && PA_CrouchReloadAnim != '')
        {
            return PA_CrouchReloadAnim;
        }
        else
        {
            return PA_ReloadAnim;
        }
    }
}

simulated function name GetReloadWeaponAnim(DHPawn Pawn)
{
    if (Pawn == none)
    {
        return '';
    }

    if (bBayonetAttached)
    {
        if (Pawn.bIsCrawling)
        {
            if (bOutOfAmmo && WA_BayonetProneReloadEmpty != '')
            {
                return WA_BayonetProneReloadEmpty;
            }
            else
            {
                return WA_BayonetProneReload;
            }
        }
        else if (Pawn.bIsCrouched && (WA_BayonetCrouchReloadEmpty != '' || WA_BayonetCrouchReload != ''))
        {
            if (bOutOfAmmo && WA_BayonetCrouchReloadEmpty != '')
            {
                return WA_BayonetCrouchReloadEmpty;
            }
            else
            {
                return WA_BayonetCrouchReload;
            }
        }
        else
        {
            if (bOutOfAmmo && WA_BayonetReloadEmpty != '')
            {
                return WA_BayonetReloadEmpty;
            }
            else
            {
                return WA_BayonetReload;
            }
        }
    }
    else
    {
        if (Pawn.bIsCrawling)
        {
            if (bOutOfAmmo && WA_ProneReloadEmpty != '')
            {
                return WA_ProneReloadEmpty;
            }
            else
            {
                return WA_ProneReload;
            }
        }
        else if (Pawn.bIsCrouched && (WA_CrouchReloadEmpty != '' || WA_CrouchReload != ''))
        {
            if (bOutOfAmmo && WA_CrouchReloadEmpty != '')
            {
                return WA_CrouchReloadEmpty;
            }
            else
            {
                return WA_CrouchReload;
            }
        }
        else
        {
            if (bOutOfAmmo && WA_ReloadEmpty != '')
            {
                return WA_ReloadEmpty;
            }
            else
            {
                return WA_Reload;
            }
        }
    }
}

defaultproperties
{
    // Changed as bOnlyDirtyReplication should only be used with actors that are bAlwaysRelevant & it causes problems here
    // When true with a weapon attachment, it causes a bug where often the actor fails to be destroyed when the holding player stops being net relevant & is destroyed
    // This 'orphaned' actor is no longer attached, then when the player becomes relevant again, his weapon attachment is not re-replicated & so continues to exist
    // The orphaned attachment does not regain its Base actor (or Instigator or Owner, all of which should be the player pawn), so it stays unattached
    // It cannot be seen because weapon attachments are bOnlyDrawIfAttached, so the viewer sees the player holding no weapon
    bOnlyDirtyReplication=false

    CullDistance=8192.0 // 136m - was originally 4000 UU (approx 66m), but when the 3rd person weapon attachment gets culled, player's can't see a muzzle flash, which is important
    bNetNotify=true
    bSpawnShellsOutBottom=false
    ROMGSteamEmitterClass=class'DH_Effects.DHMGSteam'
    SplashEffect=class'DHBulletHitWaterEffect'

    // Override player hit anims from ROWeaponAttachment that don't exist & aren't used anyway
    // Would only get used in ROPawn's PlayDirectionalHit() function, which is never called in RO (Ramm removed the call, commenting "this doesn't really fit our system")
    PA_HitFAnim=""
    PA_HitBAnim=""
    PA_HitLAnim=""
    PA_HitRAnim=""
    PA_HitLLegAnim=""
    PA_HitRLegAnim=""
    PA_CrouchHitUpAnim=""
    PA_CrouchHitDownAnim=""
    PA_ProneHitAnim=""

    // Override player limping movement anims inherited from ROWeaponAttachment that don't exist & don't appear to be used anyway
    // Possible they're used in native code (as with some other movement anims), but even if so that code must be doing HasAnim() checks as we get no log errors
    PA_LimpAnims(0)=""
    PA_LimpAnims(1)=""
    PA_LimpAnims(2)=""
    PA_LimpAnims(3)=""
    PA_LimpAnims(4)=""
    PA_LimpAnims(5)=""
    PA_LimpAnims(6)=""
    PA_LimpAnims(7)=""
    PA_LimpIronAnims(0)=""
    PA_LimpIronAnims(1)=""
    PA_LimpIronAnims(2)=""
    PA_LimpIronAnims(3)=""
    PA_LimpIronAnims(4)=""
    PA_LimpIronAnims(5)=""
    PA_LimpIronAnims(6)=""
    PA_LimpIronAnims(7)=""

    // Override player movement anims inherited from ROWeaponAttachment that don't exist
    PA_MovementAnims(0)="stand_jogF_kar"
    PA_MovementAnims(1)="stand_jogB_kar"
    PA_MovementAnims(2)="stand_jogL_kar"
    PA_MovementAnims(3)="stand_jogR_kar"
    PA_MovementAnims(4)="stand_jogFL_kar"
    PA_MovementAnims(5)="stand_jogFR_kar"
    PA_MovementAnims(6)="stand_jogBL_kar"
    PA_MovementAnims(7)="stand_jogBR_kar"

    PA_SprintAnims(0)="stand_sprintF_kar"
    PA_SprintAnims(1)="stand_sprintB_kar"
    PA_SprintAnims(2)="stand_sprintL_kar"
    PA_SprintAnims(3)="stand_sprintR_kar"
    PA_SprintAnims(4)="stand_sprintFL_kar"
    PA_SprintAnims(5)="stand_sprintFR_kar"
    PA_SprintAnims(6)="stand_sprintBL_kar"
    PA_SprintAnims(7)="stand_sprintBR_kar"

    PA_WalkIronAnims(0)="stand_walkFiron_kar"
    PA_WalkIronAnims(1)="stand_walkBiron_kar"
    PA_WalkIronAnims(2)="stand_walkLiron_kar"
    PA_WalkIronAnims(3)="stand_walkRiron_kar"
    PA_WalkIronAnims(4)="stand_walkFLiron_kar"
    PA_WalkIronAnims(5)="stand_walkFRiron_kar"
    PA_WalkIronAnims(6)="stand_walkBLiron_kar"
    PA_WalkIronAnims(7)="stand_walkBRiron_kar"

    PA_IdleRestAnim="stand_idlehip_kar"
    PA_IdleWeaponAnim="stand_idlehip_kar"
    PA_IdleIronRestAnim="stand_idleiron_kar"
    PA_IdleIronWeaponAnim="stand_idleiron_kar"

    PA_StandToProneAnim="StandtoProne_kar"
}
