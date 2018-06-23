
sub EVENT_SPAWN {
	quest::shout("How dare you enter my lair!  You will suffer.");
	quest::depopall(124021);
	quest::depopall(124080);
	quest::depopall(124157);
}

sub EVENT_AGGRO {
	quest::settimer("checkdragons", 15);  # keep the exploiters at bay
}

sub EVENT_TIMER {
	if ($timer eq "checkdragons") {
		@dragoncheck = (124077,124076,124008,124103,124074,124017);
		foreach $checkboss (@dragoncheck) {
			if ($entity_list->GetMobByNpcTypeID($checkboss)) {
				$entity_list->GetMobByNpcTypeID($checkboss)->AddToHateList($client,1);
				quest::shout("".$entity_list->GetMobByNpcTypeID($checkboss)->GetCleanName()." attack ".$client->GetCleanName().", I command you!");
			}
		}
	}
}

sub EVENT_KILLED_MERIT
{
	quest::setglobal("vulakcooldown",1,7,"H6");  ## 6 hour cooldown timer on Vulak
	plugin::KillMerit();
}

sub EVENT_DEATH_COMPLETE {
	quest::shout("Inconceivable! How can this be.......");
}