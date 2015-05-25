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

// SHAME: this is in here because of the laziness of previous developers;
// The correct solution would be to just fix the ejection port in the model.
// Unfortunately, we don't have access to these models any more so we can't fix them.
// TODO: specify exact rotation for ejection, don't rely on "down" to be correct
var     bool    bSpawnShellsOutBottom;

// Modified to avoid spawning a barrel steam emitter - instead wait until weapon is selected
// Also to set bNetNotify on a net client if weapon type has a barrel that can overheat, so we receive PostNetReceive triggering when bBarrelSteamActive toggles
simulated function PostBeginPlay()
{
    if (mMuzFlashClass != none)
    {
        mMuzFlash3rd = Spawn(mMuzFlashClass);
        AttachToBone(mMuzFlash3rd, MuzzleBoneName);
    }

    if (Role < ROLE_Authority && bBarrelCanOverheat)
    {
        bNetNotify = true;
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

// Non-owning net clients pick up changed value of bBarrelSteamActive here & it triggers toggling the steam emitter on/off
simulated function PostNetReceive()
{
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

simulated event ThirdPersonEffects()
{
    local PlayerController   PC;
    local ROVehicleHitEffect VehEffect;

    if (Level.NetMode == NM_DedicatedServer || ROPawn(Instigator) == none)
    {
        return;
    }

    if (FiringMode == 0)
    {
        if (OldSpawnHitCount != SpawnHitCount)
        {
            OldSpawnHitCount = SpawnHitCount;
            GetHitInfo();
            PC = Level.GetLocalPlayerController();

            if ((Instigator != none && Instigator.Controller == PC) || VSize(PC.ViewTarget.Location - mHitLocation) < 4000.0)
            {
                if (mHitActor != none && (Vehicle(mHitActor) != none || ROVehicleWeapon(mHitActor) != none))
                {
                    if (Level.NetMode != NM_DedicatedServer)
                    {
                        VehEffect = Spawn(class'ROVehicleHitEffect',,, mHitLocation, rotator(-mVehHitNormal));
                        VehEffect.InitHitEffects(mHitLocation,mVehHitNormal);
                    }
                }
                else if (mHitActor == none && GetVehicleHitInfo() != none)
                {
                    GetVehicleHitInfo(); // isn't this redundant? - possibly remove

                    if (Level.NetMode != NM_DedicatedServer)
                    {
                        VehEffect = Spawn(class'ROVehicleHitEffect',,, mHitLocation, rotator(-mVehHitNormal));
                        VehEffect.InitHitEffects(mHitLocation,mVehHitNormal);
                    }
                }
                else
                {
                    Log("what");

                    Spawn(class'DHBulletHitEffect',,, mHitLocation, rotator(-mHitNormal));
                    CheckForSplash();
                }
            }
        }
    }

    if (FlashCount > 0 && ((FiringMode == 0) || bAltFireFlash))
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

defaultproperties
{
    bSpawnShellsOutBottom=false
    PA_CrouchIronBoltActionAnim=crouch_bolt_kar // for some stupid reason, crouch_boltiron_kar doesn't exist any more, so fall back to non iron-sighted version
    ROMGSteamEmitterClass=class'ROEffects.ROMGSteam'
}
