//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ClientMaterialTrigger extends MaterialTrigger;

enum ETriggerAction
{
    TR_DoesNothing,
    TR_Triggers,
    TR_Resets
};

var(MaterialTrigger)    ETriggerAction  TriggerAction;   // whether triggering resets or triggers the materials
var(MaterialTrigger)    ETriggerAction  UntriggerAction; // whether un-triggering resets or triggers the materials

var  array<DH_MaterialTriggerReplicationInfo>   ReplicatedMaterialTriggers; // array holding the ReplicationInfos for clientside triggering

// Modified to spawn & set up a MaterialTriggerReplicationInfo for each triggered material
function PostBeginPlay()
{
    local int i;

    for (i = 0; i < MaterialsToTrigger.Length; ++i)
    {
        ReplicatedMaterialTriggers[i] = Spawn(class'DH_MaterialTriggerReplicationInfo', self);

        if (ReplicatedMaterialTriggers[i] != none)
        {
            ReplicatedMaterialTriggers[i].SetMaterialToTrigger(string(MaterialsToTrigger[i]));
        }
    }
}

// Modified to trigger or reset all the materials, depending on the specified TriggerAction property
function Trigger(Actor Other, Pawn EventInstigator)
{
    if (Other == none)
    {
        Other = self;
    }

    if (TriggerAction == TR_Triggers)
    {
        TriggerMaterials(Other, EventInstigator);
    }
    else if (TriggerAction == TR_Resets)
    {
        ResetMaterials();
    }
}

// Modified to trigger or reset all the materials, depending on the specified UntriggerAction property
function Untrigger(Actor Other, Pawn EventInstigator)
{
    if (Other == none)
    {
        Other = self;
    }

    if (UntriggerAction == TR_Triggers)
    {
        TriggerMaterials(Other, EventInstigator);
    }
    else if (UntriggerAction == TR_Resets)
    {
        ResetMaterials();
    }
}

// New function to trigger all the ReplicatedMaterialTriggers, passing them the Triggerer & EventInstigator
function TriggerMaterials(Actor Other, Pawn EventInstigator)
{
    local int i;

    for (i = 0; i < ReplicatedMaterialTriggers.Length; ++i)
    {
        if (ReplicatedMaterialTriggers[i] != none)
        {
            ReplicatedMaterialTriggers[i].TriggerMaterial(Other, EventInstigator);
        }
    }
}

// New function to reset all the ReplicatedMaterialTriggers
function ResetMaterials()
{
    local int i;

    for (i = 0; i < ReplicatedMaterialTriggers.Length; ++i)
    {
        if (ReplicatedMaterialTriggers[i] != none)
        {
            ReplicatedMaterialTriggers[i].ResetMaterial();
        }
    }
}

/*
simulated function Reset() // TODO: fix
{
    super.Reset();
}
*/

defaultproperties
{
    TriggerAction=TR_Triggers
    UntriggerAction=TR_DoesNothing
}
