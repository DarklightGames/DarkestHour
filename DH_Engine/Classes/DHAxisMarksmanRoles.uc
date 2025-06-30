//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHAxisMarksmanRoles extends DHAxisRoles
    abstract;

defaultproperties
{
    // Historically, there was no "marksman" type role within the Wehrmacht or Waffen-SS, however the ZF41 was given
    // out to fullfill this role and there was no distinction between snipers with or without.
    MyName="Marksman"   // https://www.youtube.com/watch?v=sBstpqUAniw Reference to the marksman being part of the TOE for the Wehrmacht and SS.
    AltName="Scharfsch�tze" // The native role name reflects this, but the translated name is there so that people can understand that this isnt a true sniper.
    Limit=2
    bExemptSquadRequirement=false
    bCanBeSquadLeader=false
}
