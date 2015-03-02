//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ClientMaterialTrigger extends MaterialTrigger;

// whether triggering resets or triggers the materials
var(MaterialTrigger) enum ETriggerAction {
  TriggerTriggers,
  TriggerResets,
  TriggerDoesNothing
} TriggerAction;

// whether untriggering resets or triggers the materials
var(MaterialTrigger) enum EUnriggerAction {
  UntriggerDoesNothing,
  UntriggerTriggers,
  UntriggerResets
} UntriggerAction;

// array holding the ReplicationInfos for clientside triggering
var array<DH_MaterialTriggerReplicationInfo> ReplicatedMaterialTriggers;

//=============================================================================
// PostBeginPlay
//
// Spawns a MaterialTriggerReplicationInfo for each triggered material.
//=============================================================================

function PostBeginPlay()
{
  local int i;

  ReplicatedMaterialTriggers.Length = MaterialsToTrigger.Length;

  for (i = 0; i < MaterialsToTrigger.Length; ++i) {
    ReplicatedMaterialTriggers[i] = Spawn(class'DH_MaterialTriggerReplicationInfo', self);
    ReplicatedMaterialTriggers[i].SetMaterialToTrigger(string(MaterialsToTrigger[i]));
  }
}

//=============================================================================
// Trigger
//
// Tells the MTRIs about the Instigators and triggering actors and tells them
// to trigger the material.
//=============================================================================

function Trigger(Actor Other, Pawn EventInstigator)
{
  local int i;

  if (Other == none)
    Other = self;

  if (TriggerAction == TriggerTriggers) {
    for (i = 0; i < ReplicatedMaterialTriggers.Length; ++i)
      if (ReplicatedMaterialTriggers[i] != none)
        ReplicatedMaterialTriggers[i].TriggerMaterial(Other, EventInstigator);
  }
  else if (TriggerAction == TriggerResets) {
    for (i = 0; i < ReplicatedMaterialTriggers.Length; ++i)
      if (ReplicatedMaterialTriggers[i] != none)
        ReplicatedMaterialTriggers[i].ResetMaterial();
  }
}

//=============================================================================
// Untrigger
//
// Triggers or resets the materials depending on the UntriggerAction property.
//=============================================================================

function Untrigger(Actor Other, Pawn EventInstigator)
{
  local int i;

  if (Other == none)
    Other = self;

  if (UntriggerAction == UntriggerTriggers) {
    for (i = 0; i < ReplicatedMaterialTriggers.Length; ++i)
      if (ReplicatedMaterialTriggers[i] != none)
        ReplicatedMaterialTriggers[i].TriggerMaterial(Other, EventInstigator);
  }
  else if (UntriggerAction == UntriggerResets) {
    for (i = 0; i < ReplicatedMaterialTriggers.Length; ++i)
      if (ReplicatedMaterialTriggers[i] != none)
        ReplicatedMaterialTriggers[i].ResetMaterial();
  }
}

simulated function Reset()
{
    super.Reset();

    //TODO: Fix.
}

defaultproperties
{
}
