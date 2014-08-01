//=============================================================================
// MaterialTriggerReplicationInfo
// Copyright 2003 by Wormbo
//
// Used by ClientMaterialTrigger to replicate material trigger events to
// network clients.
//=============================================================================


class DH_MaterialTriggerReplicationInfo extends ReplicationInfo;


//=============================================================================
// Variables
//=============================================================================

var Material MaterialToTrigger;
var string MaterialName;
var int ClientTriggerCount;
var int ClientUnTriggerCount;
var int TriggerCount;
var struct TTriggerData {
  var Actor Triggerer;
  var Pawn EventInstigator;
  var byte TriggerAction; // 0 = nothing/idle, 1 = trigger, 2 = reset
} LastTriggerings[10];


//=============================================================================
// Replication
//=============================================================================

replication
{
  reliable if (Role == ROLE_Authority)
    TriggerCount, LastTriggerings, MaterialName;
}


simulated function PostBeginPlay()
{
  SetTimer(0.1, true);
}


function SetMaterialToTrigger(string newMaterial)
{
  MaterialName = newMaterial;
}


function TriggerMaterial(Actor Other, Pawn EventInstigator)
{
  TriggerCount++;
  LastTriggerings[TriggerCount % 10].Triggerer = Other;
  LastTriggerings[TriggerCount % 10].EventInstigator = EventInstigator;
  LastTriggerings[TriggerCount % 10].TriggerAction = 1;
}


function ResetMaterial()
{
  TriggerCount++;
  LastTriggerings[TriggerCount % 10].TriggerAction = 2;
}


simulated function Timer()
{
  if (MaterialName != "" && MaterialToTrigger == none) {
    MaterialToTrigger = Material(DynamicLoadObject(MaterialName, class'Material'));
    if (MaterialToTrigger != none)
      MaterialToTrigger.Reset();
  }

  if (MaterialToTrigger != none && TriggerCount > ClientTriggerCount
      && LastTriggerings[(ClientTriggerCount + 1) % 10].TriggerAction != 0) {
    ClientTriggerCount++;
    if (LastTriggerings[ClientTriggerCount % 10].TriggerAction == 2)
      MaterialToTrigger.Reset();
    else
      MaterialToTrigger.Trigger(LastTriggerings[ClientTriggerCount % 10].Triggerer,
          LastTriggerings[ClientTriggerCount % 10].EventInstigator);
  }
}

defaultproperties
{
}
