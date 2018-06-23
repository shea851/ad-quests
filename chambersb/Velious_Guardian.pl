# Modified by Corporate
# Date: 20161107
# Purpose: Velious access/flagger
# Notes: Based on script by Ghanja whom seems to have modified Kingly_Krab's "Zone.pl"

no warnings;

sub EVENT_SAY {

	my $zoneaccessgroup = "Velious";
	my @killsarray = ("Phara Dar","Druushk","Nexona","Silverwing","Hoshkar","Xygoz","Gorenaire","Trakanon","Severilous","Faydedar","Talendor","Venril Sathir");
	my $flaglevelgiven = 3;
	my $maxLevelGiven = 65;
	my @portzones = ("iceclad","eastwastes","westwastes","greatdivide","wakening","cobaltscar");
	my @openPortZones = ("crystal","frozenshadow");

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
	my $charm_t2 = 133018;

	if ((defined $qglobals{"flagaccess"}) && ($qglobals{"flagaccess"} >= $flaglevelgiven) && ($hasitem{$charm_t2})) {
		if ($text =~/Hail/i) {	
				plugin::Whisper("I heard the Kunark Guardian is quite the brewer. I owe her a favor, and all she ever wants are brewing ingedients to feed her addiction. Will you "."[".quest::saylink ("help me out",1)."] and I'll make it worth your while?");
		}
		elsif ($text =~/help me out/i) {
			plugin::Whisper("There's a barfly dwarf known for having the best oats in all of Velious - will you seek him out and collect some?");
			plugin::Whisper("Also, the Kunark Guardian tells me the secret to a good hearty stout is Efreeti blood. I look forward to your return!");
		}
	}

}


sub EVENT_ITEM {
	
	# Charm quest
	my $charm_t2 = 133018;
	my $charm_t3 = 133019;
	my $quest_t2_1 = 133023;
	my $quest_t2_2 = 133024;

	if (plugin::check_handin(\%itemcount, $charm_t2 => 1, $quest_t2_1 => 1, $quest_t2_2 => 1))
	{
		plugin::Whisper("Drink up!");
		quest::summonitem($charm_t3);
	}
	if ($platinum != 0 || $gold !=0 || $silver != 0 || $copper != 0)
	{
		quest::givecash($copper, $silver, $gold, $platinum);

	}
	plugin::return_items(\%itemcount);

}