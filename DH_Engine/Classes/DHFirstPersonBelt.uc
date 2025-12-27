//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// This is for a first person belt (i.e. cloth belt) for mounted machine guns.
// This handles 
//==============================================================================

class DHFirstPersonBelt extends Actor
    abstract
    notplaceable;

// We need a system for individual shot animations and then a set of anims to
// pull from for the "loop", maybe like 4-8 anims of the same shot happening
var array<name>                         BulletBoneNames;
var Class<ROFPAmmoRound>                BulletClass;
var array<name>                         FireSequenceNames;

var int                                 BulletCount;
var array<ROFPAmmoRound>                Bullets;

function PostBeginPlay()
{
    super.PostBeginPlay();

    SpawnBullets();
}

function SpawnBullets()
{
    local int i;
    local string BoneName;

    DestroyBullets();

    Bullets.Length = BulletBoneNames.Length;

    for (i = 0; i < BulletBoneNames.Length; ++i)
    {
        Bullets[i] = Spawn(BulletClass, Owner);

        if (Bullets[i] == none)
        {
            continue;
        }

        AttachToBone(Bullets[i], BulletBoneNames[i]);
        SetRelativeLocation(vect(0, 0, 0));
        SetRelativeRotation(rot(0, 0, 0));
    }
}

function DestroyBullets()
{
    local int i;

    for (i = 0; i < Bullets.Length; ++i)
    {
        if (Bullets[i] != none)
        {
            Bullets[i].Destroy();
        }
    }

    Bullets.Length = 0;
}

function Destroyed()
{
    super.Destroyed();
    
    DestroyBullets();
}

function int FreezeAnimAtAmmoCount(int AmmoCount)
{
    local int SequenceIndex;

    SequenceIndex = GetSequenceIndexForAmmoCount(AmmoCount);

    PlayAnim(FireSequenceNames[SequenceIndex]);
    FreezeAnimAt(0.0);
    UpdateBullets(SequenceIndex);
}

function int GetSequenceIndexForAmmoCount(int AmmoCount)
{
    local int Index, C;

    Index = self.BulletCount - AmmoCount;

    // First shot will have 250 rounds. First index comes in as 0.
    const A = 16;
    const B = 4;

    C = self.BulletCount - A;

    // If the Index is between B and C, just cycle through the next B animations.
    // If it's after C, then play the last animations.
    if (Index >= A && Index < C)
    {
        Index = A + ((Index - A) % B);
    }
    // Go through the last A animations starting at C.
    else if (Index >= C)
    {
        Index = FireSequenceNames.Length - AmmoCount;
    }

    return Clamp(Index, 0, FireSequenceNames.Length - 1);
}

function PlayFiringAnimation(int AmmoCount)
{
    local int SequenceIndex;

    SequenceIndex = GetSequenceIndexForAmmoCount(AmmoCount);

    UpdateBullets(SequenceIndex);
    PlayAnim(FireSequenceNames[SequenceIndex]);
}

function UpdateBullets(int SequenceIndex)
{
    local int i;

    for (i = 0; i < Bullets.Length; ++i)
    {
        if (Bullets[i] == none)
        {
            continue;
        }

        Bullets[i].bHidden = i <= SequenceIndex;
    }
}

defaultproperties
{
    DrawType=DT_Mesh
    bOnlyOwnerSee=True
    bOnlyDrawIfAttached=True
    RemoteRole=ROLE_None
}
