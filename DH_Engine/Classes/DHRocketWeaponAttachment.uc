//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHRocketWeaponAttachment extends DHWeaponAttachment
    abstract;

var           bool bHideWarheadWhenFired;
var           bool bWarheadVisible;
var           name WarheadBoneName;
var           int  WarheadScaleSlot; // Slot holding the scalar values for the warhead bone
var           Mesh EmptyMesh;        // TODO: EmptyMesh is kept for backwards compatibility. Deprecate this when possible!

var bool           bPanzerfaustAttachment; // Panzerfaust 3rd person muzzle flash needs to be handled differently
var name           ExhaustBoneName;
var class<Emitter> mExhFlashClass;
var Emitter        mExhFlash3rd;

// HACK: Fixes the issue where warhead is incorrectly shown when the weapon is pulled out.
var     bool    bInitiallyLoaded;

replication
{
    reliable if (bHideWarheadWhenFired && bNetDirty && Role == ROLE_Authority)
        bWarheadVisible;
}

// Overridden to use standard muzzle flash code for non-Panzerfaust rocket weps
simulated function PostBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer && mMuzFlashClass != none && !bPanzerfaustAttachment)
    {
        mMuzFlash3rd = Spawn(mMuzFlashClass);
        AttachToBone(mMuzFlash3rd, MuzzleBoneName);
    }

    if (bHideWarheadWhenFired)
    {
        bWarheadVisible = bInitiallyLoaded;
        ShowWarhead(bInitiallyLoaded);
    }
}

simulated function PostNetReceive()
{
    super.PostNetReceive();

    if (bHideWarheadWhenFired && bWarheadVisible == bOutOfAmmo)
    {
        ShowWarhead(bWarheadVisible);
    }
}

simulated function ShowWarhead(bool bShow)
{
    local Mesh NewMesh;

    if (EmptyMesh != none)
    {
        // TODO: EmptyMesh is kept for backwards compatibility. Deprecate this when possible!
        if (bShow)
        {
            NewMesh = default.Mesh;
        }
        else
        {
            NewMesh = EmptyMesh;
        }

        if (NewMesh != Mesh)
        {
            LinkMesh(NewMesh);
        }
    }
    else
    {
        if (WarheadBoneName != '')
        {
            SetBoneScale(WarheadScaleSlot, float(bShow), WarheadBoneName);
        }
        else
        {
            Warn("Failed to scale the warhead bone: WarheadBoneName is empty!");
        }
    }
}

// Modified because the 3rd person effects are handled differently for rocket weapons
simulated event ThirdPersonEffects()
{
    if (Level.NetMode == NM_DedicatedServer || ROPawn(Instigator) == none)
    {
        return;
    }

    if (bHideWarheadWhenFired && FiringMode == 0)
    {
        ShowWarhead(false);
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
    bRapidFire=false
}
