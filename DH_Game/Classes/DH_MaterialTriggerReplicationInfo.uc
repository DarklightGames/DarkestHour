//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_MaterialTriggerReplicationInfo extends ReplicationInfo;

var     material    MaterialToTrigger;
var     string      MaterialName;
var     int         ClientTriggerCount;
var     int         ClientUnTriggerCount;
var     int         TriggerCount;

var struct TTriggerData
{
    var Actor       Triggerer;
    var Pawn        EventInstigator;
    var byte        TriggerAction; // 0 = nothing/idle, 1 = trigger, 2 = reset
} LastTriggerings[10];

replication
{
    // Variables the server will replicate to all clients
    reliable if (Role == ROLE_Authority)
        TriggerCount, LastTriggerings, MaterialName;
}

simulated function PostBeginPlay()
{
    SetTimer(0.1, true);
}

function SetMaterialToTrigger(string NewMaterial)
{
    MaterialName = NewMaterial;
}

function TriggerMaterial(Actor Other, Pawn EventInstigator)
{
    ++TriggerCount;

    LastTriggerings[TriggerCount % arraycount(LastTriggerings)].Triggerer = Other;
    LastTriggerings[TriggerCount % arraycount(LastTriggerings)].EventInstigator = EventInstigator;
    LastTriggerings[TriggerCount % arraycount(LastTriggerings)].TriggerAction = 1;
}

function ResetMaterial()
{
    ++TriggerCount;

    LastTriggerings[TriggerCount % arraycount(LastTriggerings)].TriggerAction = 2;
}

simulated function Timer()
{
    if (MaterialName != "" && MaterialToTrigger == none)
    {
        MaterialToTrigger = material(DynamicLoadObject(MaterialName, class'Material'));

        if (MaterialToTrigger != none)
        {
            MaterialToTrigger.Reset();
        }
    }

    if (MaterialToTrigger != none && TriggerCount > ClientTriggerCount && LastTriggerings[(ClientTriggerCount + 1) % arraycount(LastTriggerings)].TriggerAction != 0)
    {
        ++ClientTriggerCount;

        if (LastTriggerings[ClientTriggerCount % arraycount(LastTriggerings)].TriggerAction == 2)
        {
            MaterialToTrigger.Reset();
        }
        else
        {
            MaterialToTrigger.Trigger(
                LastTriggerings[ClientTriggerCount % arraycount(LastTriggerings)].Triggerer,
                LastTriggerings[ClientTriggerCount % arraycount(LastTriggerings)].EventInstigator);
        }
    }
}
