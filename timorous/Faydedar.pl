sub EVENT_SPAWN { 
if ($entity_list->IsMobSpawnedByNpcTypeID(96073)){
quest::depop();
  }
}

sub EVENT_KILLED_MERIT
{
	plugin::KillMerit();
}
