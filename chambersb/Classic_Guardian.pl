# Modified by Corporate
# Date: 20160925
# Purpose: Classic ports and classic planes access/flagger
# Notes: Some parts are based on script by Ghanja whom seems to have modified Kingly_Krab's "Zone.pl"

no warnings;

sub EVENT_SAY
{

	my $zoneaccessgroup = "Classic Planes";
	my @killsarray = ("Planar Protector of Guk","Planar Protector of Permafrost","Planar Protector of Unrest");
	my @namesarray = ("Planar Protector (froglok)","Planar Protector (goblin)","Planar Protector (skeleton)");
	my $flaglevelgiven = 1;
	my @portzones = ("butcher","cauldron","gfaydark","everfrost","innothule","nektulos","qeynos2","misty","oasis","southkarana","steamfont","stonebrunt","feerrott","lavastorm","tox","freportw");
	my @planes = ("airplane","fearplane","hateplane");

	if ($text ~~ @portzones)
	{
		quest::say("$name, off you go..");
		quest::doanim(42);
		quest::zone($text);
	}

	if ($text eq "Everfrost")
	{
		quest::say("$name, off you go..");
		quest::doanim(42);
		quest::zone("everfrost");
	}
	
	if (($text ~~ @planes) && (defined $qglobals{"flagaccess"}) && ($qglobals{"flagaccess"} >= $flaglevelgiven))
	{
		quest::say("$name, off you go..");
		quest::doanim(42);
		quest::zone($text);
	}	
	
	if ($text =~/Hail/i)
	{
		plugin::Whisper ("Where would you like to go?");
		foreach $portzone (@portzones)
		{
			plugin::Whisper("[".quest::saylink($portzone,1,plugin::Zone(plugin::ZoneIDBySN($portzone)))."]");
		}
		if (not defined $qglobals{"flagaccess"})
		{
			plugin::Whisper("Are you interested in access to the "."[".quest::saylink("Classic Planes",1)."]?");
			plugin::Whisper("Or would you like to check your "."[".quest::saylink ("kills",1)."] progression? ");
		}
		if ((defined $qglobals{"flagaccess"}) && ($qglobals{"flagaccess"} >= $flaglevelgiven))
		{
			foreach $plane (@planes)
			{
				plugin::Whisper("[".quest::saylink($plane,1,plugin::Zone(plugin::ZoneIDBySN($plane)))."]");
			}
		}		
	}
	elsif ($text =~/kills/i)
	{
		$npckills = 0;
		for ($i=0; $i < scalar(@killsarray); $i++)
		{
			if ((not defined $qglobals{$killsarray[$i]}) || ($qglobals{$killsarray[$i]} == 0))
			{
				$client->Message(13, "".quest::saylink($namesarray[$i],1)." has NOT been slain!");
			}
			else
			{
				$client->Message(10, "".quest::saylink($namesarray[$i],1)." has been slain!");
				++$npckills;
			}
		}
		
		if ($npckills == scalar(@killsarray))
		{
			if ($qglobals{"flagaccess"} < $flaglevelgiven && $client->GetLevel() >= 46)
			{
				$client->Message(15, "Congratulations!  You are now flagged to enter ".$zoneaccessgroup." zones.");
				quest::setglobal("flagaccess", $flaglevelgiven, 5, "F");
			}
			else
			{
				$client->Message(15, "You must be at least level 46 to enter the planes.");
			}
		}
	}
	elsif ($text =~/Classic Planes/i)
	{
		plugin::Whisper("I can send you to the planar realms only if the magic protecting them is weakened.  Please seek out and destroy the three protectors.  I have never seen them in the place they call home, but I can tell you this - keep your eye out for a froglok, goblin, and skeleton!");
	}
	
}
