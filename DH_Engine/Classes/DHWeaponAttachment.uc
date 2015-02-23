//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHWeaponAttachment extends ROWeaponAttachment
    abstract;

var()   name    PA_AssistedReloadAnim;
var()   name    PA_MortarDeployAnim;
var()   name    WA_MortarDeployAnim;

simulated event ThirdPersonEffects()
{
    local PlayerController   PC;
    local ROVehicleHitEffect VehEffect;

    if (Level.NetMode == NM_DedicatedServer || ROPawn(Instigator) == none)
    {
        return;
    }

    // New Trace FX - Ramm
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
                    Spawn(class'DH_BulletHitEffect',,, mHitLocation, rotator(-mHitNormal));
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
    //for some stupid reason, crouch_boltiron_kar doesn't exist anymore;
    //fall back to non iron-sighted version
    PA_CrouchIronBoltActionAnim=crouch_bolt_kar
}
