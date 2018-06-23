# Modified by Corporate
# Date: 20160925
# Purpose: Kunark access/flagger
# Notes: Based on script by Ghanja whom seems to have modified Kingly_Krab's "Zone.pl"

no warnings;

sub EVENT_SAY {

	my $zoneaccessgroup = "Kunark";
	my @killsarray = ("Lord Nagafen","Lady Vox","Phinigel Autropos","Cazic Thule","Innoruuk","Eye of Veeshan");
	my $flaglevelgiven = 2;
	my $maxLevelGiven = 60;
	my @portzones = ("fieldofbone","firiona","emeraldjungle","overthere","skyfire","dreadlands","timorous");
	my @openPortZones = ("citymist","kurn","lakeofillomen","dalnir");

	if ($text ~~ @openPortZones) {
		quest::say("$name, off you go..");
		quest::doanim(42);
		quest::zone($text);
	}

	if (($text ~~ @portzones) && ($qglobals{"flagaccess"} >= $flaglevelgiven)) {
		quest::say("$name, off you go..");
		quest::doanim(42);
		quest::zone($text);
	}
	
	if ($text =~/Hail/i) {
		plugin::Whisper ("Where would you like to go?");
		foreach $openPortZone (@openPortZones) {
			plugin::Whisper("[".quest::saylink($openPortZone,1,plugin::Zone(plugin::ZoneIDBySN($openPortZone)))."]");
		}
		if ((defined $qglobals{"flagaccess"}) && ($qglobals{"flagaccess"} >= $flaglevelgiven)) {
			foreach $portzone (@portzones) {
				plugin::Whisper("[".quest::saylink($portzone,1,plugin::Zone(plugin::ZoneIDBySN($portzone)))."]");
			}
		}
		else
		{		
			plugin::Whisper("Greetings $name! I can grant you progression access to ".$zoneaccessgroup.". Would you like to check your "."[".quest::saylink ("kills",1)."] progression? ");
		}
	}
	elsif ($text =~/kills/i)
	{
		$npckills = 0;
		foreach my $knpc (@killsarray) {
			if ((not defined $qglobals{$knpc}) || ($qglobals{$knpc} == 0)) {
				$client->Message(13, "".quest::saylink($knpc,1)." has NOT been slain!");
			}
			else {
				$client->Message(10, "".quest::saylink($knpc,1)." has been slain!");
				++$npckills;
			}
		}
		if ($npckills == scalar(@killsarray)) {
			if ($qglobals{"flagaccess"} < $flaglevelgiven) {
				$client->Message (15, "Congratulations!  You are now flagged to enter ".$zoneaccessgroup." zones.");
				quest::setglobal("flagaccess", $flaglevelgiven, 5, "F");
			}
			if ($qglobals{"CharMaxLevel"} < $maxLevelGiven) {
				$client->Message (15, "Your level cap has been increased to ".$maxLevelGiven.".");
				quest::setglobal("CharMaxLevel",$maxLevelGiven,5,"F");
			}
		}
	}
	
	# Charm quest
	my $charm_t1 = 133000;

	if ((defined $qglobals{"flagaccess"}) && ($qglobals{"flagaccess"} >= $flaglevelgiven) && ($hasitem{$charm_t1})) {
		if ($text =~/Hail/i) {
				plugin::Whisper("I can't believe you're drinking that. Do me a "."[".quest::saylink ("favor",1)."] and I'll help you out.");
		}
		elsif ($text =~/favor/i) {
			plugin::Whisper("I'm a bit of an amateur brewer myself... I think we can work out a deal. I've heard of a froglok who has a legendary lager recipe. No doubt he's come into possession of this from someone who drank too much and was unable to pay their bill!");
			plugin::Whisper("If you bring me the recipe, I'll brew up a batch and let you have the first drink! One last thing, you must promise me you'll let me dump out that water you're drinking now.");
		}
	}

}


sub EVENT_ITEM {
	
	# Charm quest
	my $charm_t1 = 133000;
	my $charm_t2 = 133018;
	my $quest_t1 = 133022;

	if (plugin::check_handin(\%itemcount, $charm_t1 => 1, $quest_t1 => 1))
	{
		plugin::Whisper("Drink up!");
		quest::summonitem($charm_t2);
	}
	if ($platinum != 0 || $gold !=0 || $silver != 0 || $copper != 0)
	{
		quest::givecash($copper, $silver, $gold, $platinum);

	}
	plugin::return_items(\%itemcount);

}