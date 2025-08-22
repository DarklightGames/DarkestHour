//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBackAttachment extends BackAttachment;

var class<InventoryAttachment>	AttachmentClass;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        AttachmentClass;
}

simulated function PostNetReceive()
{
    super.PostNetReceive();

    if (AttachmentClass != none && Mesh != AttachmentClass.default.Mesh)
    {
        LinkMesh(AttachmentClass.default.Mesh);
    }
}

// Modified to support playing the idle animation and setting skin overrides.
function InitFor(Inventory I)
{
    local int j;
    local class<DHWeaponAttachment> WA;

    super.InitFor(I);

    if (I != none)
    {
        // Replicate the inventory class so that clients can link the mesh themselves.
        // The server does not replicate the mesh here anymore because of issues with
        // packages not marked with ServerSideOnly.
        AttachmentClass = I.AttachmentClass;

        LinkMesh(AttachmentClass.default.Mesh);

        WA = class<DHWeaponAttachment>(I.AttachmentClass);

        if (WA != none)
        {
            SetRelativeLocation(WA.default.BackAttachmentLocationOffset);
            SetRelativeRotation(WA.default.BackAttachmentRotationOffset);

            if (HasAnim(WA.default.WA_Idle))
            {
                PlayAnim(WA.default.WA_Idle);
            }

            Skins.Length = 0;

            for (j = 0; j < WA.default.Skins.Length; ++j)
            {
                if (WA.default.Skins[j] != none)
                {
                    Skins[j] = WA.default.Skins[j];
                }
            }
        }
    }
}

defaultproperties
{
    bReplicateAnimations=true
    bNoRepMesh=true
    bNetNotify=true
}
