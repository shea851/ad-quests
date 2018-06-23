# Author:  Corporate
# Date:    20171116
# Purpose: AA exchange for end game players


sub EVENT_SAY {

	my $dadtokenID = 133016;
	my $unspentAA = $client->GetAAPoints();

	if ($text=~/Hail/i)
	{
		plugin::Whisper("Really? You're still on EQ in your \"fantasy world\"? You do realize the trash needs taken out and the kids are hungry for dinner, right??");
		plugin::Whisper("How about I [".quest::saylink("exchange your unspent AA",1)."] and then you log off and take a look at your honey-do list?");
	}
	elsif ($text=~/exchange your unspent AA/i)
	{
		if ($unspentAA < 5)
		{
			plugin::Whisper("You don't have enough unspent AA to exchange.");
		}
		
		if ($unspentAA >= 5)
		{
			plugin::Whisper("[".quest::saylink("Exchange 5 AA for 1 Dad Token",1)."]");
		}
		
		if ($unspentAA >= 25)
		{
			plugin::Whisper("[".quest::saylink("Exchange 25 AA for 5 Dad Tokens",1)."]");
		}
	}
	elsif ($text=~/Exchange 5 AA for 1 Dad Token/i)
	{
		if ($unspentAA >= 5)
		{
			plugin::Whisper("Trade 5 AA for 1 Dad Token - Are you sure? [".quest::saylink("1for5confirmed", 1, "Yes")."]");
		}
		else
		{
			plugin::Whisper("Nice try. You don't have enough unspent AA to exchange.");
		}
	}
	elsif ($text=~/1for5confirmed/i)
	{
		if ($unspentAA >= 5)
		{
			$client->SetAAPoints($unspentAA - 5);
			$client->SummonItem($dadtokenID, 1, 0);
		}
		else
		{
			plugin::Whisper("Nice try. You don't have enough unspent AA to exchange.");
		}
	}
	elsif ($text=~/Exchange 25 AA for 5 Dad Tokens/i)
	{
		if ($unspentAA >= 25)
		{
			plugin::Whisper("Trade 25 AA for 5 Dad Tokens - Are you sure? [".quest::saylink("5for25confirmed", 1, "Yes")."]");
		}
		else
		{
			plugin::Whisper("Nice try. You don't have enough unspent AA to exchange.");
		}
	}
	elsif ($text=~/5for25confirmed/i)
	{
		if ($unspentAA >= 25)
		{
			$client->SetAAPoints($unspentAA - 25);
			$client->SummonItem($dadtokenID, 5, 0);
		}
		else
		{
			plugin::Whisper("Nice try. You don't have enough unspent AA to exchange.");
		}
	}

	# If someone, somehow, manages to subtract more AA than they actually have
	# then their AA will be set to literally 4.2 trillion, so this is why this
	# protection exists. In theory, and in all testing, this statement should
	# be impossible to reach.
	if ($client->GetAAPoints() > $unspentAA)
	{
		$client->SetAAPoints($unspentAA);
		plugin::Whisper("Please contact a GM. There has been an error with the AA exchange.");
	}
	
}