# Author:  Corporate
# Date:    20180115
# Purpose: Lore Keeper / SoulBinder

sub EVENT_TIMER
{
	if ($timer eq "faction_timer")
	{
		quest::stoptimer("faction_timer");
		$faction_pause = 0;
	}
}

sub EVENT_SAY {
	if ($text=~/Hail/i) {
		plugin::Whisper("Hi!!! Welcome! Don't you just like looove my hair? I'm totally doing the pixie thing. Oh yeah, did you need my help? I can like [".quest::saylink("Bind your soul",1)."] or [".quest::saylink("Translocate you to your bind spot",1)."] and stuff."); 
		plugin::Whisper("Ohhh yeahhh I also got this new app to check faction. Want me to check [".quest::saylink("your faction",1)."]?");
		plugin::Whisper("I'll probably have some lore stuff to tell you later, but not right now I'm texting my bff.");
	}
	elsif (($text=~/bind my soul/i) || ($text=~/bind your soul/i))
	{
		plugin::Whisper("Are you [".quest::saylink("absolutely positive",1)."]?"); 
	}
	elsif ($text=~/absolutely positive/i)
	{
		quest::emote("does magical soul binding stuff.");
		quest::doanim(42);
		quest::selfcast(2049);
	}
    elsif ($text=~/translocate/i)
    {
        quest::emote("does magical translocation stuff.");
        quest::doanim(42);
        quest::selfcast(1422);
    }
	elsif ($text=~/your faction/i)
	{
		if ($faction_pause == 0)
		{
			$client->Message(15, $client->GetName()." faction values:");
			#$client->Message(15, "[ Ally :: 1101 ~ Above ]");
			#$client->Message(15, "[ Warmly :: 701 ~ 1100 ]");
			#$client->Message(15, "[ Kindly :: 401 ~ 700 ]");
			#$client->Message(15, "[ Amiably :: 101 ~ 400 ]");
			#$client->Message(15, "[ Indifferently :: 0 ~ 100 ]");
			#$client->Message(15, "[ Apprehensively :: -1 ~ -100 ]");
			#$client->Message(15, "[ Dubiously :: -101 ~ -700 ]");
			#$client->Message(15, "[ Threateningly :: -701 ~ -999 ]");
			#$client->Message(15, "[ Ready to attack :: -1000 ~ Below ]");
			
			my @factionNames = plugin::GetFactionNamesByID($charid);
			foreach my $factionName (@factionNames)
			{
				my $facVal = $client->GetModCharacterFactionLevel(plugin::GetFactionIDByName($factionName));
				my $facText = plugin::GetFactionText($facVal);
				$client->Message(14, "--- ".$factionName." [ ".$facVal." | ".$facText." ]");
			}
			quest::settimer("faction_timer", 5);
			$faction_pause = 1;
		}
		else
		{
			plugin::Whisper("Hang on, checking my phone!");
		}
	}
}