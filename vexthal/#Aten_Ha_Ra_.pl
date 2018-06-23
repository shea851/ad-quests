
sub EVENT_SPAWN {
     quest::settimer("depop",3600); # 1 hr to kill
}

sub EVENT_AGGRO {
	quest::settimer("recheckbosses",8);  # keep the exploiters at bay
}

sub EVENT_TIMER {
	if ($timer eq "depop") {
		quest::shout("I haven't the time nor the luxury...");
		quest::stoptimer("depop");
		quest::depop();
	}
	if ($timer eq "recheckbosses") {
		@fightcheck = (158014,158010,158015,158012,158013,158007,158008,158011,158009);
		foreach $bosscheck (@fightcheck) {
			if ($entity_list->GetMobByNpcTypeID($bosscheck)) {
				$entity_list->GetMobByNpcTypeID($bosscheck)->AddToHateList($client,1);
				quest::shout("".$entity_list->GetMobByNpcTypeID($bosscheck)->GetCleanName()." attack ".$client->GetCleanName().", finish this scum!");
			}
		}
	}	
}

sub EVENT_KILLED_MERIT
{
	quest::setglobal("atencooldown",1,7,"H6");  ## 6 hour cooldown timer on Aten
	plugin::KillMerit();
}

sub EVENT_DEATH_COMPLETE {
	quest::shout("Blaaaarrgghhhh......");
}

