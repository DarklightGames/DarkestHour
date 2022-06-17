//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================
// Sets the draw scale of a bone and its children

class DHAnimNotify_SetBoneScale extends AnimNotify_Scripted;

var() int   Slot;      // Actors can have multiple slots to store scalars in.
                       // If a bone has multiple scalars (stored in different
                       // slots), its scalars are multiplied.

var() float BoneScale;
var() name  BoneName;

event Notify(Actor Owner)
{
    if (Owner != none)
    {
        Owner.SetBoneScale(Slot, BoneScale, BoneName);
    }
}
