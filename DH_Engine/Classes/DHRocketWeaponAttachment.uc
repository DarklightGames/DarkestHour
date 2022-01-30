//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHRocketWeaponAttachment extends DHWeaponAttachment
    abstract;

var     mesh            EmptyMesh;       // the mesh to swap to after a round is fired

var     bool            bPanzerfaustAttachment; //Panzerfaust 3rd person muzzle flash needs to be handled differently
var     name            ExhaustBoneName;
var     class<Emitter>  mExhFlashClass;
var     Emitter         mExhFlash3rd;

// Overridden to use standard muzzle flash code for non-Panzerfaust rocket weps
simulated function PostBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer && mMuzFlashClass != none && !bPanzerfaustAttachment)
    {
        mMuzFlash3rd = Spawn(mMuzFlashClass);
        AttachToBone(mMuzFlash3rd, MuzzleBoneName);
    }
}


// Modified because the 3rd person effects are handled differently for rocket weapons
simulated event ThirdPersonEffects()
{
    if (Level.NetMode == NM_DedicatedServer || ROPawn(Instigator) == none)
    {
        return;
    }

    if (EmptyMesh != none && FiringMode == 0) // switch to empty mesh if has one & it's not a melee attack
    {
        LinkMesh(EmptyMesh);
    }

    if (FlashCount > 0 && (FiringMode == 0 || bAltFireFlash))
    {
        if ((Level.TimeSeconds - LastRenderTime) > 0.2 && PlayerController(Instigator.Controller) == none)
        {
            return;
        }

        WeaponLight();

        if (!bPanzerfaustAttachment)
        {
            mMuzFlash3rd.Trigger(self, none);
        }
        else
        {
                mMuzFlash3rd = Spawn(mMuzFlashClass);
                AttachToBone(mMuzFlash3rd, MuzzleBoneName);
        }

        if (mExhFlash3rd == none && mExhFlashClass != none && ExhaustBoneName != '')
        {
            mExhFlash3rd = Spawn(mExhFlashClass);
            AttachToBone(mExhFlash3rd, ExhaustBoneName);
        }
    }

    if (FlashCount == 0)
    {
        ROPawn(Instigator).StopFiring();
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
    bPanzerfaustAttachment=false
    bNetNotify=false // don't need to update bayonet fixing or steaming barrel for a rocket weapon
    bRapidFire=false
}
