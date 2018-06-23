# Modified by Corporate
# Date: 20161107
# Purpose: Luclin access/flagger
# Notes: Based on script by Ghanja whom seems to have modified Kingly_Krab's "Zone.pl"

no warnings;

sub EVENT_SAY {

	my $zoneaccessgroup = "Luclin";
	my @killsarray = ("Derakor the Vindicator","King Tormax","The Avatar of War","Tunare","Vulak`Aerr","Dain Frostreaver IV","Zlandicar","The Final Arbiter");
	my $flaglevelgiven = 4;
	my @portzones = ("nexus","grimling","paludal","scarlet","fungusgrove","katta","maiden");

	if (($text ~~ @portzones) && ($qglobals{"flagaccess"} >= $flaglevelgiven)) {
		quest::say("$name, off you go..");
		quest::doanim(42);
		quest::zone($text);
	}
	
	if ($text =~/Hail/i) {
		if ((defined $qglobals{"flagaccess"}) && ($qglobals{"flagaccess"} >= $flaglevelgiven)) {
			plugin::Whisper ("Where would you like to go?");
			foreach $portzone (@portzones) {
				plugin::Whisper("[".quest::saylink($portzone,1,plugin::Zone(plugin::ZoneIDBySN($portzone)))."]");
			}
		}
		else
		{		
			plugin::Whisper("Greetings $name! I can grant you access to ".$zoneaccessgroup.". Would you like to check your "."[".quest::saylink ("kills",1)."] progression? ");
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
		}
	}

	# Charm quest
	my $charm_t3 = 133019;

	if ((defined $qglobals{"flagaccess"}) && ($qglobals{"flagaccess"} >= $flaglevelgiven) && ($hasitem{$charm_t3})) {
		if ($text =~/Hail/i) {	
			plugin::Whisper("Hey, $name, I know of an IPA that is just "."[".quest::saylink ("out of this world",1)."].");
		}
		elsif ($text =~/out of this world/i) {
			plugin::Whisper("I'm a regular at a local microbrewery and they always cut me deals when I bring them Luclin ingredients. If you make it out to Shadow Haven look up the local alchemy vendor for something unique.");
			plugin::Whisper("It would also be absolutely amazing if you can get some Earth Elemental Flesh. It really adds a lot of 'earthiness' to the brew! I'm sure there's A LOT of flesh around somewhere.");
		}
	}

}


sub EVENT_ITEM {
	
	# Charm quest
	my $charm_t3 = 133019;
	my $charm_t4 = 133020;
	my $quest_t3_1 = 133025;
	my $quest_t3_2 = 133026;

	if (plugin::check_handin(\%itemcount, $charm_t3 => 1, $quest_t3_1 => 1, $quest_t3_2 => 1))
	{
		plugin::Whisper("Drink up!");
		quest::summonitem($charm_t4);
	}
	if ($platinum != 0 || $gold !=0 || $silver != 0 || $copper != 0)
	{
		quest::givecash($copper, $silver, $gold, $platinum);

	}
	plugin::return_items(\%itemcount);

}