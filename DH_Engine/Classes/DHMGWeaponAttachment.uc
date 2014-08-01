class DHMGWeaponAttachment extends DHHighROFWeaponAttachment
	abstract;

var bool		bSpawnShellsOutBottom;	// Shells eject from the bottom not the side

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		bSpawnShellsOutBottom;
}

simulated function SpawnShells(float amountPerSec)
{
  	local 	coords 		ejectorloc;
  	local 	rotator 	ejectorrot;
  	local 	vector		spawnlocation;

	if (!bSpawnShellsOutBottom)
	{
		super.SpawnShells(amountPerSec);
		return;
	}

    if ((Instigator != none) && !Instigator.IsFirstPerson()
		&& ROShellCaseClass != none)
    {
  		ejectorloc = GetBoneCoords(ShellEjectionBoneName);
  		ejectorrot = rotator(Normal(PhysicsVolume.Gravity));//GetBoneRotation(ShellEjectionBoneName);

		// for some reason, the bone origin to too far forward
		spawnlocation = ejectorloc.Origin;

		ejectorrot.Pitch += rand(1700);
  		ejectorrot.Yaw += rand(1700);
  		ejectorrot.Roll += rand(700);

		Spawn(ROShellCaseClass,Instigator,,spawnlocation,ejectorrot);
	}
}

defaultproperties
{
     bSpawnShellsOutBottom=true
}
