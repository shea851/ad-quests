# Modified by Corporate
# Date: 20161107
# Purpose: Planes of Power access/flagger
# Notes: Based on script by Ghanja whom seems to have modified Kingly_Krab's "Zone.pl"

no warnings;

sub EVENT_SAY {

	my $zoneaccessgroup = "The Planes of Power";
	my @killsarray = ("Grieg Veneficus","Shei Vinitras","Vyzh`dra the Cursed","Aten Ha Ra ");
	my $flaglevelgiven = 5;
	my @portzones = ("potranquility");

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
				#$client->Message (15, "Sorry, but you'll need to check back a little later for PoP access.");
			}
		}
	}

	# Charm quest
	my $charm_t4 = 133020;

	if ((defined $qglobals{"flagaccess"}) && ($qglobals{"flagaccess"} >= $flaglevelgiven) && ($hasitem{$charm_t4})) {
		if ($text =~/Hail/i) {	
			plugin::Whisper("Argh! I'm so "."[".quest::saylink ("mad",1)."]!");
		}
		elsif ($text =~/mad/i) {
			plugin::Whisper("Everyone always goes to Grummus' parties and never to mine. He has the best beer but won't share where it's from. Can you go talk to him and see what you can find out?");
		}
	}

}

sub EVENT_ITEM {
	
	# Charm quest
	my $charm_t4 = 133020;
	my $charm_t5 = 133021;
	my $quest_t4 = 133028;

	if (plugin::check_handin(\%itemcount, $charm_t4 => 1, $quest_t4 => 1))
	{
		plugin::Whisper("Ah, so he ships it in directly from Germany! Go figure! Here, have one, you deserve a reward.");
		quest::summonitem($charm_t5);
	}
	if ($platinum != 0 || $gold !=0 || $silver != 0 || $copper != 0)
	{
		quest::givecash($copper, $silver, $gold, $platinum);

	}
	plugin::return_items(\%itemcount);

}
